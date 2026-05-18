// page 50011 "E-Invoice & E-Way Bill Master"
// {
//     // DelayedInsert = false;
//     // DeleteAllowed = false;
//     // InsertAllowed = false;
//     PageType = List;
//     Permissions = TableData "Sales Invoice Header" = rimd,
//                   TableData "Sales Cr.Memo Header" = rimd, tabledata "Sales Invoice Line" = rimd;
//     SourceTable = "E-Invoice & E-Way Bill Master";
//     ApplicationArea = all;
//     UsageCategory = Administration;


//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Document Type"; Rec."Document Type")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Intrastate E-Way Bill"; Rec."Intrastate E-Way Bill")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Document No."; Rec."Document No.")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Customer No."; Rec."Customer No.")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Vendor No."; Rec."Vendor No.")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Document Posting Date"; Rec."Document Posting Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("TO No."; Rec."TO No.")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Location Code"; Rec."Location Code")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Acknowledgement No."; Rec."Acknowledgement No.")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Acknowledgement Date"; Rec."Acknowledgement Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Acknowledgement DT"; Rec."Acknowledgement DT")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("IRN Hash"; Rec."IRN Hash")
//                 {
//                     Editable = true;
//                     ApplicationArea = all;
//                 }
//                 field("QR Code"; Rec."QR Code")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field(IsJSONImported; Rec.IsJSONImported)
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("E-Inv. Cancelled Date"; Rec."E-Inv. Cancelled Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Cancel Reason"; Rec."Cancel Reason")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Created By"; Rec."Created By")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Created On"; Rec."Created On")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Entry Creation Through"; Rec."Entry Creation Through")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Last Modified By"; Rec."Last Modified By")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Last Modified DateTime"; Rec."Last Modified DateTime")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Response Code"; Rec."Response Code")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Request Description"; Rec."Request Description")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Response Description"; Rec."Response Description")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Distance (Km)"; Rec."Distance (Km)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Vehicle No."; Rec."Vehicle No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Vehicle Type"; Rec."Vehicle Type")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Transport Method"; Rec."Transport Method")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Shipping Agent Code"; Rec."Shipping Agent Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Transporter Id"; Rec."Transporter Id")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Transporter Name"; Rec."Transporter Name")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Transport Document Date"; Rec."Transport Document Date")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Transport Document No."; Rec."Transport Document No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship to Address1"; Rec."Ship to Address1")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship to Address2"; Rec."Ship to Address2")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship to Place"; Rec."Ship to Place")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship to Pin code"; Rec."Ship to Pin code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship to state code"; Rec."Ship to state code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dispatch from Name"; Rec."Dispatch from Name")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dispatch from Address1"; Rec."Dispatch from Address1")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dispatch from Address2"; Rec."Dispatch from Address2")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dispatch from Place"; Rec."Dispatch from Place")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dispatch from Pin code"; Rec."Dispatch from Pin code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dispatch from State code"; Rec."Dispatch from State code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("E-Way Bill No."; Rec."E-Way Bill No.")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("E-Way Bill Date"; Rec."E-Way Bill Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("E-Way Bill Valid Till"; Rec."E-Way Bill Valid Till")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("E-Way Bill Cancelled Date"; Rec."E-Way Bill Cancelled Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("E-Way Bill Cancel Reason"; Rec."E-Way Bill Cancel Reason")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }
//                 field("Inserted into TempGST"; Rec."Inserted into TempGST")
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field(alert; Rec.alert)
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Total Tax Val"; rec."Total Tax Val")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Total Line Amount"; Rec."Total Line Amount")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Total Invoice Value"; Rec."Total Invoice Value")
//                 {

//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group("General Tasks")
//             {
//                 Caption = 'General Tasks';

//                 Image = "Action";

//                 action("Generate Token")
//                 {
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     Caption = 'Generate Token';
//                     Image = Web;
//                     trigger OnAction()
//                     var
//                         MasterGSTApi: Codeunit 50003;
//                     begin
//                         MasterGSTApi.GenerateAuthenticationAPI(Rec."Location Code");
//                     end;
//                 }

//                 action("Generate E-Way Bill For JOb Worker")
//                 {
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     Caption = 'Generate E-Way Bill For Job Worker';
//                     Image = Indent;
//                     trigger OnAction()
//                     var
//                         MasterGSTApi: Codeunit 50003;
//                     begin
//                         CheckHittingNotRequired;
//                         Rec.TESTFIELD("Document No.");
//                         Rec.TESTFIELD("Document Type");
//                         MasterGSTApi.GenerateEWayBillForJobWork(Rec."Document No.", Rec."Document Type"::"Sales Invoice");
//                         CurrPage.UPDATE;
//                     end;
//                 }
//                 action("Generate E-Way Bill For Same State")
//                 {
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     Caption = 'Generate E-Way Bill For Intrastate';
//                     Image = Indent;
//                     trigger OnAction()
//                     var
//                         MasterGSTApi: Codeunit 50003;
//                     begin
//                         CheckHittingNotRequired;
//                         Rec.TESTFIELD("Document No.");
//                         Rec.TESTFIELD("Document Type");
//                         if Rec."Intrastate E-Way Bill" = true then begin
//                             MasterGSTApi.GenerateEWayBillForSameState(Rec."Document No.", Rec."Document Type");
//                             //MasterGSTApi.GenerateEWayBillSameLocation(Rec."Document No.", Rec."Document Type");
//                             CurrPage.UPDATE;
//                         end else begin
//                             Error('E-Way Bill Is Not Generated For This Document');
//                         end;
//                     end;
//                 }
//                 action("Generate E-Invoice")
//                 {
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     trigger OnAction()
//                     var
//                         SIL: Record "Sales Invoice Line";
//                     begin
//                         IF NOT CONFIRM('Do you want to Generate E-Invoice.') THEN
//                             EXIT;
//                         // SIL.Reset();
//                         // SIL.SetRange("Document No.", 'KHO/24-25/0083');
//                         // SIL.SetRange(Type, SIL.Type::"G/L Account");
//                         // if SIL.FindSet() then begin
//                         //     SIL."Billing UOM" := SIL."Billing UOM"::MTS;
//                         //     SIL.Modify();
//                         // end;

//                         if (Rec."Intrastate E-Way Bill" = false) or (Rec."Document Type" <> Rec."Document Type"::Transfer) then begin
//                             //if Rec.IsJSONImported = false then begin
//                             GenerateEInvoice(Rec);
//                             // end else begin
//                             //     Message('E-Invoice Generated Sucessfully.');
//                             // end;
//                         end else begin
//                             Error('E-Invoice Is Not Generate For This Document');
//                         end;
//                     end;
//                 }
//                 action("Generate Bulk E-Invoicess")
//                 {
//                     // Visible = false;
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     trigger OnAction()
//                     Var
//                         RecTable: Record "E-Invoice & E-Way Bill Master";
//                     begin
//                         IF NOT CONFIRM('Do you want to Generate E-Invoice.') THEN
//                             EXIT;
//                         CurrPage.SetSelectionFilter(RecTable);
//                         if RecTable.FindSet() then
//                             repeat
//                                 if RecTable.IsJSONImported = false then begin
//                                     GenerateEInvoice(RecTable);
//                                 end else begin
//                                     Message('E-Invoice Generated Sucessfully.');
//                                 end;
//                             until RecTable.Next() = 0;
//                     end;
//                 }

//                 action("Generate E-Way Bills")
//                 {
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     Caption = 'Generate E-Way Bill For Interstate';
//                     Image = Indent;
//                     trigger OnAction()
//                     var
//                         MasterGSTApi: Codeunit 50003;
//                     begin
//                         CheckHittingNotRequired;

//                         Rec.TESTFIELD("Document No.");
//                         Rec.TESTFIELD("Document Type");
//                         // Rec.TESTFIELD("IRN Hash");
//                         CLEAR(MasterGSTApi);

//                         // if Rec."Intrastate E-Way Bill" = false then begin
//                         MasterGSTApi.GenerateEWayBill(Rec."Document No.", Rec."Document Type");
//                         CurrPage.UPDATE;
//                         // end else begin
//                         //     Error('E-Way Is Not Generate For This Document');
//                         // end;

//                     end;
//                 }
//                 // action("Cancel E-Way Bill")
//                 // {
//                 //     Caption = 'Cancel E-Way Bill';
//                 //     Enabled = false;
//                 //     Image = CancelIndent;
//                 //     Visible = false;

//                 //     trigger OnAction()
//                 //     var
//                 //         SalesInvHeader: Record "Sales Invoice Header";
//                 //         Var_SelectedValue: Integer;
//                 //         MasterGSTApi: Codeunit 50003;
//                 //     begin
//                 //         CheckHittingNotRequired;
//                 //         CompInfo.GET;

//                 //         Rec.TESTFIELD("Document No.");
//                 //         Rec.TESTFIELD("Document Type");
//                 //         Rec.TESTFIELD("IRN Hash");
//                 //         Var_SelectedValue := STRMENU('Cancelled the order,Wrong entry,Duplicate,Other', 1, 'Cancel Reason.');
//                 //         IF Var_SelectedValue = 0 THEN
//                 //             EXIT;
//                 //         CLEAR(MasterGSTApi);
//                 //         //message('ok');
//                 //         // MasterGSTApi.CancelEWayBill(Var_SelectedValue, Rec."Document No.", Rec."Document Type");

//                 //         CurrPage.UPDATE;
//                 //     end;
//                 // }
//                 action("View Document")
//                 {
//                     Image = ViewOrder;
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     trigger OnAction()
//                     begin
//                         //Sales Invoice Process
//                         IF Rec."Document Type" = Rec."Document Type"::"Sales Invoice" THEN
//                             SalesInvoiceViewDocument;

//                         //Sales Cr.Memo Process
//                         IF Rec."Document Type" = Rec."Document Type"::"Sales Cr.Memo" THEN
//                             SalesCrMemoViewDocument;

//                         //Transfer Process
//                         IF Rec."Document Type" = Rec."Document Type"::Transfer THEN
//                             TransferViewDocument;

//                         //Purchase Return Process
//                         IF Rec."Document Type" = Rec."Document Type"::"Purchase Return" THEN
//                             PurchRtrnViewDocument;
//                     end;
//                 }

//                 action("Get E-Invoice Details")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                     Image = GetEntries;

//                     trigger OnAction()
//                     begin
//                         CheckHittingNotRequired;

//                         IF Rec."Document Type" = Rec."Document Type"::"Sales Invoice" THEN
//                             SalesInvoiceGetEInvoiceDetails;
//                         CurrPage.Update;
//                     end;
//                 }
//                 action("Cancel E-Invoice")
//                 {
//                     ApplicationArea = All;
//                     Visible = true;
//                     Caption = 'Cancel E-Invoice';
//                     Image = CancelIndent;

//                     trigger OnAction()
//                     begin
//                         CheckHittingNotRequired;

//                         IF NOT CONFIRM('Do you want to Cancel E-Invoice.') THEN
//                             EXIT;
//                         CancelEInvoice;
//                     end;
//                 }
//             }

//             group("E-Way Bill Report")
//             {
//                 action("E-way Print")
//                 {
//                     Image = Report;
//                     ApplicationArea = all;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     trigger OnAction()
//                     Var
//                         Eway: Record "E-Invoice & E-Way Bill Master";
//                     begin
//                         Eway.RESET;
//                         Eway.SETRANGE("E-Way Bill No.", Rec."E-Way Bill No.");
//                         IF Eway.FINDFIRST THEN BEGIN
//                             Report.Run(50420, true, false, Eway);
//                         END;
//                     end;
//                 }

//             }
//         }
//     }
//     trigger OnOpenPage()
//     begin

//     end;

//     trigger OnDeleteRecord(): Boolean
//     var
//         UserSetup: Record 91;
//     begin
//         //serSetup.GET(USERID);
//         // IF not UserSetup."Admin Access" THEN
//         //     ERROR('User %1 is not authorized to Delete the record!', USERID);
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//         UserSetup: Record 91;
//     begin
//         // UserSetup.GET(USERID);
//         // IF not UserSetup."Admin Access" THEN
//         //     ERROR('User %1 is not authorized to modify the record!', USERID);

//     end;


//     //PBS KK 12052023
//     procedure GenerateEInvoice(Var "E-Invoice & E-Way Bill Master": Record "E-Invoice & E-Way Bill Master")
//     var
//         SalesPost: Codeunit "Sales-Post";
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//         Var_Selected: Integer;
//         TransferShipmentHeader: Record "Transfer Shipment Header";
//         PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
//         TransferDocNo: code[20];
//         TransferShipment: Record "Transfer Shipment Header";
//         CU50062: Codeunit 50003;

//     begin
//         "E-Invoice & E-Way Bill Master".TESTFIELD("Document No.");
//         IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::" " THEN BEGIN
//             MESSAGE('Nothing to Hit.');
//             EXIT;
//         END;


//         TransferDocNo := '';
//         IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::Transfer THEN BEGIN
//             TransferShipment.RESET;
//             IF TransferShipment.GET("E-Invoice & E-Way Bill Master"."Document No.") THEN BEGIN
//                 TransferDocNo := "E-Invoice & E-Way Bill Master"."Document No.";

//             END;
//         END;

//         COMMIT;
//         // Generate E-Invoice
//         IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Invoice" THEN BEGIN
//             SalesInvoiceHeader.RESET;
//             SalesInvoiceHeader.SETCURRENTKEY("No.");
//             SalesInvoiceHeader.SETRANGE("No.", "E-Invoice & E-Way Bill Master"."Document No.");
//             SalesInvoiceHeader.FINDFIRST;
//             SalesInvoiceHeader.MARK(TRUE);
//             CU50062.GenerateEinvoice(SalesInvoiceHeader."No.", "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Invoice");
//         END ELSE
//             IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Cr.Memo" THEN BEGIN
//                 SalesCrMemoHeader.RESET;
//                 SalesCrMemoHeader.SETCURRENTKEY("No.");
//                 SalesCrMemoHeader.SETRANGE("No.", "E-Invoice & E-Way Bill Master"."Document No.");
//                 SalesCrMemoHeader.FINDFIRST;
//                 SalesCrMemoHeader.MARK(TRUE);
//                 CU50062.GenerateEinvoice(SalesCrMemoHeader."No.", "E-Invoice & E-Way Bill Master"."Document Type"::"Sales Cr.Memo");
//             END ELSE
//                 IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::Transfer THEN BEGIN
//                     TransferShipmentHeader.RESET;
//                     TransferShipmentHeader.SETCURRENTKEY("No.");
//                     TransferShipmentHeader.SETRANGE("No.", TransferDocNo);
//                     TransferShipmentHeader.FINDFIRST;
//                     TransferShipmentHeader.MARK(TRUE);
//                     CU50062.GenerateEinvoice(TransferShipmentHeader."No.", "E-Invoice & E-Way Bill Master"."Document Type"::Transfer);
//                 END ELSE
//                     IF "E-Invoice & E-Way Bill Master"."Document Type" = "E-Invoice & E-Way Bill Master"."Document Type"::"Purchase Return" THEN BEGIN
//                         PurchCrMemoHdr.RESET;
//                         PurchCrMemoHdr.SETCURRENTKEY("No.");
//                         PurchCrMemoHdr.SETRANGE("No.", "E-Invoice & E-Way Bill Master"."Document No.");
//                         PurchCrMemoHdr.FINDFIRST;
//                         PurchCrMemoHdr.MARK(TRUE);
//                         CU50062.GenerateEinvoice(PurchCrMemoHdr."No.", "E-Invoice & E-Way Bill Master"."Document Type"::"Purchase Return");
//                     END;
//     end;





//     var
//         EInvoiceEWayBillMaster: Record "E-Invoice & E-Way Bill Master";
//         UnRegCustErr: Label 'E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.';
//         eInvoiceErr: Label 'E-Invoicing is not applicable for Non-GST Transactions.';
//         //GSTManagement: Codeunit "GST Management";//PBS MAN BC Migration Error
//         //eInvoice: Codeunit "e-Invoice Work NT";//PBS MAN BC Migration Error
//         //MasterGSTApi: Codeunit "MasterGST Api";//PBS MAN BC Migration Error
//         TransferShipmentHeader: Record "Transfer Shipment Header";
//         PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
//         CompInfo: Record "Company Information";
//     //TstCU50116: Codeunit "MasterGST Api23";//PBS MAN BC Migration Error


//     trigger OnModifyRecord(): Boolean
//     begin
//         if rec."E-Way Bill No." <> '' then
//             Error('E-way bill has been updated. You cannot modify!');
//     end;



//     local procedure CancelEInvoice()
//     var
//         SalesPost: Codeunit "Sales-Post";
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//         Var_SelectedValue: Integer;
//         MasterGSTApi: Codeunit 50003;
//     begin
//         Rec.TESTFIELD("Document No.");
//         IF Rec."Document Type" = Rec."Document Type"::" " THEN BEGIN
//             MESSAGE('Nothing to Hit.');
//             EXIT;
//         END;

//         Rec.TESTFIELD("Document No.");
//         //Rec.TESTFIELD("Document Type",Rec."Document Type"::"Sales Invoice");
//         Var_SelectedValue := STRMENU('Wrong entry,Duplicate,Data Entry Mistake,Order Canceled,Other', 1, 'Enter Cancel Reason.');
//         IF Var_SelectedValue = 0 THEN
//             EXIT;

//         // Cancel E-Invoice
//         Rec.TESTFIELD("IRN Hash");
//         CLEAR(MasterGSTApi);
//         MasterGSTApi.CancelEinvoice(Rec."Document No.", Rec."Document Type", Var_SelectedValue, Var_SelectedValue);
//     end;


//     local procedure "*************** Sales Invoice Process ***************"()
//     begin
//     end;

//     local procedure SalesInvoiceViewDocument()
//     var
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::"Sales Invoice");
//         SalesInvoiceHeader.RESET;
//         SalesInvoiceHeader.SETCURRENTKEY("No.");
//         SalesInvoiceHeader.SETRANGE("No.", Rec."Document No.");
//         IF PAGE.RUNMODAL(132, SalesInvoiceHeader) = ACTION::LookupOK THEN;
//     end;

//     local procedure SalesInvoiceGetEInvoiceDetails()
//     var
//         // MasterGSTApi: Codeunit 50003;
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::"Sales Invoice");
//         SalesInvoiceHeader.RESET;      /*
//         SalesInvoiceHeader.SETCURRENTKEY("No.");
//         SalesInvoiceHeader.SETRANGE("No.",Rec."Document No.");
//         SalesInvoiceHeader.FINDFIRST;*/
//         // MasterGSTApi.GetEinvoiceDetails(Rec."IRN Hash", Rec."Document No.", 1);//PBS MAN BC Migration Error

//     end;

//     local procedure "*************** Sales Cr.Memo Process ***************"()
//     begin
//     end;

//     local procedure SalesCrMemoViewDocument()
//     var
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::"Sales Cr.Memo");
//         SalesCrMemoHeader.RESET;
//         SalesCrMemoHeader.SETCURRENTKEY("No.");
//         SalesCrMemoHeader.SETRANGE("No.", Rec."Document No.");
//         IF PAGE.RUNMODAL(134, SalesCrMemoHeader) = ACTION::LookupOK THEN;
//     end;

//     local procedure SalesCrMemoGetEInvoiceDetails()
//     var
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::"Sales Cr.Memo");
//         SalesCrMemoHeader.RESET;
//         SalesCrMemoHeader.SETCURRENTKEY("No.");
//         SalesCrMemoHeader.SETRANGE("No.", Rec."Document No.");
//         SalesCrMemoHeader.FINDFIRST;
//         //MasterGSTApi.GetEinvoiceDetails(Rec."IRN Hash", Rec."Document No.", 2);//PBS MAN BC Migration Error
//     end;

//     local procedure "*************** Transfer Process ***************"()
//     begin
//     end;

//     local procedure TransferViewDocument()
//     var
//         TransferShipmentHeader2: Record "Transfer Shipment Header";
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::Transfer);
//         TransferShipmentHeader.RESET;
//         TransferShipmentHeader.SETCURRENTKEY("No.");
//         TransferShipmentHeader.SETRANGE("No.", Rec."Document No.");
//         IF TransferShipmentHeader.FIND('-') THEN BEGIN
//             IF PAGE.RUNMODAL(5743, TransferShipmentHeader) = ACTION::LookupOK THEN;
//         END ELSE BEGIN
//             TransferShipmentHeader2.RESET;
//             TransferShipmentHeader2.SETCURRENTKEY("Transfer Order No.");
//             TransferShipmentHeader2.SETRANGE("Transfer Order No.", Rec."TO No.");
//             IF PAGE.RUNMODAL(5743, TransferShipmentHeader2) = ACTION::LookupOK THEN;
//         END;
//     end;

//     local procedure TransferGetEInvoiceDetails()
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::Transfer);
//         Rec.TESTFIELD("IRN Hash");
//         TransferShipmentHeader.RESET;
//         TransferShipmentHeader.SETCURRENTKEY("No.");
//         TransferShipmentHeader.SETRANGE("No.", Rec."Document No.");
//         TransferShipmentHeader.FINDFIRST;
//         //MasterGSTApi.GetEinvoiceDetails(Rec."IRN Hash", Rec."Document No.", 5);//PBS MAN BC Migration Error
//     end;

//     local procedure "*************** PurchRtrn Process ***************"()
//     begin
//     end;

//     local procedure PurchRtrnViewDocument()
//     var
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::"Purchase Return");
//         PurchCrMemoHdr.RESET;
//         PurchCrMemoHdr.SETCURRENTKEY("No.");
//         PurchCrMemoHdr.SETRANGE("No.", Rec."Document No.");
//         IF PAGE.RUNMODAL(140, PurchCrMemoHdr) = ACTION::LookupOK THEN;
//     end;

//     local procedure PurchRtrnGetEInvoiceDetails()
//     begin
//         Rec.TESTFIELD("Document No.");
//         Rec.TESTFIELD("Document Type", Rec."Document Type"::"Purchase Return");
//         Rec.TESTFIELD("IRN Hash");
//         PurchCrMemoHdr.RESET;
//         PurchCrMemoHdr.SETCURRENTKEY("No.");
//         PurchCrMemoHdr.SETRANGE("No.", Rec."Document No.");
//         PurchCrMemoHdr.FINDFIRST;
//         //MasterGSTApi.GetEinvoiceDetails(Rec."IRN Hash", Rec."Document No.", 6);//PBS MAN BC Migration Error
//     end;

//     // [Scope('Internal')]
//     procedure "*************** Check Hitting Not Required ***************"()
//     begin
//     end;

//     local procedure CheckHittingNotRequired()
//     begin
//         IF Rec."Hitting Not Required" = TRUE THEN
//             ERROR('Hitting will not be done for the Invoice %1.', Rec."Document No.");
//     end;




// }

