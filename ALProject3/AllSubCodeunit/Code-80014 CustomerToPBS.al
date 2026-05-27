
codeunit 80014 "Sync Customer To ERP"
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

    local procedure GetTextValue(JsonObject: JsonObject; FieldName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(FieldName, JsonToken) then
            exit(JsonToken.AsValue().AsText());
        exit('');
    end;
}
