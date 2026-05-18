// codeunit 50000 GstJsonWriter
// {
//     trigger OnRun()
//     begin


//     end;


//     PROCEDURE ExportInvoice(Inv: code[10]; Docno: code[20]): Text;
//     BEGIN
//         IsInvoice := false;
//         if Inv = 'INV' then
//             IsInvoice := true;
//         CLEAR(CurrExRate);
//         GDocNo := Docno;
//         SalesInvoiceHeader.reset;
//         SalesInvoiceHeader.SetRange("No.", Docno);
//         IF SalesInvoiceHeader.FINDSET THEN
//             REPEAT
//                 Customer.RESET;
//                 Customer.GET(SalesInvoiceHeader."Sell-to Customer No.");
//                 Location.RESET;
//                 Location.GET(SalesInvoiceHeader."Location Code");

//                 IF Customer."GST Customer Type" IN
//                    [Customer."GST Customer Type"::Unregistered,
//                     Customer."GST Customer Type"::" "]
//                 THEN
//                     ERROR(UnRegCustErr);

//                 IF SalesInvoiceHeader."Currency Factor" <> 0 THEN
//                     CurrExRate := 1 / SalesInvoiceHeader."Currency Factor"
//                 ELSE
//                     CurrExRate := 1;
//                 DocumentNo := SalesInvoiceHeader."No.";
//                 WriteFileHeader;
//                 ReadTransDtls(Customer."GST Customer Type");
//                 ReadDocDtls;
//                 ReadSellerDtls;
//                 ReadBuyerDtls;
//                 WriteDispDtls; //NT
//                 ReadShipDtls;
//                 ReadItemList;
//                 ReadValDtls;
//                 WritePayDtls; //NT
//                 WriteAddlDocDtls; //NT
//                 WriteRefDtls;
//                 ReadExpDtls;

//             UNTIL SalesInvoiceHeader.NEXT = 0;

//         jobject2.WriteTo(VJsonText);
//         Message('My JSON : %1', VJsonText);
//         exit(VJsonText);

//     END;



//     LOCAL PROCEDURE WriteFileHeader();
//     BEGIN
//         jobject2.Add('Version', '1.1');
//     END;

//     LOCAL PROCEDURE ReadTransDtls(GSTCustType: Option " ","Registered","Unregistered","Export","Deemed Export","Exempted","SEZ Development","SEZ Unit");
//     VAR
//         catg: Text[10];
//         IgstOnIntra: Text[1];
//     BEGIN
//         IgstOnIntra := 'N';

//         IF IsInvoice THEN BEGIN
//             CASE GSTCustType OF
//                 Customer."GST Customer Type"::Registered, Customer."GST Customer Type"::Exempted:
//                     catg := 'B2B';
//                 Customer."GST Customer Type"::Export:
//                     BEGIN
//                         catg := 'EXPWP'
//                     END;
//                 Customer."GST Customer Type"::"Deemed Export":
//                     catg := 'DEXP';

//             END;

//         END ELSE BEGIN
//             CASE GSTCustType OF
//                 Customer."GST Customer Type"::Registered, Customer."GST Customer Type"::Exempted:
//                     catg := 'B2B';
//                 Customer."GST Customer Type"::Export:
//                     catg := 'EXPWP';
//                 Customer."GST Customer Type"::"Deemed Export":
//                     catg := 'DEXP';
//             END;
//         END;

//         WriteTransDtls(catg, IgstOnIntra);
//     END;

//     LOCAL PROCEDURE WriteTransDtls(catg: Text[10]; IgstOnIntra: Text[1]);
//     var
//         jsonvalue1: JsonValue;
//         text2: text;
//     BEGIN

//         jsonvalue1.SetValueToNull();
//         VJsonObjectHeader.Add('TaxSch', 'GST');
//         VJsonObjectHeader.Add('SupTyp', catg);
//         VJsonObjectHeader.Add('RegRev', 'N');
//         VJsonObjectHeader.Add('EcmGstin', jsonvalue1.AsToken());
//         VJsonObjectHeader.Add('IgstOnIntra', IgstOnIntra);
//         jobject2.Add('TranDtls', VJsonObjectHeader);
//     END;

//     LOCAL PROCEDURE ReadDocDtls();
//     VAR
//         Typ: Text[3];
//         Dt: Text[10];
//         Curr: Text[3];
//     BEGIN
//         IF IsInvoice THEN BEGIN
//             IF SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::Taxable THEN
//                 Typ := 'INV'
//             ELSE
//                 IF (SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::"Debit Note") OR
//                     (SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::Supplementary)
//                  THEN
//                     Typ := 'DBN'
//                 ELSE
//                     Typ := 'INV';
//             Dt := FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             Curr := COPYSTR(SalesInvoiceHeader."Currency Code", 1, 3);
//         END ELSE BEGIN
//             Typ := 'CRN';
//             Dt := FORMAT(SalesCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             Curr := COPYSTR(SalesCrMemoHeader."Currency Code", 1, 3);
//         END;

//         WriteDocDtls(Typ, COPYSTR(DocumentNo, 1, 16), Dt, Curr);
//     END;

//     LOCAL PROCEDURE WriteDocDtls(Typ: Text[3]; No: Text[16]; Dt: Text[10]; Curr: Text[3]);
//     var
//         jsonvalue1: JsonValue;
//     BEGIN
//         jsonvalue1.SetValueToNull();
//         Clear(VJsonObjectHeader);
//         VJsonObjectHeader.Add('Typ', Typ);
//         VJsonObjectHeader.Add('No', No);
//         VJsonObjectHeader.Add('Dt', Dt);
//         IF Curr <> '' THEN
//             VJsonObjectHeader.Add('ForCur', Curr)
//         else
//             VJsonObjectHeader.Add('ForCur', jsonvalue1.AsToken());
//         jobject2.Add('DocDtls', VJsonObjectHeader);

//     END;


//     LOCAL PROCEDURE ReadSellerDtls();
//     VAR
//         CompanyInformationBuff: Record 79;
//         LocationBuff: Record 14;
//         StateBuff: Record 18547;
//         Gstin: Text[15];
//         LglNm: Text[100];
//         TrdNm: Text[100];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[50];
//         Pin: Integer;
//         Stcd: Text[50];
//         Ph: Text[12];
//         Em: Text[100];
//     BEGIN
//         CLEAR(Loc);
//         CLEAR(Pin);
//         CLEAR(Stcd);
//         CLEAR(Ph);
//         CLEAR(Em);
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN

//                 CompanyInformationBuff.GET;
//                 LocationBuff.GET("Location Code");
//                 TrdNm := LocationBuff.Name;
//                 Gstin := LocationBuff."GSTIN Number";//PBS KK 24012023 
//                 // Gstin := '29AABCT1332L000';
//                 LglNm := LocationBuff.Name;
//                 Addr1 := LocationBuff.Address;
//                 Addr2 := LocationBuff."Address 2";
//                 IF LocationBuff.GET("Location Code") THEN BEGIN
//                     Loc := LocationBuff.City;
//                     IF NOT EVALUATE(Pin, COPYSTR(LocationBuff."Post Code", 1, 6)) THEN
//                         ERROR(PinCodeErr, "No.", LocationBuff."Post Code");
//                     StateBuff.GET(LocationBuff."State Code");
//                     Stcd := StateBuff."State Code (GST Reg. No.)";
//                     Ph := COPYSTR(LocationBuff."Phone No.", 1, 12);
//                     Em := COPYSTR(LocationBuff."E-Mail", 1, 100);
//                 END;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN

//                 CompanyInformationBuff.GET;
//                 TrdNm := CompanyInformationBuff.Name;
//                 LocationBuff.GET("Location Code");
//                 Gstin := LocationBuff."GST Registration No.";
//                 // Gstin := '29AABCT1332L000'; //PBS KK
//                 LglNm := LocationBuff.Name;
//                 Addr1 := LocationBuff.Address;
//                 Addr2 := LocationBuff."Address 2";
//                 IF LocationBuff.GET("Location Code") THEN BEGIN
//                     Loc := LocationBuff.City;
//                     IF NOT EVALUATE(Pin, COPYSTR(LocationBuff."Post Code", 1, 6)) THEN
//                         ERROR(PinCodeErr, "No.", LocationBuff."Post Code");
//                     StateBuff.GET(LocationBuff."State Code");
//                     Stcd := StateBuff."State Code (GST Reg. No.)";
//                     // Stcd := '29';
//                     Ph := COPYSTR(LocationBuff."Phone No.", 1, 12);
//                     Em := COPYSTR(LocationBuff."E-Mail", 1, 100);
//                 END;
//             END;

//         WriteSellerDtls(Gstin, LglNm, TrdNm, Addr1, Addr2, Loc, Pin, Stcd, Ph, Em);
//     END;

//     LOCAL PROCEDURE WriteSellerDtls(Gstin: Text[15]; LglNm: Text[100]; TrdNm: Text[100]; Addr1: Text[100]; Addr2: Text[100]; Loc: Text[50]; Pin: Integer; Stcd: Text[50]; Ph: Text[12]; Em: Text[100]);
//     var
//         jsonvalue1: JsonValue;
//     BEGIN
//         jsonvalue1.SetValueToNull();
//         clear(VJsonObjectHeader);
//         IF Gstin <> '' THEN
//             VJsonObjectHeader.Add('Gstin', Gstin)
//         else
//             VJsonObjectHeader.Add('Gstin', jsonvalue1.AsToken());
//         IF LglNm <> '' THEN
//             VJsonObjectHeader.Add('LglNm', LglNm)
//         else
//             VJsonObjectHeader.Add('LglNm', jsonvalue1.AsToken());
//         IF TrdNm <> '' THEN
//             VJsonObjectHeader.Add('TrdNm', TrdNm)
//         else
//             VJsonObjectHeader.Add('TrdNm', jsonvalue1.AsToken());

//         IF Addr1 <> '' THEN
//             VJsonObjectHeader.Add('Addr1', Addr1)

//         ELSE
//             VJsonObjectHeader.Add('Add', jsonvalue1.AsToken());

//         IF Addr2 <> '' THEN
//             VJsonObjectHeader.Add('Addr2', Addr2)
//         else
//             VJsonObjectHeader.Add('Addr2', jsonvalue1.AsToken());

//         IF Loc <> '' THEN
//             VJsonObjectHeader.Add('Loc', Loc)
//         ELSE
//             VJsonObjectHeader.Add('Loc', jsonvalue1.AsToken());

//         IF Pin <> 0 THEN
//             VJsonObjectHeader.Add('Pin', Pin)
//         ELSE
//             VJsonObjectHeader.Add('Pin', jsonvalue1.AsToken());
//         IF Stcd <> '' THEN
//             VJsonObjectHeader.Add('Stcd', Stcd)
//         else
//             VJsonObjectHeader.Add('Stcd', jsonvalue1.AsToken());

//         IF Ph <> '' THEN BEGIN
//             VJsonObjectHeader.Add('Ph', Ph);

//         END
//         else
//             VJsonObjectHeader.Add('Ph', jsonvalue1.AsToken());
//         IF Em <> '' THEN BEGIN
//             VJsonObjectHeader.Add('Em', Em);

//         END
//         else
//             VJsonObjectHeader.Add('Em', jsonvalue1.AsToken());
//         jobject2.Add('SellerDtls', VJsonObjectHeader);

//     END;

//     LOCAL PROCEDURE ReadBuyerDtls();
//     VAR
//         Customer: Record 18;
//         Contact: Record 5050;
//         SalesInvoiceLine: Record 113;
//         SalesCrMemoLine: Record 115;
//         ShipToAddr: Record 222;
//         StateBuff: Record 18547;
//         Gstin: Text[15];
//         LglNm: Text[100];
//         POS: Text[2];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[100];
//         Pin: Integer;
//         Stcd: Text[50];
//         Ph: Text[12];
//         Em: Text[100];
//         CountryCodeOfExport: Text[3];
//     BEGIN
//         CLEAR(POS);
//         CLEAR(Stcd);
//         CLEAR(Ph);
//         CLEAR(Em);

//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 Customer.Reset();
//                 Customer.Get(SalesInvoiceHeader."Sell-to Customer No.");
//                 IF Customer."GST Customer Type" IN
//                   [Customer."GST Customer Type"::Unregistered,
//                    Customer."GST Customer Type"::Export]
//                THEN
//                     Gstin := 'URP'
//                 ELSE
//                     Gstin := Customer."GST Registration No.";
//                 // Gstin := '29AABCT1332L000'; //PBS KK 24012023
//                 //  Gstin := '29AWGPV7107B1Z1'; //PBS KK 24012023
//                 LglNm := "Sell-to Customer Name";
//                 Addr1 := "Bill-to Address";
//                 Addr2 := "Bill-to Address 2";
//                 StateBuff.reset;
//                 StateBuff.get("GST Bill-to State Code");
//                 Loc := StateBuff.Description;
//                 // Loc := 'Bangalore';

//                 IF Customer."GST Customer Type" = Customer."GST Customer Type"::Export THEN
//                     CountryCodeOfExport := COPYSTR("Bill-to Country/Region Code", 1, 3)
//                 ELSE
//                     IF NOT EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6)) THEN
//                         ERROR(PinCodeErr, "No.", "Bill-to Post Code");

//                 // EVALUATE(Pin, '560077');
//                 SalesInvoiceLine.SETRANGE("Document No.", "No.");
//                 SalesInvoiceLine.SETFILTER("GST Place of Supply", '<>%1', SalesInvoiceLine."GST Place of Supply"::" ");
//                 IF SalesInvoiceLine.FINDFIRST THEN
//                     IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Bill-to Address" THEN BEGIN
//                         IF "GST Customer Type" IN
//                            ["GST Customer Type"::Export]
//                         THEN BEGIN
//                             Loc := CountryCodeOfExport; //NT
//                             POS := POSForExportTxt;
//                             // POS := '29';
//                             Stcd := POSForExportTxt;
//                             // Stcd := '29';

//                             // EVALUATE(Pin, '560077');

//                             EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6));
//                         END ELSE BEGIN
//                             StateBuff.RESET;
//                             StateBuff.GET("GST Bill-to State Code");
//                             POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
//                             Stcd := StateBuff."State Code (GST Reg. No.)";
//                             Loc := "Bill-to City";
//                             // POS := '29';
//                             // Stcd := POSForExportTxt;
//                             // Stcd := '29';
//                         END;

//                         IF Contact.GET("Bill-to Contact No.") THEN BEGIN
//                             Ph := COPYSTR(Contact."Phone No.", 1, 12);
//                             Em := COPYSTR(Contact."E-Mail", 1, 100);
//                         END;
//                     END ELSE
//                         IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Ship-to Address" THEN BEGIN
//                             IF "GST Customer Type" IN
//                                ["GST Customer Type"::Export]
//                                                        THEN BEGIN
//                                 Loc := CountryCodeOfExport; //NT
//                                 POS := POSForExportTxt;
//                                 Stcd := POSForExportTxt;
//                                 EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6));
//                                 // POS := '29';
//                                 // Stcd := POSForExportTxt;
//                                 // Stcd := '29';

//                                 // EVALUATE(Pin, '560077');

//                             END ELSE BEGIN
//                                 StateBuff.RESET;
//                                 StateBuff.GET("GST Ship-to State Code");
//                                 POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
//                                 // // MESSAGE(POS);
//                                 Stcd := StateBuff."State Code (GST Reg. No.)";

//                                 // POS := '29';
//                                 // Stcd := POSForExportTxt;
//                                 // Stcd := '29';
//                                 EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6));
//                                 // EVALUATE(Pin, '560077')
//                             END;

//                             IF ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code") THEN BEGIN
//                                 Ph := COPYSTR(ShipToAddr."Phone No.", 1, 12);
//                                 Em := COPYSTR(ShipToAddr."E-Mail", 1, 100);
//                                 Addr1 := ShipToAddr.Address;
//                                 Addr2 := ShipToAddr."Address 2";
//                                 Loc := ShipToAddr.City;
//                                 IF "GST Customer Type" = "GST Customer Type"::Export THEN
//                                     CountryCodeOfExport := COPYSTR(ShipToAddr."Country/Region Code", 1, 3);
//                             END;
//                         END;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 Customer.Reset();
//                 Customer.Get(SalesCrMemoHeader."Sell-to Customer No.");
//                 IF Customer."GST Customer Type" IN
//                   [Customer."GST Customer Type"::Unregistered,
//                    Customer."GST Customer Type"::Export]
//                THEN
//                     Gstin := 'URP'
//                 ELSE
//                     Gstin := Customer."GST Registration No.";
//                 // Gstin := '29AABCT1332L000'; //PBS KK 24012023
//                 LglNm := "Sell-to Customer Name";
//                 Addr1 := "Bill-to Address";
//                 Addr2 := "Bill-to Address 2";
//                 StateBuff.reset;
//                 StateBuff.get("GST Bill-to State Code");
//                 Loc := StateBuff.Description;

//                 IF Customer."GST Customer Type" = Customer."GST Customer Type"::Export THEN
//                     CountryCodeOfExport := COPYSTR("Bill-to Country/Region Code", 1, 3)
//                 ELSE
//                     IF NOT EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6)) THEN
//                         ERROR(PinCodeErr, "No.", "Bill-to Post Code");

//                 SalesCrMemoLine.SETRANGE("Document No.", "No.");
//                 SalesCrMemoLine.SETFILTER("GST Place of Supply", '<>%1', SalesCrMemoLine."GST Place of Supply"::" ");
//                 IF SalesCrMemoLine.FINDFIRST THEN
//                     IF SalesCrMemoLine."GST Place of Supply" = SalesCrMemoLine."GST Place of Supply"::"Bill-to Address" THEN BEGIN
//                         IF "GST Customer Type" IN
//                            ["GST Customer Type"::Export]
//                         THEN BEGIN
//                             Loc := CountryCodeOfExport; //NT
//                             POS := POSForExportTxt;
//                             Stcd := POSForExportTxt;
//                             EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6));
//                         END ELSE BEGIN
//                             StateBuff.RESET;
//                             StateBuff.GET("GST Bill-to State Code");
//                             POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
//                             Stcd := StateBuff."State Code (GST Reg. No.)";
//                         END;

//                         IF Contact.GET("Bill-to Contact No.") THEN BEGIN
//                             Ph := COPYSTR(Contact."Phone No.", 1, 12);
//                             Em := COPYSTR(Contact."E-Mail", 1, 100);
//                         END;
//                     END ELSE
//                         IF SalesCrMemoLine."GST Place of Supply" = SalesCrMemoLine."GST Place of Supply"::"Ship-to Address" THEN BEGIN
//                             IF "GST Customer Type" IN
//                                ["GST Customer Type"::Export]
//                                                        THEN BEGIN
//                                 Loc := CountryCodeOfExport; //NT
//                                 POS := POSForExportTxt;
//                                 Stcd := POSForExportTxt;
//                                 EVALUATE(Pin, COPYSTR("Bill-to Post Code", 1, 6));
//                             END ELSE BEGIN
//                                 StateBuff.RESET;
//                                 StateBuff.GET("GST Ship-to State Code");
//                                 POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
//                                 // MESSAGE(POS);
//                                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                             END;

//                             IF ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code") THEN BEGIN
//                                 Ph := COPYSTR(ShipToAddr."Phone No.", 1, 12);
//                                 Em := COPYSTR(ShipToAddr."E-Mail", 1, 100);
//                                 Addr1 := CopyStr(ShipToAddr.Address, 1, 100);
//                                 Addr2 := ShipToAddr."Address 2";
//                                 Loc := ShipToAddr.City;
//                                 IF "GST Customer Type" = "GST Customer Type"::Export THEN
//                                     CountryCodeOfExport := COPYSTR(ShipToAddr."Country/Region Code", 1, 3);
//                             END;
//                         END;
//             END;

//         WriteBuyerDtls(Gstin, LglNm, POS, Addr1, Addr2, Loc, Pin, Stcd, Ph, Em, CountryCodeOfExport);
//     END;

//     LOCAL PROCEDURE WriteBuyerDtls(Gstin: Text[15]; LglNm: Text[100]; POS: Text[2]; Addr1: Text[100]; Addr: Text[100]; Loc: Text[100]; Pin: Integer; Stcd: Text[50]; Ph: Text[12]; Em: Text[100]; CountryCodeOfExport: Text[3]);
//     var
//         Addr2: Text[2];
//         jsonvalue1: JsonValue;
//     BEGIN
//         jsonvalue1.SetValueToNull();

//         Clear(VJsonObjectHeader);
//         IF Gstin <> '' THEN
//             VJsonObjectHeader.Add('Gstin', Gstin)
//         ELSE
//             VJsonObjectHeader.Add('Gstin', jsonvalue1.AsToken());
//         IF LglNm <> '' THEN
//             VJsonObjectHeader.Add('LglNm', LglNm)
//         ELSE
//             VJsonObjectHeader.Add('LglNm', jsonvalue1.AsToken());
//         IF LglNm <> '' THEN
//             VJsonObjectHeader.Add('TrdNm', LglNm)
//         ELSE
//             VJsonObjectHeader.Add('TrdNm', jsonvalue1.AsToken());
//         VJsonObjectHeader.Add('Pos', POS);
//         IF Addr1 <> '' THEN
//             VJsonObjectHeader.Add('Addr1', Addr1)
//         ELSE
//             VJsonObjectHeader.Add('Addr1', jsonvalue1.AsToken());
//         IF Addr2 <> '' THEN
//             VJsonObjectHeader.Add('Addr2', Addr2)
//         else
//             VJsonObjectHeader.Add('Addr2', jsonvalue1.AsToken());


//         IF Loc <> '' THEN
//             VJsonObjectHeader.Add('Loc', Loc)
//         else
//             VJsonObjectHeader.Add('Loc', jsonvalue1.AsToken());
//         IF Pin <> 0 THEN
//             VJsonObjectHeader.Add('Pin', Pin)
//         else
//             VJsonObjectHeader.Add('Pin', jsonvalue1.AsToken());
//         IF Stcd <> '' THEN
//             VJsonObjectHeader.Add('Stcd', Stcd)

//         ELSE
//             VJsonObjectHeader.Add('Stcd', jsonvalue1.AsToken());
//         IF CountryCodeOfExport <> '' THEN
//             VJsonObjectHeader.Add('Country_Code_Of_Export', CountryCodeOfExport) //NT
//                                                                                  //NT
//         else
//             VJsonObjectHeader.Add('Country_Code_Of_Export', jsonvalue1.AsToken()); //NT
//         IF Ph <> '' THEN
//             VJsonObjectHeader.Add('Ph', Ph)
//         ELSE
//             VJsonObjectHeader.Add('Ph', jsonvalue1.AsToken());
//         IF Em <> '' THEN
//             VJsonObjectHeader.Add('Em', Em)

//         ELSE
//             VJsonObjectHeader.Add('Em', jsonvalue1.AsToken());
//         jobject2.Add('BuyerDtls', VJsonObjectHeader);

//     END;

//     LOCAL PROCEDURE ReadShipDtls();
//     VAR
//         ShipToAddr: Record 222;
//         StateBuff: Record 18547;
//         Gstin: Text[15];
//         LglNm: Text[60];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[100];
//         Pin: Integer;
//         Stcd: Text[2];
//     BEGIN
//         IF IsInvoice AND (SalesInvoiceHeader."Ship-to Code" <> '') THEN BEGIN
//             WITH SalesInvoiceHeader DO BEGIN
//                 ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
//                 IF "GST Customer Type" = "GST Customer Type"::Export THEN
//                     Gstin := 'URP'
//                 ELSE
//                     Gstin := ShipToAddr."GST Registration No.";
//                 LglNm := "Ship-to Name";
//                 Addr1 := ShipToAddr.Address;
//                 Addr2 := ShipToAddr."Address 2";
//                 Loc := "Ship-to City";
//                 IF NOT EVALUATE(Pin, COPYSTR("Ship-to Post Code", 1, 6)) THEN
//                     ERROR(PinCodeErr, "No.", "Ship-to Post Code");
//                 StateBuff.GET("GST Ship-to State Code");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";
//             END;
//             WriteShipDtls(Gstin, LglNm, Addr1, Addr2, Loc, Pin, Stcd);
//         END ELSE
//             IF SalesCrMemoHeader."Ship-to Code" <> '' THEN BEGIN
//                 WITH SalesCrMemoHeader DO BEGIN
//                     ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
//                     IF "GST Customer Type" = "GST Customer Type"::Export THEN
//                         Gstin := 'URP'
//                     ELSE
//                         Gstin := ShipToAddr."GST Registration No.";
//                     LglNm := "Ship-to Name";
//                     Addr1 := "Ship-to Address";
//                     Addr2 := "Ship-to Address 2";
//                     Loc := "Ship-to City";
//                     IF NOT EVALUATE(Pin, COPYSTR("Ship-to Post Code", 1, 6)) THEN
//                         ERROR(PinCodeErr, "No.", "Ship-to Post Code");
//                     StateBuff.GET("GST Ship-to State Code");
//                     Stcd := StateBuff."State Code (GST Reg. No.)";
//                 END;
//                 WriteShipDtls(Gstin, LglNm, Addr1, Addr2, Loc, Pin, Stcd);
//             END;
//     END;

//     LOCAL PROCEDURE WriteShipDtls(Gstin: Text[15]; LglNm: Text[60]; Addr1: Text[100]; Addr2: Text[100]; Loc: Text[100]; Pin: Integer; Stcd: Text[2]);
//     var
//         jsonvalue1: JsonValue;
//     BEGIN
//         jsonvalue1.SetValueToNull();
//         Clear(VJsonObjectHeader);

//         IF Gstin <> '' THEN
//             VJsonObjectHeader.Add('Gstin', Gstin)
//         else
//             VJsonObjectHeader.Add('Gstin', jsonvalue1.AsToken());
//         IF LglNm <> '' THEN
//             VJsonObjectHeader.Add('LglNm', LglNm)
//         else
//             VJsonObjectHeader.Add('LglNm', jsonvalue1.AsToken());

//         VJsonObjectHeader.Add('TrdNm', jsonvalue1.AsToken());
//         IF Addr1 <> '' THEN
//             VJsonObjectHeader.Add('Addr1', Addr1)

//         ELSE
//             VJsonObjectHeader.Add('Addr1', jsonvalue1.AsToken());
//         IF Addr2 <> '' THEN
//             VJsonObjectHeader.Add('Addr2', Addr2)
//         ELSE
//             VJsonObjectHeader.Add('Addr2', jsonvalue1.AsToken());
//         IF Loc <> '' THEN
//             VJsonObjectHeader.Add('Loc', Loc)
//         ELSE
//             VJsonObjectHeader.Add('Loc', jsonvalue1.AsToken());

//         IF Pin <> 0 THEN
//             VJsonObjectHeader.Add('Pin', Pin)

//         else
//             VJsonObjectHeader.Add('Pin', jsonvalue1.AsToken());
//         IF Stcd <> '' THEN
//             VJsonObjectHeader.Add('Stcd', Stcd)


//         ELSE
//             VJsonObjectHeader.Add('Stcd', jsonvalue1.AsToken());
//         jobject2.Add('ShipDtls', VJsonObjectHeader);


//     END;

//     LOCAL PROCEDURE WriteDispDtls();
//     BEGIN
//     END;




//     LOCAL PROCEDURE ReadItemList();
//     VAR
//         SalesInvoiceLine: Record 113;
//         SalesCrMemoLine: Record 115;
//         AssAmt: Decimal;
//         CgstAmt: Decimal;
//         SgstAmt: Decimal;
//         IgstAmt: Decimal;
//         CesRt: Decimal;
//         CesAmt: Decimal;
//         CesNonAdval: Decimal;
//         StateCesRt: Decimal;
//         StateCesAmt: Decimal;
//         FreeQty: Decimal;
//         StateCesNonAdvlAmt: Decimal;
//         SlNo: Integer;
//         UOM: Text[10];
//         IsServc: Text[1];
//         GSTRt: Decimal;
//         Item: Record Item;
//         OrgCntry: Text;
//         JobjectArray: JsonArray;

//     BEGIN
//         CLEAR(SlNo);
//         IF IsInvoice THEN BEGIN
//             SalesInvoiceLine.SETRANGE("Document No.", DocumentNo);
//             SalesInvoiceLine.SETRANGE("Non-GST Line", FALSE); //NT
//             SalesInvoiceLine.SETFILTER(Quantity, '<>%1', 0);
//             IF SalesInvoiceHeader."GST Customer Type" <> SalesInvoiceHeader."GST Customer Type"::Export THEN BEGIN
//                 SalesInvoiceLine.SETFILTER("GST Group Code", '<>%1', '');
//                 SalesInvoiceLine.SETFILTER("HSN/SAC Code", '<>%1', '');
//                 SalesInvoiceLine.SETFILTER("VAT Base Amount", '<>%1', 0);
//             END;
//             IF SalesInvoiceLine.FINDSET THEN BEGIN
//                 // IF SalesInvoiceLine.COUNT > 1000 THEN
//                 //     ERROR(SalesLinesErr, SalesInvoiceLine.COUNT);
//                 // REPEAT

//                 //     SlNo += 1;
//                 //     IF SalesInvoiceLine."GST On Assessable Value" THEN //NT
//                 //         AssAmt := SalesInvoiceLine."GST Assessable Value (LCY)"
//                 //     ELSE //NT
//                 //         AssAmt := SalesInvoiceLine."vat Base Amount";
//                 //     IF SalesInvoiceLine.Amount = 0 THEN
//                 //         FreeQty := SalesInvoiceLine.Quantity
//                 //     ELSE
//                 //         FreeQty := 0;

//                 //     //PBS-SAG
//                 //     IF SalesInvoiceLine."GST On Assessable Value" THEN //NT
//                 //         AssAmt := SalesInvoiceLine."GST Assessable Value (LCY)"
//                 //     ELSE //NT
//                 //         AssAmt := SalesInvoiceLine."VAT Base Amount";
//                 //     //PBS-SAG    

//                 //     GetGSTCompRate(
//                 //       SalesInvoiceLine."Document No.",
//                 //       SalesInvoiceLine."Line No.",
//                 //       GSTRt,
//                 //       CgstAmt,
//                 //       SgstAmt,
//                 //       IgstAmt,
//                 //       CesRt,
//                 //       CesAmt,
//                 //       CesNonAdval,
//                 //       StateCesRt,
//                 //       StateCesAmt,
//                 //       StateCesNonAdvlAmt, 'SALE');
//                 //     TotalCgstAmt += CgstAmt;
//                 //     TotalIgstAmt += IgstAmt;
//                 //     TotalSgstAmt += SgstAmt;
//                 //     CLEAR(UOM);
//                 //     IF SalesInvoiceLine."Unit of Measure Code" <> '' THEN
//                 //         UOM := COPYSTR(SalesInvoiceLine."Unit of Measure Code", 1, 10) //NT
//                 //                                                                        //        UOM := COPYSTR(SalesInvoiceLine."Unit of Measure Code",1,8) //NT
//                 //     ELSE
//                 //         UOM := OTHTxt;

//                 //     //PBS-SAG
//                 //     // UOM := Format(SalesInvoiceLine."Billing UOM");
//                 //     //PBS-SAG

//                 //     IF SalesInvoiceLine."GST Group Type" = SalesInvoiceLine."GST Group Type"::Service THEN
//                 //         IsServc := 'Y'
//                 //     ELSE
//                 //         IsServc := 'N';
//                 //     IF SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item THEN
//                 //         IF Item.GET(SalesInvoiceLine."No.") THEN
//                 //             OrgCntry := COPYSTR(Item."Country/Region of Origin Code", 1, 2);
//                 //     IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
//                 //         AssAmt := SalesInvoiceLine."Line Amount" + SalesInvoiceLine."Line Discount Amount";

//                 //     if SalesInvoiceLine.Type = SalesInvoiceLine.Type::"G/L Account" then begin

//                 //         WriteItem(
//                 //           SalesInvoiceLine.Description + SalesInvoiceLine."Description 2",
//                 //           SalesInvoiceLine."HSN/SAC Code",
//                 //           SalesInvoiceLine.Quantity,
//                 //           FreeQty,
//                 //           UOM,
//                 //           SalesInvoiceLine."Unit Price",
//                 //           SalesInvoiceLine."VAT Base Amount" + SalesInvoiceLine."Line Discount Amount",
//                 //           SalesInvoiceLine."Line Discount Amount",
//                 //           AssAmt,
//                 //           GSTRt,
//                 //           CgstAmt,
//                 //           SgstAmt,
//                 //           IgstAmt,
//                 //           CesRt,
//                 //           CesAmt,
//                 //           CesNonAdval,
//                 //           StateCesRt,
//                 //           StateCesAmt,
//                 //           StateCesNonAdvlAmt,
//                 //         SalesInvoiceLine.Amount,
//                 //         SalesInvoiceLine."Line No.",
//                 //           SlNo,
//                 //           IsServc);
//                 //     end;

//                 //     //For Item
//                 //     if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
//                 //         WriteItem(
//                 //       SalesInvoiceLine.Description + SalesInvoiceLine."Description 2",
//                 //       SalesInvoiceLine."HSN/SAC Code",
//                 //       SalesInvoiceLine."Custom Qty",
//                 //       FreeQty,
//                 //       UOM,
//                 //       SalesInvoiceLine."Custom Rate",
//                 //       SalesInvoiceLine."VAT Base Amount" + SalesInvoiceLine."Line Discount Amount",
//                 //       SalesInvoiceLine."Line Discount Amount",
//                 //       AssAmt,
//                 //       GSTRt,
//                 //       CgstAmt,
//                 //       SgstAmt,
//                 //       IgstAmt,
//                 //       CesRt,
//                 //       CesAmt,
//                 //       CesNonAdval,
//                 //       StateCesRt,
//                 //       StateCesAmt,
//                 //       StateCesNonAdvlAmt,
//                 //     SalesInvoiceLine.Amount,
//                 //     SalesInvoiceLine."Line No.",
//                 //       SlNo,
//                 //       IsServc);
//                 //     end;
//                 //     //For Item
//                 //     JobjectArray.Add(jobjectline);
//                 // UNTIL SalesInvoiceLine.NEXT = 0;
//                 // jobject2.Add('ItemList', JobjectArray);

//             END;
//         END ELSE BEGIN

//             SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
//             SalesCrMemoLine.SETRANGE("Non-GST Line", FALSE); //NT
//             SalesCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
//             IF SalesCrMemoHeader."GST Customer Type" <> SalesCrMemoHeader."GST Customer Type"::Export THEN BEGIN
//                 SalesCrMemoLine.SETFILTER("GST Group Code", '<>%1', '');
//                 SalesCrMemoLine.SETFILTER("HSN/SAC Code", '<>%1', '');
//                 SalesCrMemoLine.SETFILTER("VAT Base Amount", '<>%1', 0);
//             END;
//             IF SalesCrMemoLine.FindSet() THEN BEGIN
//                 IF SalesCrMemoLine.COUNT > 1000 THEN
//                     ERROR(SalesLinesErr, SalesCrMemoLine.COUNT);

//                 REPEAT
//                     SlNo += 1;
//                     IF SalesCrMemoLine."GST On Assessable Value" THEN //NT
//                         AssAmt := SalesCrMemoLine."GST Assessable Value (LCY)" //NT
//                     ELSE //NT
//                         AssAmt := SalesCrMemoLine."VAT Base Amount";


//                     IF SalesCrMemoLine.Amount = 0 THEN
//                         FreeQty := SalesCrMemoLine.Quantity
//                     ELSE
//                         FreeQty := 0;

//                     GetGSTCompRate(
//                       SalesCrMemoLine."Document No.",
//                       SalesCrMemoLine."Line No.",
//                       GSTRt,
//                       CgstAmt,
//                       SgstAmt,
//                       IgstAmt,
//                       CesRt,
//                       CesAmt,
//                       CesNonAdval,
//                       StateCesRt,
//                       StateCesAmt,
//                       StateCesNonAdvlAmt, 'CREDITNOTE');
//                     TotalCgstAmt += CgstAmt;
//                     TotalIgstAmt += IgstAmt;
//                     TotalSgstAmt += SgstAmt;
//                     CLEAR(UOM);
//                     IF SalesCrMemoLine."Unit of Measure Code" <> '' THEN
//                         UOM := COPYSTR(SalesCrMemoLine."Unit of Measure Code", 1, 10) //NT

//                     ELSE
//                         UOM := OTHTxt;
//                     IF SalesCrMemoLine."GST Group Type" = SalesCrMemoLine."GST Group Type"::Service THEN
//                         IsServc := 'Y'
//                     ELSE
//                         IsServc := 'N';

//                     IF SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item THEN
//                         IF Item.GET(SalesCrMemoLine."No.") THEN
//                             OrgCntry := COPYSTR(Item."Country/Region of Origin Code", 1, 2);
//                     IF SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Export THEN
//                         AssAmt := SalesCrMemoLine."Line Amount" + SalesCrMemoLine."Line Discount Amount";
//                     WriteItem(
//                       SalesCrMemoLine.Description + SalesCrMemoLine."Description 2",
//                       SalesCrMemoLine."HSN/SAC Code",
//                       SalesCrMemoLine.Quantity, FreeQty,
//                       UOM,
//                       SalesCrMemoLine."Unit Price",
//                       SalesCrMemoLine."Line Amount" + SalesCrMemoLine."Line Discount Amount",
//                       SalesCrMemoLine."Line Discount Amount",
//                       AssAmt,
//                       GSTRt,
//                       CgstAmt,
//                       SgstAmt,
//                       IgstAmt,
//                       CesRt,
//                       CesAmt,
//                       CesNonAdval,
//                       StateCesRt,
//                       StateCesAmt,
//                       StateCesNonAdvlAmt,
//                      SalesCrMemoLine.Amount,
//                     SalesCrMemoLine."Line No.",
//                       SlNo,
//                       IsServc);
//                     JobjectArray.Add(jobjectline);
//                 UNTIL SalesCrMemoLine.NEXT = 0;
//                 jobject2.Add('ItemList', JobjectArray);
//             END;
//         END;
//     END;

//     LOCAL PROCEDURE WriteItem(PrdDesc: Text[300]; HsnCd: Text[8]; Qty: Decimal; FreeQty: Decimal; Unit: Text[10]; UnitPrice: Decimal; TotAmt: Decimal; Discount: Decimal; AssAmt: Decimal; GSTRt: Decimal; CgstAmt: Decimal; SgstAmt: Decimal; IgstAm: Decimal; CesRt: Decimal; CesAmt: Decimal; CesNonAdval: Decimal; StateCes: Decimal; StateCesAmt: Decimal; StateCesNonAdvlAmt: Decimal; TotItemVal: Decimal; SILineNo: Integer; SlNo: Integer; IsServc: Text[1]);
//     VAR
//         ValueEntry: Record 5802;
//         ItemLedgerEntry: Record 32;
//         ValueEntryRelation: Record 6508;
//         InvoiceRowID: Text[250];
//         xLotNo: Code[20];
//         UnitofMeasure: Record 204;
//         jsonvalue1: JsonValue;
//     BEGIN
//         jsonvalue1.SetValueToNull();
//         Clear(jobjectline);
//         jobjectline.Add('SlNo', FORMAT(SlNo));
//         IF IsServc <> '' THEN
//             jobjectline.Add('IsServc', IsServc)

//         ELSE
//             jobjectline.Add('IsServc', jsonvalue1.AsToken());



//         IF PrdDesc <> '' THEN
//             jobjectline.Add('PrdDesc', PrdDesc)
//         else
//             jobjectline.Add('PrdDesc', jsonvalue1.AsToken());
//         if HsnCd = '4202210' then HsnCd := '996511';

//         if HsnCd = '27101900' then HsnCd := '271019';

//         if HsnCd = '0988009' then HsnCd := '73066100';

//         IF HsnCd <> '' THEN
//             jobjectline.Add('HsnCd', HsnCd)
//         else
//             jobjectline.Add('HsnCd', jsonvalue1.AsToken());



//         jobjectline.Add('Barcde', jsonvalue1.AsToken());


//         jobjectline.Add('Qty', Qty);

//         IF FreeQty <> 0 THEN BEGIN
//             jobjectline.Add('FreeQty', FORMAT(FreeQty));

//         END;

//         // IF Unit <> ' ' THEN BEGIN
//         //     UnitofMeasure.RESET; //NT
//         //     UnitofMeasure.GET(Unit); //NT
//         //     jobjectline.Add('Unit', UnitofMeasure."GST Reporting UQC");

//         // END ELSE
//         jobjectline.Add('Unit', Unit);

//         jobjectline.Add('UnitPrice', ROUND((UnitPrice * CurrExRate), 0.001, '>'));

//         jobjectline.Add('TotAmt', ROUND((TotAmt * CurrExRate), 0.01, '='));

//         jobjectline.Add('Discount', Discount * CurrExRate);


//         jobjectline.Add('PreTaxVal', 0.0);


//         jobjectline.Add('AssAmt', AssAmt * CurrExRate);

//         if (IgstAm + CgstAmt + SgstAmt) = 0 then GSTRt := 0;
//         jobjectline.Add('GstRt', GSTRt);

//         jobjectline.Add('IgstAmt', Round(IgstAm, 0.01, '>'));


//         jobjectline.Add('CgstAmt', CgstAmt);


//         jobjectline.Add('SgstAmt', SgstAmt);


//         jobjectline.Add('CesRt', CesRt);


//         jobjectline.Add('CesAmt', CesAmt);


//         jobjectline.Add('CesNonAdvlAmt', CesNonAdval);


//         jobjectline.Add('StateCesRt', StateCes);


//         jobjectline.Add('StateCesAmt', StateCesAmt);


//         jobjectline.Add('StateCesNonAdvlAmt', StateCesNonAdvlAmt);

//         //PBS KK 24022023

//         jobjectline.Add('TotItemVal', ROUND(((TotItemVal + StateCesNonAdvlAmt + CesAmt + CgstAmt + SgstAmt + IgstAm) * CurrExRate), 0.01, '='));


//         JobjectArray.Add(jobjectline);

//     END;





//     LOCAL PROCEDURE GetGSTCompRate(DocNo: Code[20]; LineNo: Integer; VAR GSTRt: Decimal; VAR CgstAmt: Decimal; VAR SgstAmt: Decimal; VAR IgstAmt: Decimal; VAR CesRt: Decimal; VAR CesAmt: Decimal; VAR CesNonAdval: Decimal; VAR StateCesRt: Decimal; VAR StateCesAmt: Decimal; VAR StateCesNonAdvlAmt: Decimal; DOCTYPE: TEXT[10]);
//     VAR
//         DetailedGSTLedgerEntry: Record 18001;
//         // GSTLedgerEntry: Record 18001;
//         GSTComponent: Record 18202;
//         PostedTransferShipmentLine: Record "Transfer Shipment Line";
//         SalesInvoiceLine: Record 113;
//         SalesCreditMemoLine: Record "Sales Cr.Memo Line";
//     BEGIN

//         CLEAR(GSTRt);
//         CLEAR(CgstAmt);
//         CLEAR(SgstAmt);
//         CLEAR(IgstAmt);
//         DetailedGSTLedgerEntry.SETRANGE("Document No.", DocNo);
//         DetailedGSTLedgerEntry.SETRANGE("Document Line No.", LineNo);
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
//             GSTRt := DetailedGSTLedgerEntry."GST %";
//             CgstAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
//         END;

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
//             GSTRt += DetailedGSTLedgerEntry."GST %";
//             SgstAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
//         END;

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
//             GSTRt := DetailedGSTLedgerEntry."GST %";
//             IgstAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
//         END;

//         CesNonAdval := 0;
//         CesAmt := 0;
//         CLEAR(CesRt);
//         DetailedGSTLedgerEntry.SETFILTER("GST Component Code", '%1|%2', 'CESS', 'INTERCESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
//             CesRt := DetailedGSTLedgerEntry."GST %";
//             IF DetailedGSTLedgerEntry."GST %" <> 0 THEN
//                 CesAmt := ABS(DetailedGSTLedgerEntry."GST Amount")
//             ELSE
//                 CesNonAdval := ABS(DetailedGSTLedgerEntry."GST Amount");
//         END;




//         StateCesRt := 0;
//         StateCesAmt := 0;
//         Clear(StateCesNonAdvlAmt);


//         IF DOCTYPE = 'SALE' then begin
//             SalesInvoiceLine.Reset();
//             SalesInvoiceLine.SETRANGE("Document No.", DocNo);
//             SalesInvoiceLine.SETRANGE("Line No.", LineNo);
//             if SalesInvoiceLine.FindFirst() then begin
//                 StateCesNonAdvlAmt := GetAdCessAmount(SalesInvoiceLine.RecordId, 0);
//             end;
//         end;

//         IF DOCTYPE = 'CREDITNOTE' then begin
//             SalesCreditMemoLine.Reset();
//             SalesCreditMemoLine.SETRANGE("Document No.", DocNo);
//             SalesCreditMemoLine.SETRANGE("Line No.", LineNo);
//             if SalesCreditMemoLine.FindFirst() then begin
//                 StateCesNonAdvlAmt := GetAdCessAmount(SalesCreditMemoLine.RecordId, 0);
//             end;
//         end;


//         IF DOCTYPE = 'TRANSFER' then begin
//             PostedTransferShipmentLine.Reset();
//             PostedTransferShipmentLine.SETRANGE("Document No.", DocNo);
//             PostedTransferShipmentLine.SETRANGE("Line No.", LineNo);
//             if PostedTransferShipmentLine.FindFirst() then begin
//                 StateCesNonAdvlAmt := GetAdCessAmount(PostedTransferShipmentLine.RecordId, 0);
//             end;
//         end;


//         //PBS KK 27022023


//     END;

//     local procedure GetAdCessAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
//     var
//         TaxTransactionRec: Record "Tax Transaction Value";
//         TaxVal: Decimal;
//     begin
//         TaxTransactionRec.reset;
//         TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
//         TaxTransactionRec.SetRange("Tax Type", 'GST');
//         TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
//         TaxTransactionRec.SetRange("Value ID", 10017);
//         if TaxTransactionRec.FindFirst() then begin
//             if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
//             if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
//         end;
//         exit(TaxVal);
//     end;

//     //PBS KK 24022024

//     LOCAL PROCEDURE GetGSTVal(VAR AssVal: Decimal; VAR CgstVal: Decimal; VAR SgstVal: Decimal; VAR IgstVal: Decimal; VAR CesVal: Decimal; VAR StCesVal: Decimal; VAR Disc: Decimal; VAR OthChrg: Decimal; VAR TotInvVal: Decimal; VAR RndOffAmt: Decimal; VAR TotiInvValFc: Decimal);
//     VAR
//         SalesInvoiceLine: Record 113;
//         SalesCrMemoLine: Record 115;
//         GSTLedgerEntry: Record "GST Ledger Entry";
//         CurrExchRate: Record 330;
//         GeneralLedgerSetup: Record 98;
//         TotGSTAmt: Decimal;
//         TotLineAmt: Decimal;
//         PostedTransferShipmentLine: Record "Transfer Shipment Line";
//         DetailedGSTLedgerEntrys: record "GST Ledger Entry";

//     BEGIN
//         RndOffAmt := 0;
//         TotiInvValFc := 0;

//         GSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
//         GSTLedgerEntry.SETRANGE("Transaction Type", GSTLedgerEntry."Transaction Type"::Sales);
//         IF IsInvoice THEN BEGIN
//             GSTLedgerEntry.SETRANGE("Posting Date", SalesInvoiceHeader."Posting Date");
//             GSTLedgerEntry.SETRANGE("Document Type", GSTLedgerEntry."Document Type"::Invoice);
//         END ELSE BEGIN
//             GSTLedgerEntry.SETRANGE("Posting Date", SalesCrMemoHeader."Posting Date");
//             GSTLedgerEntry.SETRANGE("Document Type", GSTLedgerEntry."Document Type"::"Credit Memo");
//         END;
//         GSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 CgstVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             CgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 SgstVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             SgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 IgstVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             IgstVal := 0;

//         //PBS KK 27022023

//         CesVal := 0;
//         DetailedGSTLedgerEntrys.SETFILTER("GST Component Code", '%1|%2', 'CESS', 'INTERCESS');
//         DetailedGSTLedgerEntrys.SETRANGE("Document No.", DocumentNo);
//         IF DetailedGSTLedgerEntrys.FINDFIRST THEN BEGIN
//             REPEAT
//                 CesVal += ABS(DetailedGSTLedgerEntrys."GST Amount");
//             UNTIL DetailedGSTLedgerEntrys.NEXT = 0;
//         END;




//         StCesVal := 0;
//         CLEAR(TotLineAmt);
//         PostedTransferShipmentLine.Reset();
//         PostedTransferShipmentLine.SETRANGE("Document No.", DocumentNo);
//         if PostedTransferShipmentLine.FindSet() then begin
//             TotGSTAmt := CgstVal + SgstVal + IgstVal;
//             REPEAT
//                 StCesVal += GetAdCessAmount(PostedTransferShipmentLine.RecordId, 0);
//                 TotLineAmt += SalesInvoiceLine."Line Amount";
//             until PostedTransferShipmentLine.Next() = 0;

//             TotInvVal := TotLineAmt + TotGSTAmt - Disc + StCesVal + CesVal; //PBS KK 27022023
//         end;

//         //PBS KK 27022023









//         CLEAR(TotLineAmt);
//         GeneralLedgerSetup.GET;
//         IF IsInvoice THEN BEGIN
//             SalesInvoiceLine.SETRANGE("Document No.", DocumentNo);
//             IF SalesInvoiceLine.FINDSET THEN BEGIN
//                 REPEAT
//                     TotLineAmt += SalesInvoiceLine."Line Amount";

//                     AssVal += SalesInvoiceLine."VAT Base Amount";
//                     TotGSTAmt += 0;

//                 //Disc += SalesInvoiceLine."Inv. Discount Amount"; //PBS-sag
//                 UNTIL SalesInvoiceLine.NEXT = 0;
//             END;

//             SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::"G/L Account");
//             SalesInvoiceLine.SETFILTER("No.", '%1', GeneralLedgerSetup."GST Opening Account");
//             IF SalesInvoiceLine.FINDFIRST THEN
//                 REPEAT
//                     RndOffAmt += SalesInvoiceLine."Line Amount";
//                 UNTIL SalesInvoiceLine.NEXT = 0;

//             TotiInvValFc := TotLineAmt + TotGSTAmt - Disc;
//             TotLineAmt := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesInvoiceHeader."Posting Date",
//                   SalesInvoiceHeader."Currency Code", TotLineAmt, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
//             AssVal := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesInvoiceHeader."Posting Date",
//                   SalesInvoiceHeader."Currency Code", AssVal, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
//             TotGSTAmt := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesInvoiceHeader."Posting Date",
//                   SalesInvoiceHeader."Currency Code", TotGSTAmt, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
//             Disc := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesInvoiceHeader."Posting Date",
//                   SalesInvoiceHeader."Currency Code", Disc, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
//             TotInvVal := TotLineAmt + TotGSTAmt - Disc;

//         END ELSE BEGIN
//             SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
//             IF SalesCrMemoLine.FINDSET THEN BEGIN
//                 REPEAT
//                     TotLineAmt += SalesCrMemoLine."Line Amount";
//                     AssVal += SalesCrMemoLine."VAT Base Amount";
//                     TotGSTAmt += 0;
//                     Disc += SalesCrMemoLine."Inv. Discount Amount";
//                 UNTIL SalesCrMemoLine.NEXT = 0;
//             END;

//             SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::"G/L Account");
//             SalesCrMemoLine.SETFILTER("No.", '%1', GeneralLedgerSetup."GST Opening Account");
//             IF SalesCrMemoLine.FINDFIRST THEN
//                 REPEAT
//                     RndOffAmt += SalesCrMemoLine."Line Amount";
//                 UNTIL SalesCrMemoLine.NEXT = 0;

//             TotiInvValFc := TotLineAmt + TotGSTAmt - Disc;
//             TotLineAmt := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesCrMemoHeader."Posting Date",
//                   SalesCrMemoHeader."Currency Code", TotLineAmt, SalesCrMemoHeader."Currency Factor"), 0.01, '=');
//             AssVal := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesCrMemoHeader."Posting Date",
//                   SalesCrMemoHeader."Currency Code", AssVal, SalesCrMemoHeader."Currency Factor"), 0.01, '=');
//             TotGSTAmt := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesCrMemoHeader."Posting Date",
//                   SalesCrMemoHeader."Currency Code", TotGSTAmt, SalesCrMemoHeader."Currency Factor"), 0.01, '=');
//             Disc := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(SalesCrMemoHeader."Posting Date",
//                   SalesCrMemoHeader."Currency Code", Disc, SalesCrMemoHeader."Currency Factor"), 0.01, '=');

//             TotInvVal := TotLineAmt + TotGSTAmt - Disc;
//         END;


//         OthChrg := 0;
//     END;


//     LOCAL PROCEDURE ReadValDtls();
//     VAR
//         AssVal: Decimal;
//         CgstVal: Decimal;
//         SgstVal: Decimal;
//         IgstVal: Decimal;
//         CesVal: Decimal;
//         StCesVal: Decimal;
//         Disc: Decimal;
//         OthChrg: Decimal;
//         TotInvVal: Decimal;
//         RndOffAmt: Decimal;
//         TotiInvValFc: Decimal;
//     BEGIN
//         GetGSTVal(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, Disc, OthChrg, TotInvVal, RndOffAmt, TotiInvValFc);
//         IF IsInvoice THEN BEGIN
//             IF SalesInvoiceHeader."GST Customer Type" <> SalesInvoiceHeader."GST Customer Type"::Export THEN
//                 WriteValDtls(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);
//             IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
//                 WriteValDtls(TotInvVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);
//         END ELSE BEGIN
//             IF SalesCrMemoHeader."GST Customer Type" <> SalesCrMemoHeader."GST Customer Type"::Export THEN
//                 WriteValDtls(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);
//             IF SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Export THEN
//                 WriteValDtls(TotInvVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);
//         END;
//     END;

//     LOCAL PROCEDURE WriteValDtls(Assval: Decimal; CgstVal: Decimal; SgstVAl: Decimal; IgstVal: Decimal; CesVal: Decimal; StCesVal: Decimal; TotInvVal: Decimal; RndOffAmt: Decimal; TotiInvValFc: Decimal; Disc: Decimal);
//     var
//         TCSEntry: Record "TCS Entry";
//         Tcsamt: Decimal;
//     BEGIN
//         Clear(VJsonObjectHeader);
//         VJsonObjectHeader.Add('AssVal', Round(Assval, 1, '='));//PBS KK 05-09-2023
//         VJsonObjectHeader.Add('CgstVal', TotalCgstAmt);
//         VJsonObjectHeader.Add('SgstVal', TotalSgstAmt);
//         VJsonObjectHeader.Add('IgstVal', ROUND(TotalIgstAmt, 0.01, '>'));
//         VJsonObjectHeader.Add('CesVal', CesVal);
//         VJsonObjectHeader.Add('StCesVal', StCesVal);
//         VJsonObjectHeader.Add('Discount', Disc);
//         TCSEntry.Reset();
//         TCSEntry.SetCurrentKey("Document No.");
//         TCSEntry.SetRange("Document No.", GDocNo);
//         if TCSEntry.FindFirst() then
//             repeat
//                 Tcsamt += TCSEntry."TCS Amount";
//             until TCSEntry.Next = 0;
//         if Tcsamt > 0 then
//             VJsonObjectHeader.Add('OthChrg', Tcsamt);
//         VJsonObjectHeader.Add('RndOffAmt', RndOffAmt);

//         // VJsonObjectHeader.Add('TotInvVal', TotInvVal + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>'));
//         // VJsonObjectHeader.Add('TotiInvValFc', TotiInvValFc + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>'));

//         if RndOffAmt <> 0 then begin
//             if RndOffAmt < 0 then begin
//                 VJsonObjectHeader.Add('TotInvVal', (Round(Assval, 1, '=') + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>') + Tcsamt) - abs(RndOffAmt));
//                 VJsonObjectHeader.Add('TotiInvValFc', (Round(Assval, 1, '=') + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>') + Tcsamt) - abs(RndOffAmt));
//             end else begin
//                 VJsonObjectHeader.Add('TotInvVal', (Round(Assval, 1, '=') + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>') + Tcsamt) + abs(RndOffAmt));
//                 VJsonObjectHeader.Add('TotiInvValFc', (Round(Assval, 1, '=') + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>') + Tcsamt) + abs(RndOffAmt));
//             end;
//         end else begin
//             VJsonObjectHeader.Add('TotInvVal', (Round(Assval, 1, '=') + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>') + Tcsamt));
//             VJsonObjectHeader.Add('TotiInvValFc', Round(Assval, 1, '=') + TotalCgstAmt + TotalSgstAmt + ROUND(TotalIgstAmt, 0.01, '>') + Tcsamt);
//         end;
//         jobject2.Add('ValDtls', VJsonObjectHeader);


//     END;


//     LOCAL PROCEDURE WritePayDtls();
//     BEGIN
//     END;



//     LOCAL PROCEDURE WriteAddlDocDtls();
//     BEGIN
//     END;





//     LOCAL PROCEDURE WriteRefDtls();
//     VAR
//         CustLedgerEntry: Record 21;
//     BEGIN

//     END;


//     LOCAL PROCEDURE ReadExpDtls();
//     VAR
//         SalesInvoiceLine: Record 113;
//         SalesCrMemoLine: Record 115;
//         ExpCati8: Text[3];
//         ShipBNo: Text[20];
//         ShipBDt: Text[10];
//         Port: Text[10];
//         InvForCur: Decimal;
//         CntCode: Text[2];
//         RefClm: Text[1];
//         ExpCat: Text[3];
//     BEGIN
//         RefClm := 'N';
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 IF "GST Customer Type" IN
//                ["GST Customer Type"::Export,
//                       "GST Customer Type"::"Deemed Export"]
//             THEN BEGIN
//                     CASE "GST Customer Type" OF
//                         "GST Customer Type"::Export:
//                             ExpCat := 'DIR';
//                         "GST Customer Type"::"Deemed Export":
//                             ExpCat := 'DEM';

//                     END;
//                     ShipBNo := COPYSTR("Bill Of Export No.", 1, 20);
//                     ShipBDt := FORMAT("Bill Of Export Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                     Port := "Exit Point";
//                     SalesInvoiceLine.SETRANGE("Document No.", "No.");
//                     IF SalesInvoiceLine.FINDSET THEN
//                         REPEAT

//                         UNTIL SalesInvoiceLine.NEXT = 0;
//                     CntCode := COPYSTR("Bill-to Country/Region Code", 1, 2);
//                     IF "GST Without Payment of Duty" THEN
//                         RefClm := 'Y';
//                 END ELSE
//                     EXIT;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN

//                 EXIT;
//             END;

//         WriteExpDtls(ShipBNo, ShipBDt, Port, CntCode, RefClm);
//     END;

//     LOCAL PROCEDURE WriteExpDtls(ShipBNo: Text[20]; ShipBDt: Text[10]; Port: Text[10]; CntCode: Text[2]; RefClm: Text[1]);
//     var
//         jsonvalue1: JsonValue;
//     BEGIN




//         IF ShipBNo <> '' THEN
//             VJsonObjectHeader.Add('ShipBNo', ShipBNo)
//         else
//             VJsonObjectHeader.Add('ShipBNo', jsonvalue1.AsToken());
//         IF ShipBDt <> '' THEN
//             VJsonObjectHeader.Add('ShipBDt', ShipBDt)
//         else
//             VJsonObjectHeader.Add('ShipBDt', jsonvalue1.AsToken());
//         IF Port <> '' THEN
//             VJsonObjectHeader.Add('Port', Port)
//         else
//             VJsonObjectHeader.Add('Port', jsonvalue1.AsToken());

//         VJsonObjectHeader.Add('RefClm', RefClm);
//         IF CntCode <> '' THEN
//             VJsonObjectHeader.Add('CntCode', CntCode)
//         else
//             VJsonObjectHeader.Add('CntCode', jsonvalue1.AsToken());


//     END;





//     //Sales Credit Memo
//     PROCEDURE ExportCrMemo(IsCrMemo: code[10]; Docno: Code[20]): Text;
//     BEGIN
//         if IsCrMemo = 'CRMEMO' then
//             IsInvoice := false;

//         CLEAR(CurrExRate);
//         SalesCrMemoHeader.Reset;
//         SalesCrMemoHeader.SetRange("No.", Docno);
//         IF SalesCrMemoHeader.FINDSET THEN
//             REPEAT
//                 Customer.RESET;
//                 Customer.GET(SalesCrMemoHeader."Sell-to Customer No.");
//                 Location.RESET;
//                 Location.GET(SalesCrMemoHeader."Location Code");

//                 IF SalesCrMemoHeader."GST Customer Type" IN
//                    [SalesCrMemoHeader."GST Customer Type"::Unregistered,
//                     SalesCrMemoHeader."GST Customer Type"::" "]
//                 THEN
//                     ERROR(UnRegCustErr);
//                 IF SalesCrMemoHeader."Currency Factor" <> 0 THEN
//                     CurrExRate := 1 / SalesCrMemoHeader."Currency Factor"
//                 ELSE
//                     CurrExRate := 1;
//                 DocumentNo := SalesCrMemoHeader."No.";
//                 WriteFileHeader;
//                 ReadTransDtls(SalesCrMemoHeader."GST Customer Type");
//                 ReadDocDtls;
//                 ReadSellerDtls;
//                 ReadBuyerDtls;
//                 WriteDispDtls;
//                 ReadShipDtls;
//                 ReadItemList;
//                 ReadValDtls;
//                 WritePayDtls;
//                 WriteAddlDocDtls;
//                 WriteRefDtls;
//                 ReadExpDtls;
//             UNTIL SalesCrMemoHeader.NEXT = 0;
//         jobject2.WriteTo(VJsonText);
//         Message('My JSON : %1', VJsonText);
//         exit(VJsonText);
//     END;


//     //Purchase Credit memo

//     PROCEDURE ExportPurchaseCrMemo(Inv: code[10]; Docno: code[20]): Text;
//     BEGIN
//         IsInvoice := false;
//         if Inv = 'INV' then
//             IsInvoice := true;
//         CLEAR(CurrExRate);
//         PurchCrMemoHdr.reset;
//         PurchCrMemoHdr.SetRange("No.", Docno);
//         IF PurchCrMemoHdr.FINDSET THEN
//             REPEAT
//                 Vendor.RESET;
//                 Vendor.GET(PurchCrMemoHdr."Buy-from Vendor No.");
//                 Location.RESET;
//                 Location.GET(PurchCrMemoHdr."Location Code");

//                 IF Vendor."GST Vendor Type" IN
//                    [Vendor."GST Vendor Type"::Unregistered,
//                     Vendor."GST Vendor Type"::" "]
//                 THEN
//                     ERROR(UnRegCustErr);

//                 IF PurchCrMemoHdr."Currency Factor" <> 0 THEN
//                     CurrExRate := 1 / PurchCrMemoHdr."Currency Factor"
//                 ELSE
//                     CurrExRate := 1;
//                 DocumentNo := PurchCrMemoHdr."No.";
//                 WriteFileHeader;
//                 PurchaseReturnReadTransDtls(Vendor."GST Vendor Type");
//                 PurchaseReturnReadDocDtls;
//                 PurchaseReturnReadSellerDtls;
//                 PurchaseReturnReadBuyerDtls;
//                 WriteDispDtls;
//                 PurchaseReturnReadShipDtls();
//                 PurchaseReturnReadItemList();
//                 PurchaseReturnReadValDtls();
//                 PurchaseReturnReadExpDtls;
//             UNTIL PurchCrMemoHdr.NEXT = 0;
//         jobject2.WriteTo(VJsonText);
//         Message('My JSON : %1', VJsonText);
//         exit(VJsonText);
//     END;


//     LOCAL PROCEDURE PurchaseReturnReadTransDtls(GSTCustType: Option " ","Registered","Unregistered","Export","Deemed Export","Exempted","SEZ Development","SEZ Unit");
//     VAR
//         catg: Text[10];
//         IgstOnIntra: Text[1];
//     BEGIN
//         IgstOnIntra := 'N';

//         IF IsInvoice THEN BEGIN
//             CASE GSTCustType OF
//                 Vendor."GST Vendor Type"::Registered, Vendor."GST Vendor Type"::Exempted:
//                     catg := 'B2B';
//                 Vendor."GST Vendor Type"::Import:
//                     BEGIN
//                         catg := 'EXPWP'
//                     END;

//             END;
//         END;
//         WriteTransDtls(catg, IgstOnIntra);
//     END;

//     LOCAL PROCEDURE PurchaseReturnReadDocDtls();
//     VAR
//         Typ: Text[3];
//         Dt: Text[10];
//         Curr: Text[3];
//     BEGIN
//         IF IsInvoice THEN BEGIN
//             IF PurchCrMemoHdr."Invoice Type" = PurchCrMemoHdr."Invoice Type"::"Non-GST" THEN //Taxable
//                 Typ := 'INV'
//             ELSE
//                 IF (PurchCrMemoHdr."Invoice Type" = PurchCrMemoHdr."Invoice Type"::"Debit Note") OR
//                     (PurchCrMemoHdr."Invoice Type" = PurchCrMemoHdr."Invoice Type"::Supplementary)
//                  THEN
//                     Typ := 'DBN'
//                 ELSE
//                     Typ := 'INV';
//             Dt := FORMAT(PurchCrMemoHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             Curr := COPYSTR(PurchCrMemoHdr."Currency Code", 1, 3);
//         END ELSE BEGIN
//             Typ := 'CRN';
//             Dt := FORMAT(PurchCrMemoHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             Curr := COPYSTR(PurchCrMemoHdr."Currency Code", 1, 3);
//         END;

//         WriteDocDtls(Typ, COPYSTR(DocumentNo, 1, 16), Dt, Curr);
//     END;



//     LOCAL PROCEDURE PurchaseReturnReadSellerDtls();
//     VAR
//         CompanyInformationBuff: Record 79;
//         LocationBuff: Record 14;
//         StateBuff: Record 18547;
//         Gstin: Text[15];
//         LglNm: Text[100];
//         TrdNm: Text[100];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[50];
//         Pin: Integer;
//         Stcd: Text[50];
//         Ph: Text[12];
//         Em: Text[100];
//     BEGIN
//         CLEAR(Loc);
//         CLEAR(Pin);
//         CLEAR(Stcd);
//         CLEAR(Ph);
//         CLEAR(Em);
//         WITH PurchCrMemoHdr DO BEGIN
//             CompanyInformationBuff.GET;
//             TrdNm := CompanyInformationBuff.Name;
//             LocationBuff.GET("Location Code");
//             // Gstin := LocationBuff."GST Registration No.";
//             Gstin := LocationBuff."GSTIN Number";
//             LglNm := LocationBuff.Name;
//             Addr1 := LocationBuff.Address;
//             Addr2 := LocationBuff."Address 2";
//             IF LocationBuff.GET("Location Code") THEN BEGIN
//                 Loc := LocationBuff.City;
//                 IF NOT EVALUATE(Pin, COPYSTR(LocationBuff."Post Code", 1, 6)) THEN
//                     ERROR(PinCodeErr, "No.", LocationBuff."Post Code");
//                 StateBuff.GET(LocationBuff."State Code");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                 Ph := COPYSTR(LocationBuff."Phone No.", 1, 12);
//                 Em := COPYSTR(LocationBuff."E-Mail", 1, 100);
//             END;
//         END;

//         WriteSellerDtls(Gstin, LglNm, TrdNm, Addr1, Addr2, Loc, Pin, Stcd, Ph, Em);
//     END;


//     LOCAL PROCEDURE PurchaseReturnReadBuyerDtls();
//     VAR
//         Vendor: Record Vendor;
//         Contact: Record 5050;
//         SalesInvoiceLine: Record 113;
//         PurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
//         ShipToAddr: Record 222;
//         StateBuff: Record 18547;
//         Gstin: Text[15];
//         LglNm: Text[100];
//         POS: Text[2];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[100];
//         Pin: Integer;
//         Stcd: Text[50];
//         Ph: Text[12];
//         Em: Text[100];
//         CountryCodeOfExport: Text[3];
//         LocationBuff: Record Location;
//     BEGIN
//         CLEAR(POS);
//         CLEAR(Stcd);
//         CLEAR(Ph);
//         CLEAR(Em);
//         WITH PurchCrMemoHdr DO BEGIN
//             Vendor.get(PurchCrMemoHdr."Buy-from Vendor No.");
//             IF Vendor."GST Vendor Type" IN
//                [Vendor."GST Vendor Type"::Unregistered,
//                 Vendor."GST Vendor Type"::Import]
//             THEN
//                 Gstin := 'URP'
//             ELSE
//                 Gstin := Vendor."GST Registration No.";
//             LglNm := "Buy-from Vendor Name";
//             Addr1 := "Buy-from Address";
//             Addr2 := "Buy-from Address 2";
//             IF LocationBuff.GET("Location Code") THEN BEGIN
//                 Loc := LocationBuff.City;
//             END;
//             // Loc := "Location State Code";
//             IF "GST Vendor Type" = "GST Vendor Type"::Import THEN
//                 CountryCodeOfExport := COPYSTR("Buy-from Country/Region Code", 1, 3)
//             ELSE
//                 IF NOT EVALUATE(Pin, COPYSTR("Buy-from Post Code", 1, 6)) THEN
//                     ERROR(PinCodeErr, "No.", "Buy-from Post Code");
//             StateBuff.RESET;
//             StateBuff.GET(Vendor."State Code");
//             POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
//             Stcd := StateBuff."State Code (GST Reg. No.)";

//             IF Contact.GET("Buy-from Contact No.") THEN BEGIN
//                 Ph := COPYSTR(Contact."Phone No.", 1, 12);
//                 Em := COPYSTR(Contact."E-Mail", 1, 100);
//             END;

//         END;

//         WriteBuyerDtls(Gstin, LglNm, POS, Addr1, Addr2, Loc, Pin, Stcd, Ph, Em, CountryCodeOfExport);
//     END;



//     LOCAL PROCEDURE PurchaseReturnReadShipDtls();
//     VAR
//         ShipToAddr: Record 222;
//         StateBuff: Record 18547;
//         Gstin: Text[15];
//         LglNm: Text[60];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[100];
//         Pin: Integer;
//         Stcd: Text[2];
//     BEGIN
//         IF PurchCrMemoHdr."Ship-to Code" <> '' THEN BEGIN
//             WITH PurchCrMemoHdr DO BEGIN
//                 ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
//                 IF "GST Vendor Type" = "GST Vendor Type"::Import THEN
//                     Gstin := 'URP'
//                 ELSE
//                     Gstin := ShipToAddr."GST Registration No.";
//                 LglNm := "Ship-to Name";
//                 Addr1 := "Ship-to Address";
//                 Addr2 := "Ship-to Address 2";
//                 Loc := "Ship-to City";
//                 IF NOT EVALUATE(Pin, COPYSTR("Ship-to Post Code", 1, 6)) THEN
//                     ERROR(PinCodeErr, "No.", "Ship-to Post Code");
//                 StateBuff.GET("Location State Code");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";
//             END;
//             WriteShipDtls(Gstin, LglNm, Addr1, Addr2, Loc, Pin, Stcd);
//         END;
//     END;

//     LOCAL PROCEDURE PurchaseReturnReadItemList();
//     VAR
//         PurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
//         AssAmt: Decimal;
//         CgstAmt: Decimal;
//         SgstAmt: Decimal;
//         IgstAmt: Decimal;
//         CesRt: Decimal;
//         CesAmt: Decimal;
//         CesNonAdval: Decimal;
//         StateCesRt: Decimal;
//         StateCesAmt: Decimal;
//         FreeQty: Decimal;
//         StateCesNonAdvlAmt: Decimal;
//         SlNo: Integer;
//         UOM: Text[10];
//         IsServc: Text[1];
//         GSTRt: Decimal;
//         Item: Record Item;
//         OrgCntry: Text;
//         JobjectArray: JsonArray;

//     BEGIN
//         CLEAR(SlNo);

//         PurchaseCrMemoLine.SETRANGE("Document No.", DocumentNo);
//         PurchaseCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
//         IF PurchaseCrMemoLine.FindSet THEN BEGIN
//             IF PurchaseCrMemoLine.COUNT > 1000 THEN
//                 ERROR(SalesLinesErr, PurchaseCrMemoLine.COUNT);
//             REPEAT
//                 SlNo += 1;

//                 // PurchaseCrMemoLine.CalcFields("Gst Base Amount");
//                 // AssAmt := ABS(PurchaseCrMemoLine."Gst Base Amount");
//                 IF PurchaseCrMemoLine.Amount = 0 THEN
//                     FreeQty := PurchaseCrMemoLine.Quantity
//                 ELSE
//                     FreeQty := 0;


//                 GetGSTCompRate(
//                   PurchaseCrMemoLine."Document No.",
//                   PurchaseCrMemoLine."Line No.",
//                   GSTRt,
//                   CgstAmt,
//                   SgstAmt,
//                   IgstAmt,
//                   CesRt,
//                   CesAmt,
//                   CesNonAdval,
//                   StateCesRt,
//                   StateCesAmt,
//                   StateCesNonAdvlAmt, 'DEBITNOTE');
//                 TotalCgstAmt += CgstAmt;
//                 TotalIgstAmt += IgstAmt;
//                 TotalSgstAmt += SgstAmt;
//                 CLEAR(UOM);
//                 IF PurchaseCrMemoLine."Unit of Measure Code" <> '' THEN
//                     UOM := COPYSTR(PurchaseCrMemoLine."Unit of Measure Code", 1, 10) //NT
//                 ELSE
//                     UOM := OTHTxt;
//                 IF PurchaseCrMemoLine."GST Group Type" = PurchaseCrMemoLine."GST Group Type"::Service THEN
//                     IsServc := 'Y'
//                 ELSE
//                     IsServc := 'N';
//                 IF PurchaseCrMemoLine.Type = PurchaseCrMemoLine.Type::Item THEN
//                     IF Item.GET(PurchaseCrMemoLine."No.") THEN
//                         OrgCntry := COPYSTR(Item."Country/Region of Origin Code", 1, 2);
//                 IF PurchCrMemoHdr."GST Vendor Type" = PurchCrMemoHdr."GST Vendor Type"::Import THEN
//                     AssAmt := ABS(PurchaseCrMemoLine."Line Amount" + PurchaseCrMemoLine."Line Discount Amount");
//                 WriteItem(
//                   PurchaseCrMemoLine.Description + PurchaseCrMemoLine."Description 2",
//                   PurchaseCrMemoLine."HSN/SAC Code",
//                   PurchaseCrMemoLine.Quantity, FreeQty,
//                   UOM,
//                   PurchaseCrMemoLine."Unit Price (LCY)",
//                   PurchaseCrMemoLine."Line Amount" + PurchaseCrMemoLine."Line Discount Amount",
//                   PurchaseCrMemoLine."Line Discount Amount",
//                   AssAmt,
//                   GSTRt,
//                   CgstAmt,
//                   SgstAmt,
//                   IgstAmt,
//                   CesRt,
//                   CesAmt,
//                   CesNonAdval,
//                   StateCesRt,
//                   StateCesAmt,
//                   StateCesNonAdvlAmt,
// PurchaseCrMemoLine.Amount,
//                 PurchaseCrMemoLine."Line No.",
//                   SlNo,
//                   IsServc);
//                 JobjectArray.Add(jobjectline);
//             //Clear(jobjectline);
//             UNTIL PurchaseCrMemoLine.NEXT = 0;
//             jobject2.Add('ItemList', JobjectArray);
//         END;
//     END;


//     LOCAL PROCEDURE PurchaseReturnReadValDtls();
//     VAR
//         AssVal: Decimal;
//         CgstVal: Decimal;
//         SgstVal: Decimal;
//         IgstVal: Decimal;
//         CesVal: Decimal;
//         StCesVal: Decimal;
//         Disc: Decimal;
//         OthChrg: Decimal;
//         TotInvVal: Decimal;
//         RndOffAmt: Decimal;
//         TotiInvValFc: Decimal;
//     BEGIN
//         PurchaseReturnGetGSTVal(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, Disc, OthChrg, TotInvVal, RndOffAmt, TotiInvValFc);

//         IF PurchCrMemoHdr."GST Vendor Type" <> PurchCrMemoHdr."GST Vendor Type"::Import THEN
//             WriteValDtls(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);
//         IF PurchCrMemoHdr."GST Vendor Type" = PurchCrMemoHdr."GST Vendor Type"::Import THEN
//             WriteValDtls(TotInvVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);

//     END;


//     LOCAL PROCEDURE PurchaseReturnReadExpDtls();
//     VAR
//         PurchCrMemoLine: Record "Purch. Cr. Memo Line";
//         SalesCrMemoLine: Record 115;
//         //         GSTManagement: Codeunit "GST Posting Management";
//         ExpCati8: Text[3];
//         ShipBNo: Text[20];
//         ShipBDt: Text[10];
//         Port: Text[10];
//         InvForCur: Decimal;
//         CntCode: Text[2];
//         RefClm: Text[1];
//         ExpCat: Text[3];
//     BEGIN
//         RefClm := 'N';
//         IF IsInvoice THEN
//             WITH PurchCrMemoHdr DO BEGIN
//                 IF "GST Vendor Type" IN
//                ["GST Vendor Type"::Import]

//             THEN BEGIN
//                     CASE "GST Vendor Type" OF
//                         "GST Vendor Type"::Import:
//                             ExpCat := 'DIR';

//                     END;
//                     ShipBNo := COPYSTR("Bill of Entry No.", 1, 20);
//                     ShipBDt := FORMAT("Bill Of Entry Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                     //Port := "Exit Point";

//                     CntCode := COPYSTR("Pay-to Country/Region Code", 1, 2);
//                     // IF "GST Without Payment of Duty" THEN
//                     //     RefClm := 'Y';
//                     IF "Associated Enterprises" THEN
//                         RefClm := 'Y';
//                 END ELSE
//                     EXIT;
//             END;

//         WriteExpDtls(ShipBNo, ShipBDt, Port, CntCode, RefClm);
//     END;

//     LOCAL PROCEDURE PurchaseReturnGetGSTVal(VAR AssVal: Decimal; VAR CgstVal: Decimal; VAR SgstVal: Decimal; VAR IgstVal: Decimal; VAR CesVal: Decimal; VAR StCesVal: Decimal; VAR Disc: Decimal; VAR OthChrg: Decimal; VAR TotInvVal: Decimal; VAR RndOffAmt: Decimal; VAR TotiInvValFc: Decimal);
//     VAR
//         PurchCrMemoLine: Record "Purch. Cr. Memo Line";
//         GSTLedgerEntry: Record "GST Ledger Entry";
//         CurrExchRate: Record 330;
//         GeneralLedgerSetup: Record 98;
//         TotGSTAmt: Decimal;
//         TotLineAmt: Decimal;
//     BEGIN
//         RndOffAmt := 0;
//         TotiInvValFc := 0;

//         GSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
//         GSTLedgerEntry.SETRANGE("Transaction Type", GSTLedgerEntry."Transaction Type"::Purchase);
//         GSTLedgerEntry.SETRANGE("Posting Date", PurchCrMemoHdr."Posting Date");
//         GSTLedgerEntry.SETRANGE("Document Type", GSTLedgerEntry."Document Type"::"Credit Memo");
//         GSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 CgstVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             CgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 SgstVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             SgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 IgstVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             IgstVal := 0;

//         CesVal := 0;
//         GSTLedgerEntry.SETFILTER("GST Component Code", '%1|%2', 'CESS', 'INTERCESS');
//         IF GSTLedgerEntry.FINDSET THEN
//             REPEAT
//                 CesVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;


//         CLEAR(TotLineAmt);
//         GeneralLedgerSetup.GET;

//         PurchCrMemoLine.SETRANGE("Document No.", DocumentNo);
//         IF PurchCrMemoLine.FINDSET THEN BEGIN
//             REPEAT
//                 TotLineAmt += PurchCrMemoLine."Line Amount";
//                 // PurchCrMemoLine.CalcFields("Gst Base Amount");
//                 // AssVal += ABS(PurchCrMemoLine."GST Base Amount");
//                 Disc += PurchCrMemoLine."Inv. Discount Amount";
//             UNTIL PurchCrMemoLine.NEXT = 0;
//         END;

//         TotiInvValFc := TotLineAmt + TotGSTAmt - Disc;
//         TotLineAmt := ROUND(
//             CurrExchRate.ExchangeAmtFCYToLCY(PurchCrMemoHdr."Posting Date",
//               PurchCrMemoHdr."Currency Code", TotLineAmt, PurchCrMemoHdr."Currency Factor"), 0.01, '=');
//         AssVal := ROUND(
//             CurrExchRate.ExchangeAmtFCYToLCY(PurchCrMemoHdr."Posting Date",
//               PurchCrMemoHdr."Currency Code", AssVal, PurchCrMemoHdr."Currency Factor"), 0.01, '=');
//         TotGSTAmt := ROUND(
//             CurrExchRate.ExchangeAmtFCYToLCY(PurchCrMemoHdr."Posting Date",
//               PurchCrMemoHdr."Currency Code", TotGSTAmt, PurchCrMemoHdr."Currency Factor"), 0.01, '=');
//         Disc := ROUND(
//             CurrExchRate.ExchangeAmtFCYToLCY(PurchCrMemoHdr."Posting Date",
//               PurchCrMemoHdr."Currency Code", Disc, PurchCrMemoHdr."Currency Factor"), 0.01, '=');
//         TotInvVal := TotLineAmt + TotGSTAmt - Disc;
//     END;






//     //Transfer Details
//     PROCEDURE TransferExportInvoice(TRANS: code[10]; Docno: code[20]): text;
//     BEGIN

//         IsInvoice := true;
//         CLEAR(CurrExRate);
//         TransferShipmentHeader.SetRange("No.", Docno);
//         IF TransferShipmentHeader.FINDSET THEN
//             REPEAT
//                 BuyerLocation.RESET;
//                 BuyerLocation.GET(TransferShipmentHeader."Transfer-to Code");
//                 IF BuyerLocation."GST Registration No." = '' THEN
//                     ERROR(UnRegCustErr);
//                 SellerLocation.RESET;
//                 SellerLocation.GET(TransferShipmentHeader."Transfer-from Code");
//                 IF SellerLocation."GST Registration No." = '' THEN
//                     ERROR(UnRegCustErr);

//                 CurrExRate := 1;

//                 DocumentNo := TransferShipmentHeader."No.";
//                 WriteFileHeader;
//                 TransferReadTransDtls(1);
//                 TransferReadDocDtls;
//                 TransferReadSellerDtls;
//                 TransferReadBuyerDtls;
//                 TransferReadItemList;
//                 TransferReadValDtls;
//             UNTIL TransferShipmentHeader.NEXT = 0;
//         jobject2.WriteTo(VJsonText);
//         Message('My JSON : %1', VJsonText);
//         exit(VJsonText);
//     END;

//     LOCAL PROCEDURE TransferReadTransDtls(GSTCustType: Option " ","Registered","Unregistered","Export","Deemed Export","Exempted","SEZ Development","SEZ Unit");
//     VAR
//         catg: Text[10];
//         IgstOnIntra: Text[1];
//     BEGIN
//         IgstOnIntra := 'N';
//         catg := 'B2B';
//         IF IsInvoice THEN BEGIN

//         END;

//         WriteTransDtls(catg, IgstOnIntra);
//     END;

//     LOCAL PROCEDURE TransferReadDocDtls();
//     VAR
//         Typ: Text[3];
//         Dt: Text[10];
//         Curr: Text[3];
//     BEGIN
//         IF IsInvoice THEN BEGIN
//             Typ := 'INV';
//             Dt := FORMAT(TransferShipmentHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             Curr := 'INR';
//         END;

//         WriteDocDtls(Typ, COPYSTR(DocumentNo, 1, 16), Dt, Curr);
//     END;

//     LOCAL PROCEDURE TransferReadSellerDtls();
//     VAR
//         CompanyInformationBuff: Record 79;
//         LocationBuff: Record 14;
//         StateBuff: Record 18547;
//         //  StateBuff: Record 13762;
//         Gstin: Text[15];
//         LglNm: Text[100];
//         TrdNm: Text[100];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[50];
//         Pin: Integer;
//         Stcd: Text[50];
//         Ph: Text[12];
//         Em: Text[100];
//     BEGIN
//         CLEAR(Loc);
//         CLEAR(Pin);
//         CLEAR(Stcd);
//         CLEAR(Ph);
//         CLEAR(Em);
//         IF IsInvoice THEN
//             WITH TransferShipmentHeader DO BEGIN
//                 Gstin := SellerLocation."GSTIN Number";//PBS KK GST
//                 // Gstin := '29AABCT1332L000';//PBS KK GST
//                 CompanyInformationBuff.GET;
//                 TrdNm := CompanyInformationBuff.Name;
//                 LocationBuff.GET("Transfer-to Code");
//                 LglNm := SellerLocation.Name;
//                 Addr1 := SellerLocation.Address;
//                 Addr2 := SellerLocation."Address 2";
//                 Loc := SellerLocation.City;
//                 IF NOT EVALUATE(Pin, COPYSTR(SellerLocation."Post Code", 1, 6)) THEN
//                     ERROR(PinCodeErr, "No.", SellerLocation."Post Code");
//                 StateBuff.GET(SellerLocation."State Code");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                 Ph := COPYSTR(SellerLocation."Phone No.", 1, 12);
//                 Em := COPYSTR(SellerLocation."E-Mail", 1, 100);
//             END;

//         WriteSellerDtls(Gstin, LglNm, TrdNm, Addr1, Addr2, Loc, Pin, Stcd, Ph, Em);
//     END;



//     LOCAL PROCEDURE TransferReadBuyerDtls();
//     VAR
//         Contact: Record 5050;
//         TransferShipmentLine: Record 5745;
//         SalesCrMemoLine: Record 115;
//         ShipToAddr: Record 222;
//         // StateBuff: Record State;
//         Gstin: Text[15];
//         LglNm: Text[100];
//         POS: Text[2];
//         Addr1: Text[100];
//         Addr2: Text[100];
//         Loc: Text[100];
//         Pin: Integer;
//         Stcd: Text[50];
//         Ph: Text[12];
//         Em: Text[100];
//         CountryCodeOfExport: Text[3];
//         StateBuff: Record state;

//     BEGIN
//         CLEAR(POS);
//         CLEAR(Stcd);
//         CLEAR(Ph);
//         CLEAR(Em);
//         IF IsInvoice THEN
//             WITH TransferShipmentHeader DO BEGIN

//                 Gstin := BuyerLocation."GST Registration No.";

//                 // Gstin := '29AABCT1332L000';
//                 LglNm := BuyerLocation.Name;
//                 Addr1 := BuyerLocation.Address;
//                 Addr2 := BuyerLocation."Address 2";
//                 StateBuff.reset;
//                 StateBuff.get(BuyerLocation."State Code");

//                 loc := StateBuff.Description;

//                 IF NOT EVALUATE(Pin, COPYSTR(BuyerLocation."Post Code", 1, 6)) THEN
//                     ERROR(PinCodeErr, "No.", BuyerLocation."Post Code");


//                 StateBuff.RESET;
//                 StateBuff.GET(BuyerLocation."State Code");
//                 POS := FORMAT(StateBuff."State Code (GST Reg. No.)");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";

//                 Ph := COPYSTR(BuyerLocation."Phone No.", 1, 12);
//                 Em := COPYSTR(BuyerLocation."E-Mail", 1, 100);

//             END;

//         WriteBuyerDtls(Gstin, LglNm, POS, Addr1, Addr2, Loc, Pin, Stcd, Ph, Em, CountryCodeOfExport);
//     END;







//     LOCAL PROCEDURE TransferReadItemList();
//     VAR
//         TransferShipmentLine: Record "Transfer Shipment Line";
//         SalesInvoiceLine: Record 113;
//         SalesCrMemoLine: Record 115;
//         AssAmt: Decimal;
//         CgstAmt: Decimal;
//         SgstAmt: Decimal;
//         IgstAmt: Decimal;
//         CesRt: Decimal;
//         CesAmt: Decimal;
//         CesNonAdval: Decimal;
//         StateCesRt: Decimal;
//         StateCesAmt: Decimal;
//         FreeQty: Decimal;
//         StateCesNonAdvlAmt: Decimal;
//         SlNo: Integer;
//         UOM: Text[10];
//         IsServc: Text[1];
//         GSTRt: Decimal;
//         Item: Record Item;
//         OrgCntry: Text;
//         JobjectArray: JsonArray;

//     BEGIN
//         CLEAR(SlNo);
//         IF IsInvoice THEN BEGIN
//             TransferShipmentLine.SETRANGE("Document No.", DocumentNo);

//             TransferShipmentLine.SETFILTER("GST Group Code", '<>%1', '');
//             TransferShipmentLine.SETFILTER("HSN/SAC Code", '<>%1', '');
//             TransferShipmentLine.SETFILTER(Quantity, '<>%1', 0);
//             //TransferShipmentLine.SETFILTER("GST Base Amount", '<>%1', 0);

//             IF TransferShipmentLine.FINDSET THEN BEGIN
//                 IF TransferShipmentLine.COUNT > 1000 THEN
//                     ERROR(SalesLinesErr, SalesInvoiceLine.COUNT);
//                 // JsonTextWriter.WritePropertyName('ItemList');

//                 // JsonTextWriter.WriteStartArray;
//                 REPEAT

//                     SlNo += 1;
//                     // IF SalesInvoiceLine."GST On Assessable Value" THEN //NT
//                     AssAmt := TransferShipmentLine.amount;
//                     // ELSE //NT
//                     // AssAmt := SalesInvoiceLine."vat Base Amount";
//                     // IF SalesInvoiceLine.Amount = 0 THEN
//                     //     FreeQty := SalesInvoiceLine.Quantity
//                     // ELSE
//                     FreeQty := 0;

//                     GetGSTCompRate(
//                       TransferShipmentLine."Document No.",
//                       TransferShipmentLine."Line No.",
//                       GSTRt,
//                       CgstAmt,
//                       SgstAmt,
//                       IgstAmt,
//                       CesRt,
//                       CesAmt,
//                       CesNonAdval,
//                       StateCesRt,
//                       StateCesAmt,
//                       StateCesNonAdvlAmt,
//                       'TRANSFER');
//                     TotalCgstAmt += CgstAmt;
//                     TotalIgstAmt += IgstAmt;
//                     TotalSgstAmt += SgstAmt;
//                     TotalAssAmt += AssAmt;
//                     TotalInvAmt := (TotalInvAmt + TransferShipmentLine.Amount + CgstAmt + IgstAmt + SgstAmt);
//                     CLEAR(UOM);
//                     IF TransferShipmentLine."Unit of Measure Code" <> '' THEN
//                         UOM := COPYSTR(TransferShipmentLine."Unit of Measure Code", 1, 10) //NT
//                                                                                            //        UOM := COPYSTR(SalesInvoiceLine."Unit of Measure Code",1,8) //NT

//                     ELSE
//                         UOM := OTHTxt;
//                     IsServc := 'N';
//                     WriteItem(
//                       TransferShipmentLine.Description + TransferShipmentLine."Description 2",
//                       TransferShipmentLine."HSN/SAC Code",
//                       TransferShipmentLine.Quantity,
//                       FreeQty,
//                       UOM,
//                       TransferShipmentLine."Unit Price",
//                       TransferShipmentLine.Amount,
//                       0,
//                       AssAmt,
//                       GSTRt,
//                       CgstAmt,
//                       SgstAmt,
//                       IgstAmt,
//                       CesRt,
//                       CesAmt,
//                       CesNonAdval,
//                       StateCesRt,
//                       StateCesAmt,
//                       StateCesNonAdvlAmt,
//                       TransferShipmentLine.Amount,
//                     TransferShipmentLine."Line No.",
//                       SlNo,
//                       IsServc);
//                     JobjectArray.Add(jobjectline);
//                 UNTIL TransferShipmentLine.NEXT = 0;
//                 jobject2.Add('ItemList', JobjectArray);
//             END;
//         END;
//     end;

//     procedure TransferReadValDtls();
//     var
//         AssVal: Decimal;
//         CgstVal: Decimal;
//         SgstVal: Decimal;
//         IgstVal: Decimal;
//         CesVal: Decimal;
//         StCesVal: Decimal;
//         Disc: Decimal;
//         OthChrg: Decimal;
//         TotInvVal: Decimal;
//         RndOffAmt: Decimal;
//         TotiInvValFc: Decimal;
//     begin

//         GetGSTVal(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, Disc, OthChrg, TotInvVal, RndOffAmt, TotiInvValFc);
//         TransferWriteValDtls(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, TotInvVal, RndOffAmt, TotiInvValFc, Disc);


//     end;

//     procedure TransferWriteValDtls(AssVal: Decimal; CgstVal: Decimal; SgstVal: Decimal; IgstVal: Decimal; CesVal: Decimal; StCesVal: Decimal; TotInvVal: Decimal; RndOffAmt: Decimal; TotiInvValFc: Decimal; Disc: Decimal);
//     begin

//         VJsonObjectHeader.add('AssVal', TotalAssAmt);
//         VJsonObjectHeader.Add('CgstVal', TotalCgstAmt);
//         VJsonObjectHeader.Add('SgstVal', TotalSgstAmt);
//         VJsonObjectHeader.Add('IgstVal', ROUND(TotalIgstAmt, 0.01, '='));

//         VJsonObjectHeader.Add('CesVal', CesVal);
//         VJsonObjectHeader.Add('StCesVal', StCesVal);
//         VJsonObjectHeader.Add('Discount', Disc);
//         VJsonObjectHeader.Add('RndOffAmt', RndOffAmt);
//         VJsonObjectHeader.Add('TotInvVal', TotalInvAmt + StCesVal + CesVal);

//         VJsonObjectHeader.Add('TotiInvValFc', TotiInvValFc);
//         jobject2.Add('ValDtls', VJsonObjectHeader);

//     end;








//     var
//         myInt: Integer;
//         SaleJson: Text;

//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;

//         GlobalNULL: Variant;

//         UnRegCustErr: TextConst ENU = 'E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.;ENN=E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.';
//         IsInvoice: Boolean;

//         SalesLinesErr: TextConst ENU = 'E-Invoice allowes only 1000 lines per Invoice. Curent transaction is having %1 lines.;ENN=E-Invoice allowes only 1000 lines per Invoice. Curent transaction is having %1 lines.';
//         DocumentNo: Text[20];
//         // OTHTxt: TextConst ENU = 'OTH', ENN = 'OTH';
//         OTHTxt: Label 'OTH';
//         AckNoTxt: TextConst ENU = 'AckNo', ENN = 'AckNo';
//         AckDtTxt: TextConst ENU = 'AckDt', ENN = 'AckDt';
//         IrnTxt: TextConst ENU = 'Irn', ENN = 'Irn';
//         SelectFileTxt: TextConst ENU = 'Select Json Response File.', ENN = 'Select Json Response File.';
//         SignedQRCodeTxt: TextConst ENU = 'SignedQRCode', ENN = 'SignedQRCode';
//         POSForExportTxt: TextConst ENU = '96', ENN = '96';
//         FileFilterTxt: TextConst ENU = '*.JSON|*.json', ENN = '*.JSON|*.json';
//         ImportedMsg: TextConst ENU = 'Total %1 files out of %2 files has been imported.', ENN = 'Total %1 files out of %2 files has been imported.';
//         SelectMultipleFilesTxt: TextConst ENU = 'Select muliple files', ENN = 'Select muliple files';
//         TempDateTime: DateTime;
//         IRNHashErr: TextConst ENU = 'No matched IRN Hash %1 found to update.', ENN = 'No matched IRN Hash %1 found to update.';
//         CurrExRate: Decimal;
//         PinCodeErr: TextConst ENU = 'Value in Pincode should be in Integer, incorrect value in %1 record, Value = %2.',
//              ENN = '"Value in Pincode should be in Integer, incorrect value in %1 record, Value = %2."';
//         MasterGSTApi: Codeunit 50003;
//         Customer: Record 18;
//         Location: Record 14;
//         TotalCgstAmt: Decimal;
//         TotalSgstAmt: Decimal;
//         TotalIgstAmt: Decimal;
//         TotalAssAmt: Decimal;
//         TotalInvAmt: Decimal;
//         TransferShipmentHeader: Record 5744;
//         BuyerLocation: Record 14;
//         SellerLocation: Record 14;

//         PurchCrMemoHdr: Record 124;
//         Vendor: Record 23;
//         VJsonObjectHeader: JsonObject;
//         VJsonObjectLines: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         VJsonArrayLines: JsonArray;
//         jobject2: JsonObject;
//         jobjectline: JsonObject;
//         JobjectArray: JsonArray;
//         isInv: code[10];
//         isCrMemo: code[10];
//         GDocNo: Code[50];

// }