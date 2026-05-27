report 80000 "Posted Transfer Shipment"
{
    ApplicationArea = All;
    Caption = 'Posted Transfer Shipment';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\PostedTransferShipment.rdl';
    dataset
    {
        dataitem(TransferShipmentHeader; "Transfer Shipment Header")
        {
            column(No_; "No.")
            {

            }

            column(Transfer_Order_Date; "Transfer Order Date")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Transfer_Order_No_; "Transfer Order No.")
            {

            }
            column(CompInfo; CompInfo.Picture)
            {

            }
            column(LocAdd1; LocAdd1)
            {

            }
            column(LocAdd2; LocAdd2)
            {

            }
            column(LocCity; LocCity)
            {

            }
            column(LocpostCode; LocpostCode)
            {

            }
            column(LocToAdd; LocToAdd)
            {

            }
            column(LocToAdd2; LocToAdd2)
            {

            }
            column(LocToCity; LocToCity)
            {

            }
            column(LocTopostCode; LocTopostCode)
            {

            }
            column(E_Way_Bill_No_; "E-Way Bill No.")
            {

            }
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
            column(GSTRegNo1; GSTRegNo1)
            {

            }
            column(GSTReg2; GSTReg2)
            {

            }
            column(StateName; StateName)
            {

            }
            column(StateToName; StateToName)
            {

            }
            column(StateCodeRec1; StateCodeRec1)
            {

            }
            column(StateCodeRec2; StateCodeRec2)
            {

            }
            
            dataitem(TransShipLine; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Sno; Sno)
                {

                }
                column(Item_No_; "Item No.")
                {

                }
                column(Description; Description)
                {

                }
                column(HSN_SAC_Code; "HSN/SAC Code")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(UnitRate; UnitRate)
                {

                }

                trigger OnAfterGetRecord()

                begin
                    Sno += 1;
                    if TransShipLine.Quantity <> 0 then
                        UnitRate := TransShipLine.Amount / Quantity;

                    // GST Calculation 

                    Clear(TotalCGSTPer);
                    Clear(TotalIGSTPer);
                    Clear(TotalSGSTPer);
                    Clear(TotalCGSTAmt);
                    Clear(TotalIGSTAmt);
                    Clear(TotalSGSTAmt);
                    Clear(SaveGSTPer);
                    Clear(TotalBaseAmt);
                    Clear(GSTAmount);
                    Clear(AllGstPer);
                    DetailedGSTLedgerEntry.Reset();
                    DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SetRange("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Purchase);
                    DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    DetailedGSTLedgerEntry.SetRange("HSN/SAC Code", "HSN/SAC Code");
                    DetailedGSTLedgerEntry.CalcSums(DetailedGSTLedgerEntry."GST Amount", "GST Base Amount");
                    GSTAmount := DetailedGSTLedgerEntry."GST Base Amount" / 2;

                    if DetailedGSTLedgerEntry.FindFirst() then begin
                        if DetailedGSTLedgerEntry."GST Component Code" = 'IGST' then
                            GSTAmount := GSTAmount * 2;
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

                            // Total GSt 
                            if (TotalCGSTPer > 0) and (TotalSGSTPer > 0) then begin
                                AllGstPer := (TotalCGSTPer + TotalCGSTPer)
                            end else
                                if (TotalIGSTPer > 0) then begin
                                    AllGstPer := TotalIGSTPer;
                                end;


                        until DetailedGSTLedgerEntry.Next() = 0;

                    end;
                    TotalBaseAmt := TotalCGSTAmt + TotalIGSTAmt + TotalSGSTAmt;
                end;

                trigger OnPreDataItem()
                begin
                    Sno := 0;
                end;

            }

            trigger OnAfterGetRecord()

            begin


                LocationRec.Reset();
                LocationRec1.Reset();

                Clear(LocAdd1);
                Clear(LocAdd2);
                Clear(LocCity);
                Clear(LocpostCode);

                Clear(LocToAdd);
                Clear(LocToAdd2);
                Clear(LocToCity);
                Clear(LocTopostCode);

                LocationRec.SetRange(Code, TransferShipmentHeader."Transfer-from Code");
                if LocationRec.FindFirst() then begin
                    LocAdd1 := LocationRec.Address;
                    LocAdd2 := LocationRec."Address 2";
                    LocCity := LocationRec.City;
                    LocpostCode := LocationRec."Post Code";
                    GSTRegNo1 := LocationRec."GST Registration No.";

                    StateRecAdd1.Reset();
                    StateRecAdd1.SetRange(Code, LocationRec."State Code");
                    if StateRecAdd1.FindFirst() then begin
                        StateName := StateRecAdd1.Description;
                        StateCodeRec1 := StateRecAdd1."State Code (GST Reg. No.)"
                    end;
                end;
                LocationRec1.SetRange(Code, TransferShipmentHeader."Transfer-to Code");
                if LocationRec1.FindFirst() then begin
                    LocToAdd := LocationRec1.Address;
                    LocToAdd2 := LocationRec1."Address 2";
                    LocToCity := LocationRec1.City;
                    LocTopostCode := LocationRec1."Post Code";
                    GSTReg2 := LocationRec1."GST Registration No.";

                    StateRecAdd2.Reset();
                    StateRecAdd2.SetRange(Code, LocationRec1."State Code");
                    if StateRecAdd2.FindFirst() then begin
                        StateToName := StateRecAdd2.Description;
                        StateCodeRec2 := StateRecAdd2."State Code (GST Reg. No.)";
                    end;
                end;

            end;


            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                CompInfo.Get();
                CompInfo.CalcFields(Picture);
            end;
        }

    }
    requestpage
    {
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
        CompInfo: Record "Company Information";
        // From Location Address
        LocationRec: Record Location;
        LocAdd1: Text[100];
        LocAdd2: Text[100];
        LocpostCode: Code[20];
        LocCity: Text[20];
        StateRecAdd1: Record State;
        StateName: Text[20];
        StateCodeRec1: Code[20];
        GSTRegNo1: Code[20];

        // To Location Address
        LocationRec1: Record Location;
        LocToAdd: Text[100];
        LocToAdd2: Text[100];
        LocTopostCode: Code[20];
        LocToCity: Text[20];
        StateRecAdd2: Record State;
        StateToName: Text[20];
        StateCodeRec2: Code[20];
        GSTReg2: Code[20];

        UnitRate: Decimal;
        Sno: Integer;

        // Gst  Calculation
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


        //Amount in words 
        Amountinwords: array[2] of Text[100];

        Notext1: array[2] of Text[100];
        Notext2: array[2] of Text[100];
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
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
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

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
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + '' + ' ONLY')
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
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


    end;

}
