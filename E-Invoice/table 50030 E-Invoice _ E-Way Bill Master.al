table 50030 "E-Invoice & E-Way Bill Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        { }
        field(2; "Document Type"; Option)
        {
            OptionMembers = " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return";
        }
        field(3; "Document No."; Code[20])
        { }
        field(4; "Reference Invoice No."; Code[20])
        { }
        field(5; "E-Way Bill No."; Text[50])
        { }
        field(10; "Acknowledgement No."; Text[30])
        { }
        field(11; "IRN Hash"; Text[64])
        {
            trigger OnValidate()
            BEGIN
                IF ("IRN Hash" <> '') AND (STRLEN("IRN Hash") < 64) THEN
                    ERROR(IRNErr);
            END;
        }
        field(12; "QR Code"; BLOB)
        {
            SubType = Bitmap;
        }
        field(13; "Total Retry Counter"; Integer)
        { }
        field(14; "Total No. of Hits Counter"; Integer)
        { }
        field(15; "Acknowledgement Date"; DateTime)
        { }
        field(16; IsJSONImported; Boolean)
        { }
        field(17; "E-Inv. Cancelled Date"; DateTime)
        { }
        field(18; "Cancel Reason"; Option)
        {
            OptionMembers = " ","Wrong entry","Duplicate","Data Entry Mistake","Order Canceled","Other";
        }
        field(19; "Created By"; Code[50])
        { }
        field(20; "Created On"; DateTime)
        { }
        field(21; "Entry Creation Through"; Option)
        {
            OptionMembers = " ","Codeunit","Process Batch";
        }
        field(22; "Last Modified By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(23; "Last Modified DateTime"; DateTime)
        { }
        field(24; "Response Code"; Text[20])
        { }
        field(25; "Response Description"; Text[250])
        { }
        field(26; "E-Way Bill Date"; DateTime)
        { }
        field(27; "E-Way Bill Valid Till"; DateTime)
        { }
        field(28; "E-Way Bill Cancelled Date"; DateTime)
        { }
        field(29; "E-Way Bill Cancel Reason"; Option)
        {
            OptionMembers = " ","Cancelled the order","Wrong entry","Duplicate","Other";
        }
        field(32; "User Email Id"; Text[150])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(33; "User Name"; Text[150])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;
        }
        field(34; Password; Text[150])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(35; "IP Address"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            Enabled = false;
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(36; "Client ID"; Text[150])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;
        }

        field(37; "Client Secret"; Text[150])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(38; "GSTIN Number"; Text[15])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(39; "Auth-Token"; Text[250])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(40; "Auth-Token Generation Time"; DateTime)
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(41; "Auth-Token Expiration Time"; DateTime)
        {
            Enabled = false;
            DataClassification = ToBeClassified;
            Description = '//Api Hitting Details DoNot Delete these fields //Switched to Loc Master';
            trigger OnValidate()
            BEGIN
                Rec.TESTFIELD("Document Type", Rec."Document Type"::"Api Setup Details");
                Rec.TESTFIELD("Entry No.", 1);
            END;

        }
        field(42; "Distance (Km)"; Integer)
        {
            Description = '//Mendatory for E-way Bill';
        }
        field(43; "Vehicle No."; Code[20])
        {
            Description = '//Mendatory for E-way Bill';
        }
        field(44; "Vehicle Type"; Option)
        {
            OptionMembers = " ","Regular","ODC";
            Description = '//Mendatory for E-way Bill';
        }
        field(45; "Transport Method"; Code[10])
        {
            TableRelation = "Transport Method";

            Description = '//Mendatory for E-way Bill';
        }
        field(46; "Transporter Id"; Code[15])
        {
            Description = '//Mendatory for E-way Bill';
        }
        field(47; "Transporter Name"; Text[30])
        {
            Description = '//Mendatory for E-way Bill';
        }
        field(48; "Transport Document Date"; Date)
        {
            Description = '//Mendatory for E-way Bill';
        }
        field(49; "Transport Document No."; Code[20])
        {
            Description = '//Mendatory for E-way Bill';
        }
        field(50; "Document Posting Date"; Date)
        { }
        field(51; "TO No."; Code[20])
        {
            Description = '//Transfer Order No.';
        }
        field(52; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(53; "Shipping Agent Code"; Code[10])
        {
            TableRelation = "Shipping Agent".Code;
            NotBlank = true;
            trigger OnValidate()
            VAR
                ShippingAgent: Record 291;
            BEGIN
                IF ShippingAgent.GET("Shipping Agent Code") THEN BEGIN
                    "Transporter Id" := ShippingAgent."GST Registration No.";
                    "Transporter Name" := ShippingAgent.Name;
                END;
            END;

        }
        field(54; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(55; "Hitting Not Required"; Boolean)
        {
            Description = '//January EInvoice Error 2021 for not hitting particular entries';
        }
        field(56; "Error N"; Integer)
        { }
        field(57; "Error Message"; Text[250])
        { }
        field(58; "Acknowledgement DT"; Text[100])
        { }
        field(59; "Ship to Address1"; Text[50])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(60; "Ship to Address2"; Text[50])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(61; "Ship to Place"; Text[30])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(62; "Ship to Pin code"; Integer)
        {
            Description = '//For Reliance EWay Bill';
        }
        field(63; "Ship to state code"; Code[10])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(64; "Dispatch from Name"; Text[50])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(65; "Dispatch from Address1"; Text[50])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(66; "Dispatch from Address2"; Text[50])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(67; "Dispatch from Place"; Text[30])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(68; "Dispatch from Pin code"; Integer)
        {
            Description = '//For Reliance EWay Bill';
        }
        field(69; "Dispatch from State code"; Code[10])
        {
            Description = '//For Reliance EWay Bill';
        }
        field(70; "Pos Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NT Pos Work';
        }
        field(71; "Pos Flag"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","WTS","STS","STW";
            Description = 'NT Pos Work';
        }
        field(72; "Pos E-Invoice QR Code Response"; BLOB)
        {
            Description = 'NT Pos Work';
        }
        field(73; "E-invoice QR Code"; Text[1024])
        {
            Description = 'Manoj Einvoice work';
        }
        field(74; "Inserted into TempGST"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(75; "Intrastate E-Way Bill"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            // OptionMembers = Interstate,Intrastate;
        }
        field(76; alert; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(78; "Total Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(79; "Total Tax Val"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80; "Total Invoice Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(81; "QR-Code Custom"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(82; "Request Description"; Text[1250])
        { }
        field(83; "E-way Generated"; Boolean)
        {

        }
        field(84; "E-Way QR Code"; Blob)
        {
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Document Type", "Document No.", "Document Posting Date")
        {
            Clustered = true;
        }
    }

    var
        EInvoiceEWayBillMaster: Record 50030;
        IRNErr: TextConst ENU = 'IRN Hash must be 64 character text.;ENN=IRN Hash must be 64 character text.';






    // procedure GenerateEInvoice()
    // var
    //     SalesPost: Codeunit "Sales-Post";
    //     SalesInvoiceHeader: Record "Sales Invoice Header";
    //     SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    //     Var_Selected: Integer;
    //     TransferShipmentHeader: Record "Transfer Shipment Header";
    //     PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    //     "E-Invoice & E-Way Bill Master": Record "E-Invoice & E-Way Bill Master";
    //     TransferDocNo: code[20];
    //     TransferShipment: Record "Transfer Shipment Header";
    //     CU50062: Codeunit 50062;

    // begin
    //     "E-Invoice & E-Way Bill Master".TESTFIELD("Document No.");
    //     IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::" " THEN BEGIN
    //         MESSAGE('Nothing to Hit.');
    //         EXIT;
    //     END;

    //     //GEt Store Document Number End //PBS MAN 080421
    //     TransferDocNo := '';
    //     IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::Transfer THEN BEGIN
    //         TransferShipment.RESET;
    //         IF TransferShipment.GET("E-Invoice & E-Way Bill Master"."Document No.") THEN BEGIN
    //             TransferDocNo := "E-Invoice & E-Way Bill Master"."Document No.";

    //         END;
    //     END;
    //     //Get Store Document Number End //PBS MAN 080421


    //     //Generate IRN
    //     //PBS SL
    //     // CLEAR(MasterGSTApi);
    //     // IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Invoice" THEN BEGIN
    //     //     MasterGSTApi.GenerateIRN("E-Invoice & E-Way Bill Master"."Document No.", DATABASE::"Sales Invoice Header");
    //     // END ELSE
    //     //     IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Cr.Memo" THEN BEGIN
    //     //         MasterGSTApi.GenerateIRN("E-Invoice & E-Way Bill Master"."Document No.", DATABASE::"Sales Cr.Memo Header");
    //     //     END ELSE
    //     //         IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::Transfer THEN BEGIN
    //     //             MasterGSTApi.GenerateIRNforTransfer("E-Invoice & E-Way Bill Master"."Document No.", DATABASE::"Transfer Shipment Header");  //PBS MAN 080421
    //     //         END ELSE
    //     //             IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Purchase Return" THEN BEGIN
    //     //                 MasterGSTApi.GenerateIRNforPurchaseOrder("E-Invoice & E-Way Bill Master"."Document No.", DATABASE::"Purch. Cr. Memo Hdr.");
    //     //             END;
    //     //PBS SL


    //     COMMIT;
    //     // Generate E-Invoice
    //     IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Invoice" THEN BEGIN
    //         // CLEAR(eInvoice); //PBS SL
    //         SalesInvoiceHeader.RESET;
    //         SalesInvoiceHeader.SETCURRENTKEY("No.");
    //         SalesInvoiceHeader.SETRANGE("No.", "E-Invoice & E-Way Bill Master"."Document No.");
    //         SalesInvoiceHeader.FINDFIRST;
    //         SalesInvoiceHeader.MARK(TRUE);
    //         CU50062.GenerateEinvoice('', SalesInvoiceHeader."No.", "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Invoice");
    //         // eInvoice.SetSalesInvHeader(SalesInvoiceHeader);  //PBS SL
    //         // eInvoice.GenerateEinvoiceJson;  //PBS SL
    //     END ELSE
    //         IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Cr.Memo" THEN BEGIN
    //             // CLEAR(eInvoice);  //PBS SL
    //             SalesCrMemoHeader.RESET;
    //             SalesCrMemoHeader.SETCURRENTKEY("No.");
    //             SalesCrMemoHeader.SETRANGE("No.", "E-Invoice & E-Way Bill Master"."Document No.");
    //             SalesCrMemoHeader.FINDFIRST;
    //             SalesCrMemoHeader.MARK(TRUE);
    //             CU50062.GenerateEinvoice('', SalesCrMemoHeader."No.", "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Cr.Memo");
    //             // eInvoice.SetCrMemoHeader(SalesCrMemoHeader);  //PBS SL
    //             // eInvoice.GenerateEinvoiceJson;  //PBS SL
    //         END ELSE
    //             IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::Transfer THEN BEGIN
    //                 // CLEAR(eInvoice); //PBS SL
    //                 TransferShipmentHeader.RESET;
    //                 TransferShipmentHeader.SETCURRENTKEY("No.");
    //                 TransferShipmentHeader.SETRANGE("No.", TransferDocNo); //PBS MAN 080421
    //                 TransferShipmentHeader.FINDFIRST;
    //                 TransferShipmentHeader.MARK(TRUE);
    //                 CU50062.GenerateEinvoice('', TransferShipmentHeader."No.", "E-Invoice & E-Way Bill Master"."Document Type"::Transfer);
    //                 // eInvoice.TransferSetTransferShipmentHeader(TransferShipmentHeader);  //PBS SL
    //                 // eInvoice.GenerateTransferEinvoiceJson;  //PBS SL
    //             END ELSE
    //                 IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Purchase Return" THEN BEGIN
    //                     // CLEAR(eInvoice); //PBS SL
    //                     PurchCrMemoHdr.RESET;
    //                     PurchCrMemoHdr.SETCURRENTKEY("No.");
    //                     PurchCrMemoHdr.SETRANGE("No.", "E-Invoice & E-Way Bill Master"."Document No.");
    //                     PurchCrMemoHdr.FINDFIRST;
    //                     PurchCrMemoHdr.MARK(TRUE);
    //                     //PBS SL
    //                     // eInvoice.SetPurchRtrnCrMemoHeader(PurchCrMemoHdr);
    //                     // eInvoice.GeneratePurchRtrnEinvoiceJson;
    //                 END;
    // end;


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}