
report 50002 TaxInvoice // Durgesh 8 May 2026
{
    ApplicationArea = All;
    Caption = 'TaxInvoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts\TaxInvoice.rdl';

    dataset
    {
        dataitem("SalesInvoiceHeader"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";

            column(CompInfoPic; CompInfoRec.Picture) { }
            column(Sno; Sno) { }
            column(CompInfoName; CompInfoRec.Name) { }
            column(CompInfoAdd1; CompInfoRec.Address) { }
            column(CompInfoAdd2; CompInfoRec."Address 2") { }
            column(CompInfoCity; CompInfoRec.City) { }
            column(CompInfoPostCode; CompInfoRec."Post Code") { }
            column(CompInfoGstReg; CompInfoRec."GST Registration No.") { }

            // Bill To
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(GST_Bill_to_State_Code; "GST Bill-to State Code") { }

            // Ship To
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }
            column(Ship_to_County; "Ship-to County") { }

            column(InvoiceNo; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(BuyerPONo; ' ') { }
            column(CDONo; '') { }
            column(DeliveryChallanNo; '') { }

            // Terms
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(DescriptionGood; "Shipment Method Code") { }
            column(intructionRemarks; '') { }

            // Bank / Payment Details
            column(AccountName; CompInfoRec.Name) { }
            column(BankName; CompInfoRec."Bank Name") { }
            column(BankAccountNo; CompInfoRec."Bank Account No.") { }
            column(IFSCCode; CompInfoRec."SWIFT Code") { }
            column(MICR; '') { }

            // Company Identifiers
            column(GSTNo; CompInfoRec."GST Registration No.") { }
            column(PANNo; CompInfoRec."P.A.N. No.") { }
            column(CINNo; '') { }
            column(TANNo; CompInfoRec."T.A.N. No.") { }

            column(AmountInWordsCaptionLbl; AmountInWordsCaptionLbl) { }

            dataitem("SalesInvoiceLine"; "Sales Invoice Line")
            {
                DataItemLinkReference = SalesInvoiceHeader;
                DataItemLink = "Document No." = FIELD("No.");

                column(Description; Description) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Line_Amount; "Line Amount") { }


                column(TotalCGSTPer; TotalCGSTPer) { }
                column(TotalIGSTPer; TotalIGSTPer) { }
                column(TotalSGSTPer; TotalSGSTPer) { }
                column(TotalBaseAmt; TotalBaseAmt) { }
                column(TotalCGSTAmt; TotalCGSTAmt) { }
                column(TotalIGSTAmt; TotalIGSTAmt) { }
                column(TotalSGSTAmt; TotalSGSTAmt) { }
                column(AllGstPer; AllGstPer) { }
                column(TotalAmount; TotalAmount) { }
                column(TotalAmtLineGSt; TotalAmtLineGSt) { }
                column(FinalTotalAmount; FinalTotalAmount) { }


                column(TotalLineAmount; TotalLineAmount) { }
                column(GrandTotalGSTAmt; GrandTotalGSTAmt) { }
                column(GrandFinalTotal; GrandFinalTotal) { }


                column(AmountInWords1; Amountinwords[1]) { }
                column(AmountInWords2; Amountinwords[2]) { }

                trigger OnAfterGetRecord()
                begin
                    if Quantity = 0 then
                        CurrReport.Skip();

                    Sno += 1;

                    Clear(TotalCGSTPer);
                    Clear(TotalIGSTPer);
                    Clear(TotalSGSTPer);
                    Clear(TotalCGSTAmt);
                    Clear(TotalIGSTAmt);
                    Clear(TotalSGSTAmt);
                    Clear(TotalBaseAmt);
                    Clear(GSTAmount);
                    Clear(AllGstPer);
                    Clear(SaveGSTPer);
                    Clear(TotalAmtLineGSt);
                    Clear(FinalTotalAmount);


                    DetailedGSTLedgerEntry.Reset();
                    DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SetRange("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    DetailedGSTLedgerEntry.SetRange("HSN/SAC Code", "HSN/SAC Code");
                    DetailedGSTLedgerEntry.CalcSums(DetailedGSTLedgerEntry."GST Amount", "GST Base Amount");
                    TotalBaseAmt := Abs(DetailedGSTLedgerEntry."GST Base Amount");

                    if DetailedGSTLedgerEntry.FindSet() then begin
                        repeat
                            if DetailedGSTLedgerEntry."GST Component Code" = 'CGST' then begin
                                TotalCGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                TotalCGSTPer := DetailedGSTLedgerEntry."GST %";
                            end;
                            if DetailedGSTLedgerEntry."GST Component Code" = 'IGST' then begin
                                TotalIGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                TotalIGSTPer := DetailedGSTLedgerEntry."GST %";
                            end;
                            if DetailedGSTLedgerEntry."GST Component Code" = 'SGST' then begin
                                TotalSGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                TotalSGSTPer := DetailedGSTLedgerEntry."GST %";
                            end;
                        until DetailedGSTLedgerEntry.Next() = 0;
                    end;

                    if (TotalCGSTPer > 0) and (TotalSGSTPer > 0) then
                        AllGstPer := TotalCGSTPer + TotalSGSTPer
                    else
                        if TotalIGSTPer > 0 then
                            AllGstPer := TotalIGSTPer;

                    TotalAmount := Abs(Amount);
                    TotalAmtLineGSt := TotalIGSTAmt + TotalCGSTAmt + TotalSGSTAmt;
                    FinalTotalAmount := "Line Amount" + TotalAmtLineGSt;

                end;

                trigger OnPreDataItem()
                begin

                    Clear(TotalLineAmount);
                    Clear(GrandTotalGSTAmt);
                    Clear(GrandFinalTotal);
                    Clear(Amountinwords);
                    Sno := 0;

                    TempSalesLine.Reset();
                    TempSalesLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    TempSalesLine.SetFilter(Quantity, '<>0');
                    if TempSalesLine.FindSet() then
                        repeat
                            TotalLineAmount += TempSalesLine."Line Amount";
                        until TempSalesLine.Next() = 0;

                    TempGSTEntry.Reset();
                    TempGSTEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
                    TempGSTEntry.SetRange("Transaction Type", TempGSTEntry."Transaction Type"::Sales);
                    TempGSTEntry.SetRange("Entry Type", TempGSTEntry."Entry Type"::"Initial Entry");
                    TempGSTEntry.CalcSums("GST Amount");
                    GrandTotalGSTAmt := Abs(TempGSTEntry."GST Amount");

                    GrandFinalTotal := TotalLineAmount + GrandTotalGSTAmt;

                    FormatNoText(Amountinwords, GrandFinalTotal, SalesInvoiceHeader."Currency Code");
                end;
            }


            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                CompInfoRec.Get();
                CompInfoRec.CalcFields(Picture);
                InitTextVariable();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }

    var
        CompInfoRec: Record "Company Information";
        Sno: Integer;
        TempSalesLine: Record "Sales Invoice Line";
        TempGSTEntry: Record "Detailed GST Ledger Entry";


        TotalAmtLineGSt: Decimal;
        FinalTotalAmount: Decimal;
        TotalAmount: Decimal;
        AllGstPer: Decimal;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        TotalCGSTPer: Decimal;
        TotalIGSTPer: Decimal;
        TotalSGSTPer: Decimal;
        TotalCGSTAmt: Decimal;
        TotalIGSTAmt: Decimal;
        TotalSGSTAmt: Decimal;
        TotalBaseAmt: Decimal;
        SaveGSTPer: Decimal;
        GSTAmount: Decimal;

        TotalLineAmount: Decimal;
        GrandTotalGSTAmt: Decimal;
        GrandFinalTotal: Decimal;

        // Amount in words
        Amountinwords: array[2] of Text[100];
        Notext1: array[2] of Text[100];
        Notext2: array[2] of Text[100];

        Text16526: Label 'Zero';
        Text16527: Label 'Hundred';
        Text16528: Label 'And';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'One';
        Text16533: Label 'Two';
        Text16534: Label 'Three';
        Text16535: Label 'Four';
        Text16536: Label 'Five';
        Text16537: Label 'Six';
        Text16538: Label 'Seven';
        Text16539: Label 'Eight';
        Text16540: Label 'Nine';
        Text16541: Label 'Ten';
        Text16542: Label 'Eleven';
        Text16543: Label 'Twelve';
        Text16544: Label 'Thirteen';
        Text16545: Label 'Fourteen';
        Text16546: Label 'Fifteen';
        Text16547: Label 'Sixteen';
        Text16548: Label 'Seventeen';
        Text16549: Label 'Eighteen';
        Text16550: Label 'Nineteen';
        Text16551: Label 'Twenty';
        Text16552: Label 'Thirty';
        Text16553: Label 'Forty';
        Text16554: Label 'Fifty';
        Text16555: Label 'Sixty';
        Text16556: Label 'Seventy';
        Text16557: Label 'Eighty';
        Text16558: Label 'Ninety';
        Text16559: Label 'Thousand';
        Text16560: Label 'Million';
        Text16561: Label 'Billion';
        Text16562: Label 'Lakh';
        Text16563: Label 'Crore';

        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];

        AmountInWordsCaptionLbl: Label 'Amount (in words):';
        Heading1: Label '"I/We hereby certify that my/our registration certificate under the Goods and Service Tax Act, 2017 is in force on the date on which the sale of the goods specified in this tax invoice is made by me/us and that the transaction of sale covered by this tax invoice has been effected by me/us and it shall be accounted for the turnover of sales while filing of return and the tax, if any, payable on the sale has been paid or shall be paid"';
        Heading2: Label 'Declaration: We declare that this invoice shows the actual price of the goods described and that all particulars are true and correct.';

    procedure FormatNoText(var NoText: array[2] of Text[100]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record 4;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        IF CurrencyCode <> '' THEN BEGIN
            Currency.GET(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ');
        END ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'Rupees');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);

        IF (CurrencyCode <> '') THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + '' + 'Only')
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'Paisa Only');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[100]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;
        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text16529, AddText);
        END;
        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
        ExponentText[5] := '';
    end;
}