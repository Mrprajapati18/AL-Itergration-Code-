report 80001 "Return Order New"
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report\ReturnOrder11.rdl';
    ApplicationArea = All;
    Caption = 'Return Order New';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST("Return Order"));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed", "Document Type";
            RequestFilterHeading = 'Purchase Return Order';
            column(No_PurchHdr; "No.")
            {
            }

            column(DiscPercentCaption; DiscPercentCaptionLbl)
            {
            }
            column(AllowInvoiceDiscCaption; AllowInvoiceDiscCaptionLbl)
            {
            }
            column(VATIdentifierCaption1; VATIdentifierCaption1Lbl)
            {
            }
            column(VATPctCaption; VATPctCaptionLbl)
            {
            }
            column(VATBaseCaption2; VATBaseCaption2Lbl)
            {
            }
            column(VATAmountCaption; VATAmountCaptionLbl)
            {
            }
            column(TotalCaption1; TotalCaption1Lbl)
            {
            }
            column(NetTotalINRCaption; NetTotalINRCaptionLbl)
            {
            }
            dataitem(CopyLoop; 2000000026)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; 2000000026)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));

                    column(VendorGSTNo; VendRegistration)
                    {
                    }
                    // Durgesh

                    column(NetTotalINR; NetTotalINR)
                    {
                    }
                    column(GSTTotal; GSTTotal)
                    {
                    }
                    column(TotalSGSTAmt; TotalSGSTAmt)
                    {
                    }
                    column(TotalCGSTAmt; TotalCGSTAmt)
                    {
                    }
                    column(TotalIGSTAmt; TotalIGSTAmt)
                    {
                    }

                    column(SGSTAmount; SGSTAmount)
                    {

                    }
                    column(CGSTAount; CGSTAount)
                    {

                    }
                    column(IGSTAmount; IGSTAmount)
                    {

                    }
                    // End Code
                    column(DirectUnitCostCaption; DirectUnitCostCaptionLbl)
                    {
                    }
                    column(AmtCaption; AmtCaptionLbl)
                    {
                    }
                    column(PurchLineInvDiscAmtCaption; PurchLineInvDiscAmtCaptionLbl)
                    {
                    }
                    column(SubtotalCaption; SubtotalCaptionLbl)
                    {
                    }
                    column(VATDiscAmtCaption; VATDiscAmtCaptionLbl)
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(ReturnOrderCopyText; STRSUBSTNO(Text004, CopyText))
                    {
                    }
                    column(CompanyAddr1; CompanyAddr1)
                    {
                    }
                    column(CompanyAddr2; CompanyAddr2)
                    {
                    }
                    column(CompanyAddr3; CompanyAddr3)
                    {
                    }
                    column(CompanyAddr4; CompanyAddr4)
                    {
                    }
                    column(CompanyAddr5; CompanyAddr5)
                    {
                    }
                    column(CompanyAddr6; CompanyAddr6)
                    {
                    }
                    column(CompanyRegistrationNo; CompanyInfo."Registration No.")
                    {

                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(DocumentDate_PurchHdr; FORMAT("Purchase Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_PurchHdr; "Purchase Header"."VAT Registration No.")
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchHdr; "Purchase Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(yourReference_PurchHdr; "Purchase Header"."Your Reference")
                    {
                    }
                    column(BuyfromVendNo_PurchHdr; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyFromAddr1; BuyFromAddr[1])
                    {
                    }
                    column(BuyFromAddr2; BuyFromAddr[2])
                    {
                    }
                    column(BuyFromAddr3; BuyFromAddr[3])
                    {
                    }
                    column(BuyFromAddr4; BuyFromAddr[4])
                    {
                    }
                    column(BuyFromAddr5; BuyFromAddr[5])
                    {
                    }
                    column(BuyFromAddr6; BuyFromAddr[6])
                    {
                    }
                    column(BuyFromAddr7; BuyFromAddr[7])
                    {
                    }
                    column(BuyFromAddr8; BuyFromAddr[8])
                    {
                    }
                    column(PricesIncVAT_PurchHdr; "Purchase Header"."Prices Including VAT")
                    {
                    }
                    column(PrsInclVATYesNo_PurchHdr; FORMAT("Purchase Header"."Prices Including VAT"))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageCaption; STRSUBSTNO(Text005, ''))
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(ReturnOrderNoCaption; ReturnOrderNoCaptionLbl)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(BuyfromVendNo_PurchHdrCaption; "Purchase Header".FIELDCAPTION("Buy-from Vendor No."))
                    {
                    }
                    column(PricesIncVAT_PurchHdrCaption; "Purchase Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1; 2000000026)
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1Number; Number)
                        {
                        }
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.BREAK;
                        end;
                    }
                    dataitem(RoundLoop; 2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(TypeInt; TypeInt)
                        {
                        }
                        column(LineAmt_PurchLine; PurchLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Description_PurchLine; "Purchase Line".Description)
                        {
                        }
                        column(Description_PurchLineCaption; "Purchase Line".FIELDCAPTION(Description))
                        {
                        }
                        column(No_PurchLine; "Purchase Line"."No.")
                        {
                        }
                        column(No_PurchLineCaption; "Purchase Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Quantity_PurchLine; "Purchase Line".Quantity)
                        {
                        }
                        column(Quantity_PurchLineCaption; "Purchase Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UnitofMeasure_PurchLine; "Purchase Line"."Unit of Measure")
                        {
                        }
                        column(UnitofMeasure_PurchLineCaption; "Purchase Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(DirectUnitCost_PurchLine; "Purchase Line"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_PurchLine; "Purchase Line"."Line Discount %")
                        {
                        }
                        column(AllowInvDisc_PurchLine; "Purchase Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_PurchLine; "Purchase Line"."VAT Identifier")
                        {
                        }
                        column(VATIdentifier_PurchLineCaption; "Purchase Line".FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(AllInvDiscYesNo_PurchLine; FORMAT("Purchase Line"."Allow Invoice Disc."))
                        {
                        }
                        column(PurchLineInvDiscountAmt; -PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineLnAmtInvDiscAmt; PurchLine."Line Amount" - PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(VATAmt; VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLnLnAmtInvDiscAmtVATAmt; PurchLine."Line Amount" - PurchLine."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATDiscountAmt; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_PurchHdr; "Purchase Header"."VAT Base Discount %")
                        {
                        }
                        column(VATBaseAmt; VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_PurchLineCaption; "Purchase Line".FIELDCAPTION("Allow Invoice Disc."))
                        {
                        }
                        dataitem(DimensionLoop2; 2000000026)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(DimensionLoop2Number; Number)
                            {
                            }
                            column(LineDimsCaption; LineDimsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN
                                PurchLine.FIND('-')
                            ELSE
                                PurchLine.NEXT;
                            "Purchase Line" := PurchLine;


                            IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "Purchase Line"."No." := '';

                            TypeInt := "Purchase Line".Type;
                            TotalSubTotal += "Purchase Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
                            TotalAmount += "Purchase Line".Amount;
                        end;


                        trigger OnPostDataItem()
                        begin
                            PurchLine.DELETEALL;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.FIND('+');
                            WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2" = '') AND
                                  (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
                                  (PurchLine.Amount = 0)
                            DO
                                MoreLines := PurchLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            PurchLine.SETRANGE("Line No.", 0, PurchLine."Line No.");
                            SETRANGE(Number, 1, PurchLine.COUNT);
                            CurrReport.CREATETOTALS(PurchLine."Line Amount", PurchLine."Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; 2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentCaption; VATPercentCaptionLbl)
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(InvDisAmtCaption; InvDisAmtCaptionLbl)
                        {
                        }
                        column(VATBaseCaption1; VATBaseCaption1Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF VATAmount = 0 THEN
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; 2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHdr; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Purchase Header"."Posting Date", "Purchase Header"."Currency Code",
                                  VATAmountLine."VAT Base", "Purchase Header"."Currency Factor"));
                            VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Purchase Header"."Posting Date", "Purchase Header"."Currency Code",
                                  VATAmountLine."VAT Amount", "Purchase Header"."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Purchase Header"."Currency Code" = '') OR
                               (VATAmountLine.GetTotalVATAmount = 0)
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", 1);
                            VALExchRate := STRSUBSTNO(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; 2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));

                        trigger OnPreDataItem()
                        begin
                            IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(Total2; 2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(SelltoCustNo_PurchHdr; "Purchase Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_PurchHdrCaption; "Purchase Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(PurchLine);
                    CLEAR(PurchPost);
                    PurchLine.DELETEALL;
                    VATAmountLine.DELETEALL;
                    PurchPost.GetPurchLines("Purchase Header", PurchLine, 0);
                    PurchLine.CalcVATAmountLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    PurchLine.UpdateVATOnLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        PurchCountPrinted.RUN("Purchase Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.GET;

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                IF "Purchaser Code" = '' THEN BEGIN
                    SalesPurchPerson.INIT;
                    PurchaserText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Purchaser Code");
                    PurchaserText := Text000
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text002, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text006, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text002, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text006, "Currency Code");
                END;

                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, "Purchase Header");

                // Durgesh 27 feb 2026
                CLEAR(VendRegistration);
                IF VendorRec.GET("Buy-from Vendor No.") THEN BEGIN
                    VendRegistration := VendorRec."GST Registration No.";
                END;
                // End Code

                IF "Buy-from Vendor No." <> "Pay-to Vendor No." THEN
                    FormatAddr.PurchHeaderPayTo(VendAddr, "Purchase Header");

                FormatAddr.PurchHeaderShipTo(ShipToAddr, "Purchase Header");
                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Buy-from Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              22, "No.", 0, 0, DATABASE::Contact, "Buy-from Contact No.", "Purchaser Code", '', "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              22, "No.", 0, 0, DATABASE::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '')
                    END;

                // Durgesh 27 Feb 2026
                Clear(CompanyAddr1);
                Clear(CompanyAddr2);
                Clear(CompanyAddr3);
                Clear(CompanyAddr4);
                Clear(CompanyAddr5);
                Clear(CompanyAddr6);
                IF ShippingLocation.GET("Location Code") THEN BEGIN
                    CompanyAddr1 := CompanyInfo.Name;
                    CompanyAddr2 := ShippingLocation.Address;
                    CompanyAddr3 := ShippingLocation."Address 2";
                    CompanyAddr4 := ShippingLocation.City;
                    CompanyAddr5 := ShippingLocation."Post Code";
                    if StateRec.Get(ShippingLocation."State Code") then begin
                        CompanyAddr6 := StateRec.Description;
                        StateName := StateRec.Description;
                        StateCode := StateRec."State Code (GST Reg. No.)";
                    end;
                END ELSE begin
                    CompanyAddr1 := CompanyInfo.Name;
                    CompanyAddr2 := CompanyInfo.Address;
                    CompanyAddr3 := CompanyInfo."Address 2";
                    CompanyAddr4 := CompanyInfo.City;
                    CompanyAddr5 := CompanyInfo."Post Code";
                    if StateRec.Get(CompanyInfo."State Code") then begin
                        CompanyAddr6 := StateRec.Description;
                        StateName := StateRec.Description;
                        StateCode := StateRec."State Code (GST Reg. No.)";
                    end;
                end;

                // ============================================================
                // GST Calculation - Durgesh
                // ============================================================
                Clear(total1);          // <-- CHANGE 1: total1 reset karo
                Clear(GSTRate);
                Clear(CGSTAount);
                Clear(CGSTRate);
                Clear(SGSTAmount);
                Clear(SGSTRate);
                Clear(IGSTAmount);
                Clear(IGSTRate);
                Clear(GSTTotal);

                PurchLineRec.Reset();
                PurchLineRec.SetRange("Document Type", "Document Type"::"Return Order");
                PurchLineRec.SetRange("Document No.", "No.");
                if PurchLineRec.FindSet() then
                    repeat
                        total1 += PurchLineRec."Line Amount";
                        TaxInfomation.Reset();
                        TaxInfomation.SetFilter("Tax Record ID", '%1', PurchLineRec.RecordId);
                        TaxInfomation.SetFilter("Value Type", '%1', TaxInfomation."Value Type"::COMPONENT);
                        TaxInfomation.SetRange("Visible on Interface", true);
                        if TaxInfomation.FindSet() then
                            repeat
                                ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxInfomation);
                                if TaxInfomation.GetAttributeColumName() = 'CGST' then begin
                                    CGSTAount += TaxInfomation.Amount;
                                    CGSTRate := TaxInfomation.Percent;
                                end;
                                if TaxInfomation.GetAttributeColumName() = 'SGST' then begin
                                    SGSTAmount += TaxInfomation.Amount;
                                    SGSTRate := TaxInfomation.Percent;
                                end;
                                if TaxInfomation.GetAttributeColumName() = 'IGST' then begin
                                    IGSTAmount += TaxInfomation.Amount;
                                    IGSTRate := TaxInfomation.Percent;
                                end;
                            until TaxInfomation.Next() = 0;
                    until PurchLineRec.Next() = 0;

                GSTTotal := CGSTAount + SGSTAmount + IGSTAmount;


                NetTotalINR := total1 + CGSTAount + SGSTAmount + IGSTAmount;

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        var
            Documenttype: Enum "Interaction Log Entry Document Type";
        begin
            LogInteraction := SegManagement.FindInteractionTemplateCode(Documenttype::"Purch. Return Ord. Cnfrmn.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        CompanyInfo.GET;
    end;

    var
        total1: Decimal;
        NetTotalINR: Decimal;

        TaxInfomation: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        PurchLineRec: Record "Purchase Line";
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        GSTTotal: Decimal;

        VendorRec: Record Vendor;
        VendRegistration: Code[20];
        StateRec: Record State;
        StateCode: Text;
        StateName: Text;

        LocationAddr: array[8] of Text[50];
        ShippingLocation: Record 14;
        CompanyAddr1: Text[50];
        CompanyAddr2: Text[50];
        CompanyAddr3: Text[50];
        CompanyAddr4: Text[50];
        CompanyAddr5: Text[50];
        CompanyAddr6: Text[50];
        CompanyAddr7: Text[50];


        TotalCGSTPer: Decimal;
        TotalIGSTPer: Decimal;
        TotalSGSTPer: Decimal;
        CustGstNo: Text[100];
        TotalSaveAdd: Decimal;

        TotalCGSTAmt: Decimal;
        TotalIGSTAmt: Decimal;
        TotalSGSTAmt: Decimal;
        TotalBaseAmt: Decimal;
        TCSAmt: Decimal;
        SaveGSTPer: Decimal;
        IGST_var: Decimal;
        CGST_var: Decimal;
        SGST_var: Decimal;

        TotalGST: Decimal;
        IGSTAmount: Decimal;
        GSTRate: Decimal;
        IGSTRate: Decimal;
        CGSTRate: Decimal;
        CGSTAount: Decimal;
        SGSTRate: Decimal;
        SGSTAmount: Decimal;

        Text000: Label 'Purchaser';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        // Text004: Label 'Return Order %1';
        Text004: Label 'Credit Note %1';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record 98;
        CompanyInfo: Record 79;
        SalesPurchPerson: Record 13;
        VATAmountLine: Record 290 temporary;
        PurchLine: Record 39 temporary;
        DimSetEntry1: Record 480;
        DimSetEntry2: Record 480;
        RespCenter: Record 5714;
        CurrExchRate: Record 330;
        PurchCountPrinted: Codeunit 317;
        FormatAddr: Codeunit "Format Address";
        PurchPost: Codeunit 90;
        SegManagement: Codeunit SegManagement;
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        OutputNo: Integer;
        TypeInt: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DirectUnitCostCaptionLbl: Label 'Direct Unit Cost';
        AmtCaptionLbl: Label 'Amount';
        PurchLineInvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        VATDiscAmtCaptionLbl: Label 'Payment Discount on VAT';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'GST Reg. No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        ReturnOrderNoCaptionLbl: Label 'Return Order No.';
        DocumentDateCaptionLbl: Label 'Document Date';
        EmailCaptionLbl: Label 'E-Mail';
        HomePageCaptionLbl: Label 'Home Page';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        VATPercentCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        InvDisAmtCaptionLbl: Label 'Invoice Discount Amount';
        VATBaseCaption1Lbl: Label 'Total';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        DiscPercentCaptionLbl: Label 'Discount %';
        AllowInvoiceDiscCaptionLbl: Label 'Allow Invoice Discount';
        VATIdentifierCaption1Lbl: Label 'VAT Identifier';
        VATPctCaptionLbl: Label 'VAT %';
        VATBaseCaption2Lbl: Label 'VAT Base';
        VATAmountCaptionLbl: Label 'VAT Amount';
        TotalCaption1Lbl: Label 'Total';
        NetTotalINRCaptionLbl: Label 'Total Amount (INR)';
}
