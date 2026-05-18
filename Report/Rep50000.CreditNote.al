
report 50000 "Credit Note" // Durgesh 06 May 2026
{
    ApplicationArea = All;
    Caption = 'Credit Note';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts\CreditNote.rdl';
    dataset
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            // Company Information
            column(No; "No.")
            {
            }
            column(CompInfoName; CompInfoRec.Name)
            {
            }
            column(CompInfoAdd1; CompInfoRec.Address)
            {
            }
            column(CompInfoAdd2; CompInfoRec."Address 2")
            {
            }
            column(CompInfoCity; CompInfoRec.City)
            {
            }
            column(CompInfoPostCode; CompInfoRec."Post Code")
            {
            }
            column(CompInfoGstReg; CompInfoRec."GST Registration No.")
            {
            }
            column(CompInfoEmail; CompInfoRec."E-Mail")
            {
            }
            column(Due_Date; Format("Due Date"))
            {
            }
            column(Document_Date; Format("Document Date"))
            {
            }

            // Bill To Address
            column(BilltoAddress; "Bill-to Address")
            {
            }
            column(BilltoAddress2; "Bill-to Address 2")
            {
            }
            column(BilltoCity; "Bill-to City")
            {
            }
            column(BilltoCountryRegionCode; "Bill-to Country/Region Code")
            {
            }
            column(BilltoCounty; "Bill-to County")
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(BilltoName; "Bill-to Name")
            {
            }
            column(BilltoName2; "Bill-to Name 2")
            {
            }
            column(BilltoPostCode; "Bill-to Post Code")
            {
            }

            column(GrandTotalBaseAmt; GrandTotalBaseAmt)
            {
            }
            column(GrandTotalGSTAmt; GrandTotalGSTAmt)
            {
            }
            column(GrandFinalTotal; GrandFinalTotal)
            {
            }

            // GST Calculation
            column(TotalCGSTPer; TotalCGSTPer)
            {
            }
            column(TotalIGSTPer; TotalIGSTPer)
            {
            }
            column(TotalSGSTPer; TotalSGSTPer)
            {
            }
            column(TotalBaseAmt; TotalBaseAmt)
            {
            }
            column(TotalCGSTAmt; TotalCGSTAmt)
            {
            }
            column(TotalIGSTAmt; TotalIGSTAmt)
            {
            }
            column(TotalSGSTAmt; TotalSGSTAmt)
            {
            }
            column(AllGstPer; AllGstPer)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(TotalAmtLineGSt; TotalAmtLineGSt)
            {
            }
            column(FinalTotalAmount; FinalTotalAmount)
            {
            }

            // Amount in Words Columns
            column(AmountInWords1; Amountinwords[1])
            {
            }
            column(AmountInWords2; Amountinwords[2])
            {
            }
            column(AmountInWordsCaptionLbl; AmountInWordsCaptionLbl)
            {
            }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = SalesCrMemoHeader;
                DataItemLink = "Document No." = FIELD("No.");
                column(Sno; Sno)
                {
                }
                column(Description; Description)
                {
                }
                column(HSN_SAC_Code; "HSN/SAC Code")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Qty__per_Unit_of_Measure; "Qty. per Unit of Measure")
                {
                }
                column(TotalLineAmount; TotalLineAmount)
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if (Quantity = 0) or ("Qty. per Unit of Measure" = 0) then
                        CurrReport.Skip();

                    Sno += 1;

                    // GST Calculation (Line Level)
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

                    DetailedGSTLedgerEntry.Reset();
                    DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SetRange("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    DetailedGSTLedgerEntry.SetRange("HSN/SAC Code", "HSN/SAC Code");
                    DetailedGSTLedgerEntry.CalcSums(DetailedGSTLedgerEntry."GST Amount", "GST Base Amount");
                    TotalBaseAmt := Abs(DetailedGSTLedgerEntry."GST Base Amount");

                    if DetailedGSTLedgerEntry.FindFirst() then begin
                        repeat
                            if DetailedGSTLedgerEntry."GST Component Code" = 'CGST' then begin
                                TotalCGSTAmt := Abs(DetailedGSTLedgerEntry."GST Amount");
                                TotalCGSTPer := DetailedGSTLedgerEntry."GST %";
                            end;
                            if DetailedGSTLedgerEntry."GST Component Code" = 'IGST' then begin
                                TotalIGSTAmt := Abs(DetailedGSTLedgerEntry."GST Amount");
                                TotalIGSTPer := DetailedGSTLedgerEntry."GST %";
                            end;
                            if DetailedGSTLedgerEntry."GST Component Code" = 'SGST' then begin
                                TotalSGSTAmt := Abs(DetailedGSTLedgerEntry."GST Amount");
                                TotalSGSTPer := DetailedGSTLedgerEntry."GST %";
                            end;
                        until DetailedGSTLedgerEntry.Next() = 0;
                    end;

                    if (TotalCGSTPer > 0) and (TotalSGSTPer > 0) then
                        AllGstPer := TotalCGSTPer + TotalCGSTPer
                    else
                        if TotalIGSTPer > 0 then
                            AllGstPer := TotalIGSTPer;

                    TotalAmount := Abs(Amount);
                    TotalAmtLineGSt := TotalIGSTAmt + TotalCGSTAmt + TotalSGSTAmt;
                    FinalTotalAmount := "Line Amount" + TotalAmtLineGSt;

                    TotalLineAmount += "Line Amount"; 
                end;
            }

            trigger OnAfterGetRecord()
            var
                CrMemoLine: Record "Sales Cr.Memo Line";
                TempGSTEntry: Record "Detailed GST Ledger Entry";
            begin
               
                CrMemoLine.SetRange("Document No.", "No.");
                CrMemoLine.CalcSums("Line Amount");
                GrandTotalBaseAmt := CrMemoLine."Line Amount";

                
                GrandTotalGSTAmt := 0;
                if CrMemoLine.FindSet() then
                    repeat
                        if (CrMemoLine.Quantity <> 0) and (CrMemoLine."Qty. per Unit of Measure" <> 0) then begin
                            TempGSTEntry.Reset();
                            TempGSTEntry.SetRange("Document No.", "No.");
                            TempGSTEntry.SetRange("Document Line No.", CrMemoLine."Line No.");
                            TempGSTEntry.SetRange("Transaction Type", TempGSTEntry."Transaction Type"::Sales);
                            TempGSTEntry.SetRange("Entry Type", TempGSTEntry."Entry Type"::"Initial Entry");
                            TempGSTEntry.CalcSums("GST Amount");
                            GrandTotalGSTAmt += Abs(TempGSTEntry."GST Amount");
                        end;
                    until CrMemoLine.Next() = 0;

                GrandFinalTotal := GrandTotalBaseAmt + GrandTotalGSTAmt;

                FormatNoText(Amountinwords, GrandFinalTotal, "Currency Code");
            end;

            trigger OnPreDataItem()
            begin
                CompInfoRec.Get();

                TotalAmtLine := 0;
                Sno := 0;

                Clear(TotalLineAmount);
                Clear(GrandTotalBaseAmt);
                Clear(GrandTotalGSTAmt);
                Clear(GrandFinalTotal);

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
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        CompInfoRec: Record "Company Information";
        Sno: Integer;
        TotalAmtLine: Decimal;
        TotalAmtLineGSt: Decimal;
        FinalTotalAmount: Decimal;
        TotalLineAmount: Decimal;

        GrandTotalBaseAmt: Decimal;
        GrandTotalGSTAmt: Decimal;
        GrandFinalTotal: Decimal;

        // Gst Calculation
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
        TotalAmount: Decimal;

        // Amount in Words
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

        Heading1: Label '"I/We hereby certify that my/our registration certificate under the Goods and Service Tax Act, 2017 is in force on the date on which the sale of the goods specified in this tax invoice is made by me/us and that the transaction of sale covered by this tax invoice has been effected by me/us and it shall be accounted for the turnover of sales while filing of return and the tax, if any, payable on the sale has been paid or shali be paid"';

        Heading2: Label 'Declaration: We declare that this invoice shows the actual price of the goods described and that all particulars are true and correct. The above mentioned products may be subject to U.S. Law. Re-export or transfer to restricted countries or denied parties contrary to U.S. or Local Law is strictly prohibited without the prior consent in writing of Avery Dennisons Law Department.';

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
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + '' + ' Only')
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' Paisa Only');
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