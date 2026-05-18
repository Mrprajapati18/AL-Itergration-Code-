
codeunit 50002 "PBS Integration"
{
    procedure SyncCustomerToERP(CustomersJson: Text) ResponseJson: Text
    var
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        CustomerObject: JsonObject;
        ResponseObject: JsonObject;
        Customer: Record Customer;
        CustomerNo: Code[20];
        IsNew: Boolean;
    begin
        if not ParseCustomersArray(CustomersJson, JsonArray) then begin
            ResponseObject.Add('condition', 'false');
            ResponseObject.Add('message', 'Invalid JSON format or missing Customers array.');
            ResponseObject.WriteTo(ResponseJson);
            exit;
        end;

        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then begin
                CustomerObject := JsonToken.AsObject();
                CustomerNo := GetTextValue(CustomerObject, 'CustomerNo');

                if CustomerNo = '' then begin
                    ResponseObject.Add('condition', 'false');
                    ResponseObject.Add('message', 'CustomerNo cannot be empty.');
                    ResponseObject.WriteTo(ResponseJson);
                    exit;
                end;

                IsNew := not Customer.Get(CustomerNo);
                if IsNew then begin
                    Customer.Init();
                    Customer."No." := CustomerNo;
                    Customer.Insert(true);
                end;

                MapCustomerFields(CustomerObject, Customer);
                Customer.Modify(true);

                // Process Ship-To Addresses
                SyncShipToAddresses(CustomerObject, CustomerNo);
            end;
        end;

        ResponseObject.Add('condition', 'true');
        ResponseObject.Add('message', 'Customer Synced Successfully');
        ResponseObject.WriteTo(ResponseJson);
    end;

    local procedure ParseCustomersArray(InputJson: Text; var JsonArray: JsonArray): Boolean
    var
        RootObject: JsonObject;
        ArrayToken: JsonToken;
    begin
        if not RootObject.ReadFrom(InputJson) then
            exit(false);
        if not RootObject.Get('Customers', ArrayToken) then
            exit(false);
        if not ArrayToken.IsArray() then
            exit(false);
        JsonArray := ArrayToken.AsArray();
        exit(true);
    end;

    local procedure MapCustomerFields(CustomerObject: JsonObject; var Customer: Record Customer)
    var
        BlockedText: Text;
    begin
        // Basic Info
        Customer.Name := CopyStr(GetTextValue(CustomerObject, 'Name'), 1, 100);
        Customer.Address := CopyStr(GetTextValue(CustomerObject, 'Address1'), 1, 100);
        Customer."Address 2" := CopyStr(GetTextValue(CustomerObject, 'Address2'), 1, 50);
        Customer.City := CopyStr(GetTextValue(CustomerObject, 'City'), 1, 30);
        Customer."Post Code" := CopyStr(GetTextValue(CustomerObject, 'PostCode'), 1, 20);

        // State & Country
        if GetTextValue(CustomerObject, 'StateCode') <> '' then
            Customer."State Code" := CopyStr(GetTextValue(CustomerObject, 'StateCode'), 1, 10);

        if GetTextValue(CustomerObject, 'CountryCode') <> '' then
            Customer."Country/Region Code" := CopyStr(GetTextValue(CustomerObject, 'CountryCode'), 1, 10);

        // Posting Groups
        if GetTextValue(CustomerObject, 'GenBusPostingGrp') <> '' then
            Customer."Gen. Bus. Posting Group" := CopyStr(GetTextValue(CustomerObject, 'GenBusPostingGrp'), 1, 20);

        if GetTextValue(CustomerObject, 'CustomerPostingGrp') <> '' then
            Customer."Customer Posting Group" := CopyStr(GetTextValue(CustomerObject, 'CustomerPostingGrp'), 1, 20);

        // PAN Details
        if GetTextValue(CustomerObject, 'PANNo') <> '' then
            Customer."P.A.N. No." := CopyStr(GetTextValue(CustomerObject, 'PANNo'), 1, 20);

        if GetTextValue(CustomerObject, 'PANStatus') <> '' then
            Evaluate(Customer."P.A.N. Status", GetTextValue(CustomerObject, 'PANStatus'));

        if GetTextValue(CustomerObject, 'PANRefNo') <> '' then
            Customer."P.A.N. Reference No." := CopyStr(GetTextValue(CustomerObject, 'PANRefNo'), 1, 20);

        // Assesse Code
        if GetTextValue(CustomerObject, 'AssesseCode') <> '' then
            Customer."Assessee Code" := CopyStr(GetTextValue(CustomerObject, 'AssesseCode'), 1, 10);

        // GST Details
        if GetTextValue(CustomerObject, 'GSTCustomerType') <> '' then
            SetGSTCustomerType(Customer, GetTextValue(CustomerObject, 'GSTCustomerType'));

        if GetTextValue(CustomerObject, 'GSTRegNo') <> '' then
            Customer."GST Registration No." := CopyStr(GetTextValue(CustomerObject, 'GSTRegNo'), 1, 20);

        // Contact Info
        if GetTextValue(CustomerObject, 'ContactPersonName') <> '' then
            Customer.Contact := CopyStr(GetTextValue(CustomerObject, 'ContactPersonName'), 1, 100);

        if GetTextValue(CustomerObject, 'CustomerEmail') <> '' then
            Customer."E-Mail" := CopyStr(GetTextValue(CustomerObject, 'CustomerEmail'), 1, 80);

        if GetTextValue(CustomerObject, 'CustomerPhoneNo') <> '' then
            Customer."Phone No." := CopyStr(GetTextValue(CustomerObject, 'CustomerPhoneNo'), 1, 30);

        // Category & Currency
        if GetTextValue(CustomerObject, 'CurrencyCode') <> '' then
            Customer."Currency Code" := CopyStr(GetTextValue(CustomerObject, 'CurrencyCode'), 1, 10);

        // Credit Limit
        if GetTextValue(CustomerObject, 'CreditLimit') <> '' then
            Evaluate(Customer."Credit Limit (LCY)", GetTextValue(CustomerObject, 'CreditLimit'));

        // Blocked
        BlockedText := GetTextValue(CustomerObject, 'Blocked');
        SetCustomerBlocked(Customer, BlockedText);
    end;

    local procedure SetGSTCustomerType(var Customer: Record Customer; GSTTypeText: Text)
    begin
        case UpperCase(GSTTypeText) of
            'REGISTERED':
                Customer."GST Customer Type" := Customer."GST Customer Type"::Registered;
            'UNREGISTERED':
                Customer."GST Customer Type" := Customer."GST Customer Type"::Unregistered;
            'EXPORT':
                Customer."GST Customer Type" := Customer."GST Customer Type"::Export;
            'DEEMED EXPORT':
                Customer."GST Customer Type" := Customer."GST Customer Type"::"Deemed Export";
            'SEZ UNIT':
                Customer."GST Customer Type" := Customer."GST Customer Type"::"SEZ Unit";
            'SEZ DEVELOPMENT':
                Customer."GST Customer Type" := Customer."GST Customer Type"::"SEZ Development";
        end;
    end;

    local procedure SetCustomerBlocked(var Customer: Record Customer; BlockedText: Text)
    begin
        case UpperCase(BlockedText) of
            '', '0', 'FALSE':
                Customer.Blocked := Customer.Blocked::" ";
            'SHIP':
                Customer.Blocked := Customer.Blocked::Ship;
            'INVOICE':
                Customer.Blocked := Customer.Blocked::Invoice;
            'ALL', '1', 'TRUE':
                Customer.Blocked := Customer.Blocked::All;
        end;
    end;

    local procedure SyncShipToAddresses(CustomerObject: JsonObject; CustomerNo: Code[20])
    var
        ShipToArrayToken: JsonToken;
        ShipToToken: JsonToken;
        ShipToArray: JsonArray;
        ShipToObject: JsonObject;
        ShipToAddress: Record "Ship-to Address";
        ShipToCode: Code[10];
    begin
        if not CustomerObject.Get('ShipTo_Address', ShipToArrayToken) then
            exit;
        if not ShipToArrayToken.IsArray() then
            exit;

        ShipToArray := ShipToArrayToken.AsArray();

        foreach ShipToToken in ShipToArray do begin
            if ShipToToken.IsObject() then begin
                ShipToObject := ShipToToken.AsObject();
                ShipToCode := CopyStr(GetTextValue(ShipToObject, 'ShipToCode'), 1, 10);

                if ShipToCode = '' then
                    ShipToCode := 'DEFAULT';

                if not ShipToAddress.Get(CustomerNo, ShipToCode) then begin
                    ShipToAddress.Init();
                    ShipToAddress."Customer No." := CustomerNo;
                    ShipToAddress.Code := ShipToCode;
                    ShipToAddress.Insert(true);
                end;

                ShipToAddress.Name := CopyStr(GetTextValue(ShipToObject, 'ShipToName'), 1, 100);
                ShipToAddress.Address := CopyStr(GetTextValue(ShipToObject, 'ShiptoAddress'), 1, 100);
                ShipToAddress."Address 2" := CopyStr(GetTextValue(ShipToObject, 'ShipToAddress2'), 1, 50);
                ShipToAddress.City := CopyStr(GetTextValue(ShipToObject, 'ShipToCity'), 1, 30);
                ShipToAddress."Post Code" := CopyStr(GetTextValue(ShipToObject, 'ShipToPostCode'), 1, 20);

                if GetTextValue(ShipToObject, 'ShipToState') <> '' then
                    ShipToAddress.State := CopyStr(GetTextValue(ShipToObject, 'ShipToState'), 1, 30);

                if GetTextValue(ShipToObject, 'ShipToCountry') <> '' then
                    ShipToAddress."Country/Region Code" := CopyStr(GetTextValue(ShipToObject, 'ShipToCountry'), 1, 10);

                if GetTextValue(ShipToObject, 'ShipToGSTRegNo') <> '' then
                    ShipToAddress."GST Registration No." := CopyStr(GetTextValue(ShipToObject, 'ShipToGSTRegNo'), 1, 20);

                if GetTextValue(ShipToObject, 'ShipToARNNo') <> '' then
                    ShipToAddress."ARN No." := CopyStr(GetTextValue(ShipToObject, 'ShipToARNNo'), 1, 20);

                ShipToAddress.Modify(true);
            end;
        end;
    end;

    // For Item

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

    // For Vendor

    procedure SyncVendorToERP(VendorsJson: Text) ResponseJson: Text
    var
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        VendorObject: JsonObject;
        ResponseObject: JsonObject;
        Vendor: Record Vendor;
        VendorNo: Code[20];
        IsNew: Boolean;
    begin
        if not ParseVendorsArray(VendorsJson, JsonArray) then begin
            ResponseObject.Add('condition', 'false');
            ResponseObject.Add('message', 'Invalid JSON format or missing Vendors array.');
            ResponseObject.WriteTo(ResponseJson);
            exit;
        end;

        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then begin
                VendorObject := JsonToken.AsObject();
                VendorNo := GetTextValue(VendorObject, 'VendorNo');

                if VendorNo = '' then begin
                    ResponseObject.Add('condition', 'false');
                    ResponseObject.Add('message', 'VendorNo cannot be empty.');
                    ResponseObject.WriteTo(ResponseJson);
                    exit;
                end;

                IsNew := not Vendor.Get(VendorNo);
                if IsNew then begin
                    Vendor.Init();
                    Vendor."No." := VendorNo;
                    Vendor.Insert(true);
                end;

                MapVendorFields(VendorObject, Vendor);
                Vendor.Modify(true);

                // Process Bank Accounts
                SyncVendorBankAccounts(VendorObject, VendorNo);

                // Process TDS Sections
                SyncTDSSections(VendorObject, VendorNo);
            end;
        end;

        ResponseObject.Add('condition', 'true');
        ResponseObject.Add('message', 'Vendor Synced Successfully');
        ResponseObject.WriteTo(ResponseJson);
    end;

    local procedure ParseVendorsArray(InputJson: Text; var JsonArray: JsonArray): Boolean
    var
        RootObject: JsonObject;
        ArrayToken: JsonToken;
    begin
        if not RootObject.ReadFrom(InputJson) then
            exit(false);
        if not RootObject.Get('Vendors', ArrayToken) then
            exit(false);
        if not ArrayToken.IsArray() then
            exit(false);
        JsonArray := ArrayToken.AsArray();
        exit(true);
    end;

    local procedure MapVendorFields(VendorObject: JsonObject; var Vendor: Record Vendor)
    var
        BlockedText: Text;
        TurnoverText: Text;
    begin
        // Basic Info
        Vendor.Name := CopyStr(GetTextValue(VendorObject, 'Name'), 1, 100);
        Vendor.Address := CopyStr(GetTextValue(VendorObject, 'Address1'), 1, 100);
        Vendor."Address 2" := CopyStr(GetTextValue(VendorObject, 'Address2'), 1, 50);
        Vendor.City := CopyStr(GetTextValue(VendorObject, 'City'), 1, 30);
        Vendor."Post Code" := CopyStr(GetTextValue(VendorObject, 'PostCode'), 1, 20);

        // State & Country
        if GetTextValue(VendorObject, 'StateCode') <> '' then
            Vendor."State Code" := CopyStr(GetTextValue(VendorObject, 'StateCode'), 1, 10);

        if GetTextValue(VendorObject, 'CountryCode') <> '' then
            Vendor."Country/Region Code" := CopyStr(GetTextValue(VendorObject, 'CountryCode'), 1, 10);

        // Posting Groups
        if GetTextValue(VendorObject, 'GenBusPostingGrp') <> '' then
            Vendor."Gen. Bus. Posting Group" := CopyStr(GetTextValue(VendorObject, 'GenBusPostingGrp'), 1, 20);

        if GetTextValue(VendorObject, 'VendorPostingGrp') <> '' then
            Vendor."Vendor Posting Group" := CopyStr(GetTextValue(VendorObject, 'VendorPostingGrp'), 1, 20);

        // Assesse Code
        if GetTextValue(VendorObject, 'AssesseCode') <> '' then
            Vendor."Assessee Code" := CopyStr(GetTextValue(VendorObject, 'AssesseCode'), 1, 10);

        // PAN Details
        if GetTextValue(VendorObject, 'PANNo') <> '' then
            Vendor."P.A.N. No." := CopyStr(GetTextValue(VendorObject, 'PANNo'), 1, 20);

        if GetTextValue(VendorObject, 'PANStatus') <> '' then
            Evaluate(Vendor."P.A.N. Status", GetTextValue(VendorObject, 'PANStatus'));

        if GetTextValue(VendorObject, 'PANRefNo') <> '' then
            Vendor."P.A.N. Reference No." := CopyStr(GetTextValue(VendorObject, 'PANRefNo'), 1, 20);

        // GST Details
        if GetTextValue(VendorObject, 'GSTVendorType') <> '' then
            SetGSTVendorType(Vendor, GetTextValue(VendorObject, 'GSTVendorType'));

        if GetTextValue(VendorObject, 'GSTRegNo') <> '' then
            Vendor."GST Registration No." := CopyStr(GetTextValue(VendorObject, 'GSTRegNo'), 1, 20);

        // Contact Info
        if GetTextValue(VendorObject, 'ContactPersonName') <> '' then
            Vendor.Contact := CopyStr(GetTextValue(VendorObject, 'ContactPersonName'), 1, 100);

        if GetTextValue(VendorObject, 'VendorEmail') <> '' then
            Vendor."E-Mail" := CopyStr(GetTextValue(VendorObject, 'VendorEmail'), 1, 80);

        if GetTextValue(VendorObject, 'VendorPhoneNo') <> '' then
            Vendor."Phone No." := CopyStr(GetTextValue(VendorObject, 'VendorPhoneNo'), 1, 30);

        // MSME / Udyam Fields
        if GetTextValue(VendorObject, 'UdyamRegNo') <> '' then
            Vendor."Udyam Reg No" := CopyStr(GetTextValue(VendorObject, 'UdyamRegNo'), 1, MaxStrLen(Vendor."Udyam Reg No"));

        if GetTextValue(VendorObject, 'TypeOfEnterprise') <> '' then
            SetTypeOfEnterprise(Vendor, GetTextValue(VendorObject, 'TypeOfEnterprise'));

        if GetTextValue(VendorObject, 'MajorActivity') <> '' then
            SetMajorActivity(Vendor, GetTextValue(VendorObject, 'MajorActivity'));

        TurnoverText := GetTextValue(VendorObject, 'Turnover');
        if TurnoverText <> '' then
            Evaluate(Vendor.Turnover, TurnoverText);

        // Blocked
        BlockedText := GetTextValue(VendorObject, 'Blocked');
        SetVendorBlocked(Vendor, BlockedText);
    end;

    local procedure SetGSTVendorType(var Vendor: Record Vendor; GSTTypeText: Text)
    begin
        case UpperCase(GSTTypeText) of
            'REGISTERED':
                Vendor."GST Vendor Type" := Vendor."GST Vendor Type"::Registered;
            'UNREGISTERED':
                Vendor."GST Vendor Type" := Vendor."GST Vendor Type"::Unregistered;
            'IMPORT':
                Vendor."GST Vendor Type" := Vendor."GST Vendor Type"::Import;
            'EXEMPTED':
                Vendor."GST Vendor Type" := Vendor."GST Vendor Type"::Exempted;
            'SEZ':
                Vendor."GST Vendor Type" := Vendor."GST Vendor Type"::SEZ;
        end;
    end;

    local procedure SetTypeOfEnterprise(var Vendor: Record Vendor; EnterpriseText: Text)
    begin
        case UpperCase(EnterpriseText) of
            'MICRO':
                Vendor."Type of Enterprise" := Vendor."Type of Enterprise"::Micro;
            'SMALL':
                Vendor."Type of Enterprise" := Vendor."Type of Enterprise"::Small;
            'MEDIUM':
                Vendor."Type of Enterprise" := Vendor."Type of Enterprise"::Medium;
        end;
    end;

    local procedure SetMajorActivity(var Vendor: Record Vendor; ActivityText: Text)
    begin
        case UpperCase(ActivityText) of
            'MANUFACTURING':
                Vendor."Major Activity" := Vendor."Major Activity"::MANUFACTURER;
            'SERVICES':
                Vendor."Major Activity" := Vendor."Major Activity"::SERVICE;
        end;
    end;

    local procedure SetVendorBlocked(var Vendor: Record Vendor; BlockedText: Text)
    begin
        case UpperCase(BlockedText) of
            '', '0', 'FALSE':
                Vendor.Blocked := Vendor.Blocked::" ";
            'PAYMENT':
                Vendor.Blocked := Vendor.Blocked::Payment;
            'ALL', '1', 'TRUE':
                Vendor.Blocked := Vendor.Blocked::All;
        end;
    end;

    local procedure SyncVendorBankAccounts(VendorObject: JsonObject; VendorNo: Code[20])
    var
        BankArrayToken: JsonToken;
        BankToken: JsonToken;
        BankArray: JsonArray;
        BankObject: JsonObject;
        VendorBankAccount: Record "Vendor Bank Account";
        BankCode: Code[20];
    begin
        if not VendorObject.Get('BankAccount', BankArrayToken) then
            exit;
        if not BankArrayToken.IsArray() then
            exit;

        BankArray := BankArrayToken.AsArray();

        foreach BankToken in BankArray do begin
            if BankToken.IsObject() then begin
                BankObject := BankToken.AsObject();
                BankCode := CopyStr(GetTextValue(BankObject, 'BankCode'), 1, 20);

                if BankCode <> '' then begin
                    if not VendorBankAccount.Get(VendorNo, BankCode) then begin
                        VendorBankAccount.Init();
                        VendorBankAccount."Vendor No." := VendorNo;
                        VendorBankAccount.Code := BankCode;
                        VendorBankAccount.Insert(true);
                    end;
                    VendorBankAccount.Name := CopyStr(GetTextValue(BankObject, 'BankName'), 1, 100);
                    VendorBankAccount.Address := CopyStr(GetTextValue(BankObject, 'BankAddress'), 1, 100);
                    VendorBankAccount."Address 2" := CopyStr(GetTextValue(BankObject, 'BankAddress2'), 1, 50);
                    VendorBankAccount.City := CopyStr(GetTextValue(BankObject, 'BankCity'), 1, 30);
                    VendorBankAccount."Post Code" := CopyStr(GetTextValue(BankObject, 'BankPostCode'), 1, 20);

                    if GetTextValue(BankObject, 'BankCountry') <> '' then
                        VendorBankAccount."Country/Region Code" := CopyStr(GetTextValue(BankObject, 'BankCountry'), 1, 10);

                    VendorBankAccount."Bank Account No." := CopyStr(GetTextValue(BankObject, 'BankAccountNo'), 1, 30);

                    if GetTextValue(BankObject, 'BankIFSCCode') <> '' then
                        VendorBankAccount."IFSC Code" := CopyStr(GetTextValue(BankObject, 'BankIFSCCode'), 1, MaxStrLen(VendorBankAccount."IFSC Code"));

                    if GetTextValue(BankObject, 'BankSWIFTCode') <> '' then
                        VendorBankAccount."SWIFT Code" := CopyStr(GetTextValue(BankObject, 'BankSWIFTCode'), 1, 20);

                    if GetTextValue(BankObject, 'BankIBAN') <> '' then
                        VendorBankAccount.IBAN := CopyStr(GetTextValue(BankObject, 'BankIBAN'), 1, 50);

                    VendorBankAccount.Modify(true);
                end;
            end;
        end;
    end;

    local procedure SyncTDSSections(VendorObject: JsonObject; VendorNo: Code[20])
    var
        TDSArrayToken: JsonToken;
        TDSToken: JsonToken;
        TDSArray: JsonArray;
        TDSObject: JsonObject;
        AllowedSections: Record "Allowed Sections";
        TDSSectionCode: Code[10];
    begin
        if not VendorObject.Get('TDSSections', TDSArrayToken) then
            exit;
        if not TDSArrayToken.IsArray() then
            exit;

        TDSArray := TDSArrayToken.AsArray();

        foreach TDSToken in TDSArray do begin
            if TDSToken.IsObject() then begin
                TDSObject := TDSToken.AsObject();
                TDSSectionCode := CopyStr(GetTextValue(TDSObject, 'TDSSectionCode'), 1, 10);

                if TDSSectionCode <> '' then begin
                    AllowedSections.SetRange("Vendor No", VendorNo);
                    AllowedSections.SetRange("TDS Section", TDSSectionCode);
                    if AllowedSections.IsEmpty() then begin
                        AllowedSections.Init();
                        AllowedSections."Vendor No" := VendorNo;
                        AllowedSections."TDS Section" := TDSSectionCode;
                        AllowedSections.Insert(true);
                    end;
                end;
            end;
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
