page 80006 "Item Sync API"
{
    PageType = API;
    APIPublisher = 'pristine';
    APIGroup = 'erp';
    APIVersion = 'v1.0';
    EntityName = 'syncItem';
    EntitySetName = 'syncItems';
    SourceTable = Item;
    ODataKeyFields = "No.";
    DelayedInsert= true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(itemNo; Rec."No.") { }
                field(description; Rec.Description) { }
                field(blocked; Rec.Blocked) { }
                field(baseUOM; Rec."Base Unit of Measure") { }
                field(purchUOM; Rec."Purch. Unit of Measure") { }
                field(salesUOM; Rec."Sales Unit of Measure") { }
                field(itemCategoryCode; Rec."Item Category Code") { }
                field(genProdPostingGroup; Rec."Gen. Prod. Posting Group") { }
                field(inventoryPostingGroup; Rec."Inventory Posting Group") { }
                field(itemTrackingCode; Rec."Item Tracking Code") { }
                field(gstGroupCode; Rec."GST Group Code") { }
                field(hsnSAC; Rec."HSN/SAC Code") { }
                field(specificGravity; Rec."Specific Gravity") { }
                field(casNumber; Rec."CAS Number") { }
                field(productFamilyCode; Rec."Product Family Code") { }
                field(productFamilyName; Rec."Product Family Name") { }
            }
        }
    }
}