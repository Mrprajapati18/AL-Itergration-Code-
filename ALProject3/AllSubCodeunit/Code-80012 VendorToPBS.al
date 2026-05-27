
codeunit 80012 "Sync Vendor To PBS"
{
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
        // if GetTextValue(VendorObject, 'UdyamRegNo') <> '' then
        //     Vendor."Udyam Registration No." := CopyStr(GetTextValue(VendorObject, 'UdyamRegNo'), 1, MaxStrLen(Vendor."Udyam Registration No."));

        // if GetTextValue(VendorObject, 'TypeOfEnterprise') <> '' then
        //     SetTypeOfEnterprise(Vendor, GetTextValue(VendorObject, 'TypeOfEnterprise'));

        // if GetTextValue(VendorObject, 'MajorActivity') <> '' then
        //     SetMajorActivity(Vendor, GetTextValue(VendorObject, 'MajorActivity'));

        // TurnoverText := GetTextValue(VendorObject, 'Turnover');
        // if TurnoverText <> '' then
        //     Evaluate(Vendor.Turnover, TurnoverText);

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

    // local procedure SetTypeOfEnterprise(var Vendor: Record Vendor; EnterpriseText: Text)
    // begin
    //     case UpperCase(EnterpriseText) of
    //         'MICRO':
    //             Vendor."Type of Enterprise" := Vendor."Type of Enterprise"::Micro;
    //         'SMALL':
    //             Vendor."Type of Enterprise" := Vendor."Type of Enterprise"::Small;
    //         'MEDIUM':
    //             Vendor."Type of Enterprise" := Vendor."Type of Enterprise"::Medium;
    //     end;
    // end;

    // local procedure SetMajorActivity(var Vendor: Record Vendor; ActivityText: Text)
    // begin
    //     case UpperCase(ActivityText) of
    //         'MANUFACTURING':
    //             Vendor."Major Activity" := Vendor."Major Activity"::Manufacturing;
    //         'SERVICES':
    //             Vendor."Major Activity" := Vendor."Major Activity"::Services;
    //     end;
    // end;

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

                    // if GetTextValue(BankObject, 'BankIFSCCode') <> '' then
                    //     VendorBankAccount."IFSC Code" := CopyStr(GetTextValue(BankObject, 'BankIFSCCode'), 1, MaxStrLen(VendorBankAccount."IFSC Code"));

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
                    // Insert only if not already present (no modify needed - it's a link table)
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
