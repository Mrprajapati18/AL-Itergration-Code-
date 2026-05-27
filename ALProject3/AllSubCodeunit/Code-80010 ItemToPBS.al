

codeunit 80010 "Sync Item To PBS"
{
    procedure SyncItemToERP(ItemsJson: Text) ResponseJson: Text
    var
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        ItemObject: JsonObject;
        ResponseObject: JsonObject;
        Item: Record Item;
        ItemNo: Code[20];
        IsNew: Boolean;
    begin
        if not ParseItemsArray(ItemsJson, JsonArray) then begin
            ResponseObject.Add('condition', 'false');
            ResponseObject.Add('message', 'Invalid JSON format or missing Items array.');
            ResponseObject.WriteTo(ResponseJson);
            exit;
        end;

        // Iterate each item in the array
        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then begin
                ItemObject := JsonToken.AsObject();
                ItemNo := GetTextValue(ItemObject, 'ItemNo');

                if ItemNo = '' then begin
                    ResponseObject.Add('condition', 'false');
                    ResponseObject.Add('message', 'ItemNo cannot be empty.');
                    ResponseObject.WriteTo(ResponseJson);
                    exit;
                end;

                // Check if Item exists -> Insert or Modify
                IsNew := not Item.Get(ItemNo);
                if IsNew then begin
                    Item.Init();
                    Item."No." := ItemNo;
                    Item.Insert(true);
                end;

                // Map fields from JSON to Item record
                MapItemFields(ItemObject, Item);
                Item.Modify(true);
            end;
        end;

        ResponseObject.Add('condition', 'true');
        ResponseObject.Add('message', 'Item Synced Successfully');
        ResponseObject.WriteTo(ResponseJson);
    end;

    local procedure ParseItemsArray(InputJson: Text; var JsonArray: JsonArray): Boolean
    var
        RootObject: JsonObject;
        ArrayToken: JsonToken;
    begin
        if not RootObject.ReadFrom(InputJson) then
            exit(false);
        if not RootObject.Get('Items', ArrayToken) then
            exit(false);
        if not ArrayToken.IsArray() then
            exit(false);
        JsonArray := ArrayToken.AsArray();
        exit(true);
    end;

    local procedure MapItemFields(ItemObject: JsonObject; var Item: Record Item)
    var
        TypeText: Text;
        BlockedText: Text;
    begin
        // Description
        Item.Description := CopyStr(GetTextValue(ItemObject, 'Description'), 1, MaxStrLen(Item.Description));

        // Type: Inventory / Non-Inventory / Service
        TypeText := GetTextValue(ItemObject, 'Type');
        case UpperCase(TypeText) of
            'INVENTORY':
                Item.Type := Item.Type::Inventory;
            'NON-INVENTORY':
                Item.Type := Item.Type::"Non-Inventory";
            'SERVICE':
                Item.Type := Item.Type::Service;
        end;

        // Blocked flag
        BlockedText := GetTextValue(ItemObject, 'Blocked');
        Item.Blocked := (BlockedText = '1') or (UpperCase(BlockedText) = 'TRUE');

        // Units of Measure
        if GetTextValue(ItemObject, 'BaseUOM') <> '' then
            Item."Base Unit of Measure" := CopyStr(GetTextValue(ItemObject, 'BaseUOM'), 1, MaxStrLen(Item."Base Unit of Measure"));

        if GetTextValue(ItemObject, 'PurchUOM') <> '' then
            Item."Purch. Unit of Measure" := CopyStr(GetTextValue(ItemObject, 'PurchUOM'), 1, MaxStrLen(Item."Purch. Unit of Measure"));

        if GetTextValue(ItemObject, 'SalesUOM') <> '' then
            Item."Sales Unit of Measure" := CopyStr(GetTextValue(ItemObject, 'SalesUOM'), 1, MaxStrLen(Item."Sales Unit of Measure"));

        // Item Category
        if GetTextValue(ItemObject, 'ItemCategoryCode') <> '' then
            Item."Item Category Code" := CopyStr(GetTextValue(ItemObject, 'ItemCategoryCode'), 1, MaxStrLen(Item."Item Category Code"));

        // Posting Groups
        if GetTextValue(ItemObject, 'GenProdPostingGroup') <> '' then
            Item."Gen. Prod. Posting Group" := CopyStr(GetTextValue(ItemObject, 'GenProdPostingGroup'), 1, MaxStrLen(Item."Gen. Prod. Posting Group"));

        if GetTextValue(ItemObject, 'InventoryPostingGroup') <> '' then
            Item."Inventory Posting Group" := CopyStr(GetTextValue(ItemObject, 'InventoryPostingGroup'), 1, MaxStrLen(Item."Inventory Posting Group"));

        // Costing Method
        SetCostingMethod(Item, GetTextValue(ItemObject, 'CostingMethod'));

        // GST Fields
        if GetTextValue(ItemObject, 'GSTGroupCode') <> '' then
            Item."GST Group Code" := CopyStr(GetTextValue(ItemObject, 'GSTGroupCode'), 1, MaxStrLen(Item."GST Group Code"));

        if GetTextValue(ItemObject, 'HSN_SAC') <> '' then
            Item."HSN/SAC Code" := CopyStr(GetTextValue(ItemObject, 'HSN_SAC'), 1, MaxStrLen(Item."HSN/SAC Code"));

        SetGSTCredit(Item, GetTextValue(ItemObject, 'GSTCredit'));

        // Item Tracking Code
        if GetTextValue(ItemObject, 'ItemTrackingCode') <> '' then
            Item."Item Tracking Code" := CopyStr(GetTextValue(ItemObject, 'ItemTrackingCode'), 1, MaxStrLen(Item."Item Tracking Code"));
    end;

    local procedure SetCostingMethod(var Item: Record Item; MethodText: Text)
    begin
        case UpperCase(MethodText) of
            'FIFO':
                Item."Costing Method" := Item."Costing Method"::FIFO;
            'LIFO':
                Item."Costing Method" := Item."Costing Method"::LIFO;
            'AVERAGE':
                Item."Costing Method" := Item."Costing Method"::Average;
            'SPECIFIC':
                Item."Costing Method" := Item."Costing Method"::Specific;
            'STANDARD':
                Item."Costing Method" := Item."Costing Method"::Standard;
        end;
    end;

    local procedure SetGSTCredit(var Item: Record Item; GSTCreditText: Text)
    begin
        case UpperCase(GSTCreditText) of
            'AVAILMENT':
                Item."GST Credit" := Item."GST Credit"::Availment;
            'NON-AVAILMENT':
                Item."GST Credit" := Item."GST Credit"::"Non-Availment";
        end;
    end;

    local procedure GetTextValue(JsonObject: JsonObject; FieldName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(FieldName, JsonToken) then
            exit(JsonToken.AsValue().AsText());
        exit('');
    end;
}
