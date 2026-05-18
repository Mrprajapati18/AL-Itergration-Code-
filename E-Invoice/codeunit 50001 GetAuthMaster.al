// codeunit 50001 MasterGst
// {
//     trigger OnRun()
//     begin

//     end;

//     PROCEDURE GenerateAuthenticationAPI(SelectedLoc: Code[20]);
//     var
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VarSessionGen: Text;
//         VarSessionExp: Text;
//         AuthExpTime: DateTime;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record 50030;
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;

//     BEGIN

//         MasterGstApiDetails.Get(SelectedLoc);
//         MasterGstApiDetails.TESTFIELD(MasterGstApiDetails."User Name");
//         MasterGstApiDetails.TESTFIELD(MasterGstApiDetails.Password);

//         if MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST then begin

//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();
//             HttpWebClient.DefaultRequestHeaders.Add('username', MasterGstApiDetails."User Name");
//             HttpWebClient.DefaultRequestHeaders.Add('password', MasterGstApiDetails.Password);
//             HttpWebClient.DefaultRequestHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             HttpWebClient.DefaultRequestHeaders.Add('client_id', MasterGstApiDetails."Client ID");
//             HttpWebClient.DefaultRequestHeaders.Add('client_secret', MasterGstApiDetails."Client Secret");
//             HttpWebClient.DefaultRequestHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");// PBS KK
//             contentHeaders.Add('Content-Type', 'application/json');
//             HttpWebRequest.SetRequestUri(MasterGstApiDetails."Auth-Token Url");
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/authenticate?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'GET';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('Authentication failed');
//             HttpResponse.Content().ReadAs(Result);
//             JObject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);
//             if JToken.AsValue().AsText() = 'Sucess' then begin
//                 JObject.Get('data', JToken);
//                 JObject := JToken.AsObject();
//                 JObject.Get('AuthToken', JToken);
//                 MasterGstApiDetails.Reset;

//                 MasterGstApiDetails.Get(SelectedLoc);
//                 MasterGstApiDetails."Auth-Token" := JToken.AsValue().AsText();
//                 MasterGstApiDetails."Auth-Token Expiration Time" := CURRENTDATETIME;
//                 MasterGstApiDetails."Auth-Token Generation Time" := CURRENTDATETIME;
//                 MasterGstApiDetails."Total No. of Hits" += 1;
//                 MasterGstApiDetails.Modify;
//                 Commit;
//             end ELSE
//                 Error('Authentication failed');

//         end;


//     end;



//     PROCEDURE GenerateAuthenticationAPISameState(SelectedLoc: Code[20]);
//     var
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VarSessionGen: Text;
//         VarSessionExp: Text;
//         AuthExpTime: DateTime;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record 50030;
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;

//     BEGIN

//         MasterGstApiDetails.Get(SelectedLoc);
//         MasterGstApiDetails.TESTFIELD(MasterGstApiDetails."User Name");
//         MasterGstApiDetails.TESTFIELD(MasterGstApiDetails.Password);

//         if MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST then begin
//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();
//             HttpWebClient.DefaultRequestHeaders.Add('username', MasterGstApiDetails."User Name");
//             HttpWebClient.DefaultRequestHeaders.Add('password', MasterGstApiDetails.Password);
//             HttpWebClient.DefaultRequestHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             HttpWebClient.DefaultRequestHeaders.Add('client_id', MasterGstApiDetails."Intrastate Client ID");
//             HttpWebClient.DefaultRequestHeaders.Add('client_secret', MasterGstApiDetails."Intrastate Client Secret");
//             HttpWebClient.DefaultRequestHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");// PBS KK
//             contentHeaders.Add('Content-Type', 'application/json');
//             // HttpWebRequest.SetRequestUri(MasterGstApiDetails."Auth-Token Url");
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/authenticate?email=manish%40pristinebs.com');
//             HttpWebRequest.SetRequestUri('https://apisandbox.whitebooks.in/ewaybillapi/v1.03/authenticate?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'GET';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('Authentication failed');
//             HttpResponse.Content().ReadAs(Result);
//             JObject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);
//             if JToken.AsValue().AsText() = 'Sucess' then begin
//                 JObject.Get('data', JToken);
//                 JObject := JToken.AsObject();
//                 JObject.Get('AuthToken', JToken);
//                 MasterGstApiDetails.Reset;

//                 MasterGstApiDetails.Get(SelectedLoc);
//                 MasterGstApiDetails."Auth-Token" := JToken.AsValue().AsText();
//                 MasterGstApiDetails."Auth-Token Expiration Time" := CURRENTDATETIME;
//                 MasterGstApiDetails."Auth-Token Generation Time" := CURRENTDATETIME;
//                 MasterGstApiDetails."Total No. of Hits" += 1;
//                 MasterGstApiDetails.Modify;
//                 Commit;
//             end ELSE
//                 Error('Authentication failed');

//         end;


//     end;

//     PROCEDURE GenerateEinvoice(DocNo: Code[20]; DocType: Option " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return");
//     VAR
//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;
//         RecRef: RecordRef;
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         // FormUrlEncodedContent: DotNet FormUrlEncodedContent;
//         // Class1: DotNet Class1;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         // HttpWebClient: HttpClient;
//         // HttpResponse: HttpResponseMessage;
//         //// Content: HttpContent;
//         // Result, Output : Text;
//         // AuthExpTime: DateTime;
//         VJsonArrayLines: JsonArray;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record 50030;
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         jobject2: JsonObject;
//         CU50017: Codeunit 50000;
//         payload: Text;
//         // myBlob: Record MyTempBlob;
//         NVInStream: InStream;
//         Outstr: OutStream;
//         VarAckDate: DateTime;
//         FieldRef: FieldRef;
//         QRCodeInput: Text;
//         QRCodeFileName: Text;
//         TempBlob: Codeunit 4100;

//         //NVInStream: InStream;

//         UploadResult: Boolean;
//         NVOutStream: OutStream;
//         //OStream :=crea

//         //PBS KK QR Code
//         QRGenerator: Codeunit "QR Generator";
//         Temp_Blob: Codeunit "Temp Blob";
//         Record_Ref: RecordRef;
//         Field_Ref: FieldRef;
//     //PBS KK QR Code
//     BEGIN

//         EInvoiceEWayBillMaster.RESET;
//         EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//         EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//         EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//         EInvoiceEWayBillMaster.FINDFIRST;

//         MasterGstApiDetails.GET(EInvoiceEWayBillMaster."Location Code");
//         GenerateAuthenticationAPI(EInvoiceEWayBillMaster."Location Code");

//         if EInvoiceEWayBillMaster."Document Type" = EInvoiceEWayBillMaster."Document Type"::"Sales Invoice" then
//             payload := CU50017.ExportInvoice('INV', DocNo);
//         if EInvoiceEWayBillMaster."Document Type" = EInvoiceEWayBillMaster."Document Type"::"Sales Cr.Memo" then
//             payload := CU50017.ExportCrMemo('CRMEMO', DocNo);
//         if EInvoiceEWayBillMaster."Document Type" = EInvoiceEWayBillMaster."Document Type"::Transfer then
//             payload := CU50017.TransferExportInvoice('TRANS', DocNo);
//         if EInvoiceEWayBillMaster."Document Type" = EInvoiceEWayBillMaster."Document Type"::"Purchase Return" then      //BKS_Added_GSTReport
//             payload := CU50017.ExportPurchaseCrMemo('INV', DocNo);



//         IF MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST THEN BEGIN

//             Content.WriteFrom(payload);
//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();

//             ContentHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             ContentHeaders.Add('client_id', MasterGstApiDetails."Client ID");
//             ContentHeaders.Add('client_secret', MasterGstApiDetails."Client Secret");
//             ContentHeaders.Add('username', MasterGstApiDetails."User Name");
//             ContentHeaders.Add('auth-token', MasterGstApiDetails."Auth-Token");
//             ContentHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");//PBS KK GST
//             contentHeaders.Add('Content-Type', 'application/json');
//             HttpWebRequest.Content := Content;
//             HttpWebRequest.SetRequestUri(MasterGstApiDetails."E-Invoice Url");
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/type/GENERATE/version/V1_03?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'POST';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('E-invocie Generation failed in Acto');
//             HttpResponse.Content().ReadAs(Result);

//             JObject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);
//             if JToken.AsValue().AsText() = '1' then begin
//                 JObject.Get('data', JToken);
//                 JObject := JToken.AsObject();
//                 EInvoiceEWayBillMaster.RESET;
//                 EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Total No. of Hits Counter" += 1;
//                 JObject.Get('AckNo', JToken);
//                 EInvoiceEWayBillMaster."Acknowledgement No." := JToken.AsValue().AsText();
//                 JObject.Get('AckDt', JToken);
//                 EInvoiceEWayBillMaster."Acknowledgement DT" := JToken.AsValue().AsText();
//                 Evaluate(VarAckDate, JToken.AsValue().AsText());
//                 EInvoiceEWayBillMaster."Acknowledgement Date" := VarAckDate;
//                 JObject.Get('Irn', JToken);
//                 EInvoiceEWayBillMaster."IRN Hash" := JToken.AsValue().AsText();
//                 JObject.Get('SignedQRCode', JToken);
//                 EInvoiceEWayBillMaster."E-invoice QR Code" := JToken.AsValue().AsText();
//                 EInvoiceEWayBillMaster."Response Description" := 'GST Request Successful';//JToken.AsValue().AsText();
//                 EInvoiceEWayBillMaster.IsJSONImported := true;



//                 EInvoiceEWayBillMaster.Modify;

//                 // PBS KK 08-04-2024
//                 Clear(Record_Ref);
//                 Record_Ref.Get(EInvoiceEWayBillMaster.RecordId);
//                 if QRGenerator.GenerateQRCodeImage(EInvoiceEWayBillMaster."E-invoice QR Code", TempBlob) then begin
//                     if TempBlob.HasValue() then begin
//                         TempBlob.ToRecordRef(Record_Ref, EInvoiceEWayBillMaster.FieldNo("QR Code"));
//                         Record_Ref.Modify();
//                     end;
//                 end;
//                 Commit;

//             END ELSE BEGIN
//                 EInvoiceEWayBillMaster.RESET;
//                 EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//                 JObject.Get('status_desc', JToken);
//                 IF STRLEN(JToken.AsValue().AsText()) > 250 THEN
//                     EInvoiceEWayBillMaster."Response Description" := DELSTR(JToken.AsValue().AsText(), 250)
//                 ELSE
//                     EInvoiceEWayBillMaster."Response Description" := JToken.AsValue().AsText();

//                 EInvoiceEWayBillMaster.Modify;
//                 MESSAGE('unable to generate Einvoice');
//             END;

//         end;
//     end;

//     PROCEDURE GenerateEWayBill(DocNo: Code[20]; DocType: option " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return");
//     VAR
//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;
//         RecRef: RecordRef;
//         Var_DistanceInInt32: Integer;
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         //  FormUrlEncodedContent: DotNet FormUrlEncodedContent;
//         // Class1: DotNet Class1;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VJsonArrayLines: JsonArray;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record 50030;
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         jobject2: JsonObject;
//         EwaybillReq: text;
//         VarEwayBillDate: DateTime;
//         VarEwayBillValiddata: DateTime;
//         SalesInvoiceHeader2: Record "Sales Invoice Header";
//         SalesInvoiceLine2: Record "Sales Invoice Line";
//         SalesShipmentHdr: Record "Sales Shipment Header";
//         VartotalValue: Decimal;
//         VarcgstValue: Decimal;
//         VarsgstValue: Decimal;
//         VarigstValue: Decimal;
//         VarcessValue: Decimal;
//         VarcessNonAdvolValue: Decimal;
//         Dt: Text;
//         //PBS Punit QR Code
//         QRGenerator: Codeunit "QR Generator";
//         Temp_Blob: Codeunit "Temp Blob";
//         Record_Ref: RecordRef;
//         Field_Ref: FieldRef;
//         QRCodeStringforqrcode: Text;
//     //PBS Punit QR Code
//     BEGIN
//         EInvoiceEWayBillMaster.RESET;
//         EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//         EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//         EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//         EInvoiceEWayBillMaster.FINDFIRST;

//         GenerateAuthenticationAPI(EInvoiceEWayBillMaster."Location Code");
//         MasterGstApiDetails.GET(EInvoiceEWayBillMaster."Location Code");

//         IF MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST THEN BEGIN
//             VJsonObjectHeader.Add('Irn', EInvoiceEWayBillMaster."IRN Hash");
//             // SalesInvoiceHeader2.get(EInvoiceEWayBillMaster."Document No.");
//             // if SalesInvoiceHeader2."Document Sub Type" = SalesInvoiceHeader2."Document Sub Type"::"Job Worker" then begin

//             //     VJsonObjectHeader.Add('supplyType', 'O');
//             //     VJsonObjectHeader.Add('subSupplyType', '4');
//             //     VJsonObjectHeader.Add('subSupplyDesc', '');
//             //     VJsonObjectHeader.Add('docType', 'CHL');

//             //     SalesShipmentHdr.Reset();
//             //     SalesShipmentHdr.SetRange("Order No.", SalesInvoiceHeader2."Order No.");
//             //     if SalesShipmentHdr.FindFirst() then begin
//             //         VJsonObjectHeader.Add('docNo', SalesShipmentHdr."No.");
//             //         Dt := FORMAT(SalesShipmentHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             //         VJsonObjectHeader.Add('docDate', Dt);
//             //     end;

//             //     SalesInvoiceLine2.Reset();
//             //     SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader2."No.");
//             //     if SalesInvoiceLine2.FindSet() then begin
//             //         repeat
//             //             VartotalValue += SalesInvoiceLine2."Expected Cost";
//             //         until SalesInvoiceLine2.Next() = 0;
//             //     end;
//             //     VJsonObjectHeader.Add('totalValue', VartotalValue);
//             //     VJsonObjectHeader.Add('totInvValue', VartotalValue);
//             //     Evaluate(VarcgstValue, '0');
//             //     VJsonObjectHeader.Add('cgstValue', VarcgstValue);
//             //     Evaluate(VarsgstValue, '0');
//             //     VJsonObjectHeader.Add('sgstValue', VarsgstValue);
//             //     Evaluate(VarigstValue, '0');
//             //     VJsonObjectHeader.Add('igstValue', VarigstValue);
//             //     Evaluate(VarcessValue, '0');
//             //     VJsonObjectHeader.Add('cessValue', VarcessValue);
//             //     Evaluate(VarcessNonAdvolValue, '0');
//             //     VJsonObjectHeader.Add('cessNonAdvolValue', VarcessNonAdvolValue);
//             //     VJsonObjectHeader.Add('subSupplyType', '4');
//             // end;


//             VJsonObjectHeader.Add('Distance', EInvoiceEWayBillMaster."Distance (Km)");
//             VJsonObjectHeader.Add('TransMode', EInvoiceEWayBillMaster."Transport Method");
//             if EInvoiceEWayBillMaster."Transporter Id" <> '' then begin
//                 VJsonObjectHeader.Add('TransId', EInvoiceEWayBillMaster."Transporter Id"); //EInvoiceEWayBillMaster."Transporter GST Reg. No." GSTIN
//                 VJsonObjectHeader.Add('TransName', COPYSTR(EInvoiceEWayBillMaster."Transporter Name", 1, 30));
//                 VJsonObjectHeader.Add('TransDocDt', FORMAT(EInvoiceEWayBillMaster."Transport Document Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//                 VJsonObjectHeader.Add('TransDocNo', EInvoiceEWayBillMaster."Transport Document No.");
//             end;
//             IF EInvoiceEWayBillMaster."Transport Method" = '1' THEN BEGIN
//                 VJsonObjectHeader.Add('VehNo', EInvoiceEWayBillMaster."Vehicle No.");
//                 VJsonObjectHeader.Add('VehType', COPYSTR(FORMAT(EInvoiceEWayBillMaster."Vehicle Type"), 1, 1));
//             END;
//             VJsonObjectHeader.WriteTo(VJsonText);
//             MESSAGE('%1', VJsonText);

//             Content.WriteFrom(VJsonText);
//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();
//             contentHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             contentHeaders.Add('client_id', MasterGstApiDetails."Client ID");
//             contentHeaders.Add('client_secret', MasterGstApiDetails."Client Secret");
//             contentHeaders.Add('username', MasterGstApiDetails."User Name");
//             contentHeaders.Add('auth-token', MasterGstApiDetails."Auth-Token");
//             contentHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");
//             contentHeaders.Add('Content-Type', 'application/json');
//             HttpWebRequest.Content := Content;
//             HttpWebRequest.SetRequestUri(MasterGstApiDetails."Interstate E-Way Bill Url");
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/type/GENERATE_EWAYBILL/version/V1_03?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'POST';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('unable to Generate Eway bill');
//             HttpResponse.Content().ReadAs(Result);

//             Message('Response- %1', Result);
//             jobject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);
//             IF JToken.AsValue().AsText() = '1' THEN BEGIN
//                 JObject.Get('data', JToken);
//                 JObject := JToken.AsObject();
//                 EInvoiceEWayBillMaster.RESET;
//                 EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Total No. of Hits Counter" += 1;
//                 JObject.Get('EwbNo', JToken);
//                 EInvoiceEWayBillMaster."E-Way Bill No." := JToken.AsValue().AsText();
//                 JObject.Get('EwbDt', JToken);
//                 Evaluate(VarEwayBillDate, JToken.AsValue().AsText());
//                 EInvoiceEWayBillMaster."E-Way Bill Date" := VarEwayBillDate;
//                 JObject.Get('EwbValidTill', JToken);
//                 Evaluate(VarEwayBillValiddata, JToken.AsValue().AsText());
//                 EInvoiceEWayBillMaster."E-Way Bill Valid Till" := VarEwayBillValiddata;
//                 EInvoiceEWayBillMaster."Request Description" := VJsonText;
//                 EInvoiceEWayBillMaster.Modify;
//                 // SalesInvoiceHeader.Reset();
//                 // If SalesInvoiceHeader.Get(EInvoiceEWayBillMaster."Document No.") then;
//                 // QRCodeStringforqrcode := Format(EInvoiceEWayBillMaster."E-Way Bill No.") + '/' + format(SalesInvoiceHeader."Location GST Reg. No.") + '/' + Format(EInvoiceEWayBillMaster."E-Way Bill Date");


//                 // // PBS Varsha ++
//                 // Clear(Record_Ref);
//                 // Record_Ref.Get(EInvoiceEWayBillMaster.RecordId);
//                 // if QRGenerator.GenerateQRCodeImage(QRCodeStringforqrcode, Temp_Blob) then begin
//                 //     if Temp_Blob.HasValue() then begin
//                 //         Temp_Blob.ToRecordRef(Record_Ref, EInvoiceEWayBillMaster.FieldNo("E-Way QR Code"));
//                 //         Record_Ref.Modify();
//                 //     end;
//                 // end;
//                 // // PBS Varsha 
//                 // Commit;
//                 MESSAGE('E-Way Bill Generated Successfully.');
//             END ELSE BEGIN
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//                 JObject.Get('status_desc', JToken);
//                 EInvoiceEWayBillMaster."Response Description" := DELSTR(JToken.AsValue().AsText(), 250);
//                 EInvoiceEWayBillMaster."Request Description" := VJsonText;
//                 EInvoiceEWayBillMaster.Modify;
//                 Commit;
//                 MESSAGE('Unable to Generate E-Way Bill. Please try again.');
//             END;
//         END;
//         //         EInvoiceEWayBillMaster.MODIFY(TRUE);
//     END;




//     PROCEDURE GenerateEWayBillSameLocation(DocNo: Code[20]; DocType: option " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return");
//     VAR
//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;
//         RecRef: RecordRef;
//         Var_DistanceInInt32: Integer;
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         //  FormUrlEncodedContent: DotNet FormUrlEncodedContent;
//         // Class1: DotNet Class1;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VJsonArrayLines: JsonArray;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record 50030;
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         jobject2: JsonObject;
//         EwaybillReq: text;
//         VarEwayBillDate: DateTime;
//         VarEwayBillValiddata: DateTime;
//         SalesInvoiceHeader2: Record "Sales Invoice Header";
//         SalesInvoiceLine2: Record "Sales Invoice Line";
//         SalesShipmentHdr: Record "Sales Shipment Header";
//         VartotalValue: Decimal;
//         VarcgstValue: Decimal;
//         VarsgstValue: Decimal;
//         VarigstValue: Decimal;
//         VarcessValue: Decimal;
//         VarcessNonAdvolValue: Decimal;
//         Dt: Text;
//         //PBS Punit QR Code
//         QRGenerator: Codeunit "QR Generator";
//         Temp_Blob: Codeunit "Temp Blob";
//         Record_Ref: RecordRef;
//         Field_Ref: FieldRef;
//         QRCodeStringforqrcode: Text;
//     //PBS Punit QR Code
//     BEGIN
//         EInvoiceEWayBillMaster.RESET;
//         EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//         EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//         EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//         EInvoiceEWayBillMaster.FINDFIRST;

//         //GenerateAuthenticationAPI(EInvoiceEWayBillMaster."Location Code");

//         MasterGstApiDetails.GET(EInvoiceEWayBillMaster."Location Code");

//         IF MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST THEN BEGIN
//             VJsonObjectHeader.Add('Irn', EInvoiceEWayBillMaster."IRN Hash");
//             // SalesInvoiceHeader2.get(EInvoiceEWayBillMaster."Document No.");
//             // if SalesInvoiceHeader2."Document Sub Type" = SalesInvoiceHeader2."Document Sub Type"::"Job Worker" then begin

//             //     VJsonObjectHeader.Add('supplyType', 'O');
//             //     VJsonObjectHeader.Add('subSupplyType', '4');
//             //     VJsonObjectHeader.Add('subSupplyDesc', '');
//             //     VJsonObjectHeader.Add('docType', 'CHL');

//             //     SalesShipmentHdr.Reset();
//             //     SalesShipmentHdr.SetRange("Order No.", SalesInvoiceHeader2."Order No.");
//             //     if SalesShipmentHdr.FindFirst() then begin
//             //         VJsonObjectHeader.Add('docNo', SalesShipmentHdr."No.");
//             //         Dt := FORMAT(SalesShipmentHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             //         VJsonObjectHeader.Add('docDate', Dt);
//             //     end;

//             //     SalesInvoiceLine2.Reset();
//             //     SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader2."No.");
//             //     if SalesInvoiceLine2.FindSet() then begin
//             //         repeat
//             //             VartotalValue += SalesInvoiceLine2."Expected Cost";
//             //         until SalesInvoiceLine2.Next() = 0;
//             //     end;
//             //     VJsonObjectHeader.Add('totalValue', VartotalValue);
//             //     VJsonObjectHeader.Add('totInvValue', VartotalValue);
//             //     Evaluate(VarcgstValue, '0');
//             //     VJsonObjectHeader.Add('cgstValue', VarcgstValue);
//             //     Evaluate(VarsgstValue, '0');
//             //     VJsonObjectHeader.Add('sgstValue', VarsgstValue);
//             //     Evaluate(VarigstValue, '0');
//             //     VJsonObjectHeader.Add('igstValue', VarigstValue);
//             //     Evaluate(VarcessValue, '0');
//             //     VJsonObjectHeader.Add('cessValue', VarcessValue);
//             //     Evaluate(VarcessNonAdvolValue, '0');
//             //     VJsonObjectHeader.Add('cessNonAdvolValue', VarcessNonAdvolValue);
//             //     VJsonObjectHeader.Add('subSupplyType', '4');
//             // end;


//             VJsonObjectHeader.Add('Distance', EInvoiceEWayBillMaster."Distance (Km)");
//             VJsonObjectHeader.Add('TransMode', EInvoiceEWayBillMaster."Transport Method");
//             if EInvoiceEWayBillMaster."Transporter Id" <> '' then begin
//                 VJsonObjectHeader.Add('TransId', EInvoiceEWayBillMaster."Transporter Id"); //EInvoiceEWayBillMaster."Transporter GST Reg. No." GSTIN
//                 VJsonObjectHeader.Add('TransName', COPYSTR(EInvoiceEWayBillMaster."Transporter Name", 1, 30));
//                 VJsonObjectHeader.Add('TransDocDt', FORMAT(EInvoiceEWayBillMaster."Transport Document Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//                 VJsonObjectHeader.Add('TransDocNo', EInvoiceEWayBillMaster."Transport Document No.");
//             end;
//             IF EInvoiceEWayBillMaster."Transport Method" = '1' THEN BEGIN
//                 VJsonObjectHeader.Add('VehNo', EInvoiceEWayBillMaster."Vehicle No.");
//                 VJsonObjectHeader.Add('VehType', COPYSTR(FORMAT(EInvoiceEWayBillMaster."Vehicle Type"), 1, 1));
//             END;
//             VJsonObjectHeader.WriteTo(VJsonText);
//             MESSAGE('%1', VJsonText);

//             Content.WriteFrom(VJsonText);
//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();
//             contentHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             contentHeaders.Add('client_id', MasterGstApiDetails."Intrastate Client ID");
//             contentHeaders.Add('client_secret', MasterGstApiDetails."Intrastate Client Secret");
//             contentHeaders.Add('username', MasterGstApiDetails."User Name");
//             contentHeaders.Add('auth-token', MasterGstApiDetails."Auth-Token");
//             contentHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");
//             contentHeaders.Add('Content-Type', 'application/json');
//             HttpWebRequest.Content := Content;
//             HttpWebRequest.SetRequestUri(MasterGstApiDetails."Intrastate E-Way Bill Url");
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/type/GENERATE_EWAYBILL/version/V1_03?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'POST';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('unable to Generate Eway bill');
//             HttpResponse.Content().ReadAs(Result);

//             Message('Response- %1', Result);
//             jobject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);
//             IF JToken.AsValue().AsText() = '1' THEN BEGIN
//                 JObject.Get('data', JToken);
//                 JObject := JToken.AsObject();
//                 EInvoiceEWayBillMaster.RESET;
//                 EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Total No. of Hits Counter" += 1;
//                 JObject.Get('EwbNo', JToken);
//                 EInvoiceEWayBillMaster."E-Way Bill No." := JToken.AsValue().AsText();
//                 JObject.Get('EwbDt', JToken);
//                 Evaluate(VarEwayBillDate, JToken.AsValue().AsText());
//                 EInvoiceEWayBillMaster."E-Way Bill Date" := VarEwayBillDate;
//                 JObject.Get('EwbValidTill', JToken);
//                 Evaluate(VarEwayBillValiddata, JToken.AsValue().AsText());
//                 EInvoiceEWayBillMaster."E-Way Bill Valid Till" := VarEwayBillValiddata;
//                 EInvoiceEWayBillMaster."Request Description" := VJsonText;
//                 EInvoiceEWayBillMaster.Modify;
//                 // SalesInvoiceHeader.Reset();
//                 // If SalesInvoiceHeader.Get(EInvoiceEWayBillMaster."Document No.") then;
//                 // QRCodeStringforqrcode := Format(EInvoiceEWayBillMaster."E-Way Bill No.") + '/' + format(SalesInvoiceHeader."Location GST Reg. No.") + '/' + Format(EInvoiceEWayBillMaster."E-Way Bill Date");


//                 // // PBS Varsha ++
//                 // Clear(Record_Ref);
//                 // Record_Ref.Get(EInvoiceEWayBillMaster.RecordId);
//                 // if QRGenerator.GenerateQRCodeImage(QRCodeStringforqrcode, Temp_Blob) then begin
//                 //     if Temp_Blob.HasValue() then begin
//                 //         Temp_Blob.ToRecordRef(Record_Ref, EInvoiceEWayBillMaster.FieldNo("E-Way QR Code"));
//                 //         Record_Ref.Modify();
//                 //     end;
//                 // end;
//                 // // PBS Varsha 
//                 // Commit;
//                 MESSAGE('E-Way Bill Generated Successfully.');
//             END ELSE BEGIN
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//                 JObject.Get('status_desc', JToken);
//                 EInvoiceEWayBillMaster."Response Description" := DELSTR(JToken.AsValue().AsText(), 250);
//                 EInvoiceEWayBillMaster."Request Description" := VJsonText;
//                 EInvoiceEWayBillMaster.Modify;
//                 Commit;
//                 MESSAGE('Unable to Generate E-Way Bill. Please try again.');
//             END;
//         END;
//         //         EInvoiceEWayBillMaster.MODIFY(TRUE);
//     END;




//     //PBS KK 01022023





























//     PROCEDURE GenerateEWayBillForSameState(DocNo: Code[20]; DocType: option " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return");
//     VAR
//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;
//         RecRef: RecordRef;
//         Var_DistanceInInt32: Integer;
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VJsonArrayLines: JsonArray;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record "E-Invoice & E-Way Bill Master";
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         jobject2: JsonObject;
//         EwaybillReq: text;
//         VarEwayBillDate: DateTime;
//         VarEwayBillValiddata: DateTime;
//         JArray: JsonArray;
//         JObjectLines: JsonObject;

//         // Rec_Transfer_Header: Record "Transfer Header";
//         // TransferLineRec: Record "Transfer Line";


//         Rec_Transfer_Header: Record "Transfer Shipment Header";
//         TransferLineRec: Record "Transfer Shipment Line";
//         VaractFromStateCode: Integer;
//         VarfromPincode: Integer;
//         VarfromStateCode: Integer;
//         VartoPincode: Integer;
//         VaractToStateCode: Integer;
//         VartoStateCode: Integer;
//         VartransactionType: Integer;
//         VartotalValue: Decimal;
//         VarcgstValue: Decimal;
//         VarsgstValue: Decimal;
//         VarigstValue: Decimal;
//         varcessValue: Decimal;
//         varcessNonAdvolValue: Decimal;
//         vartotInvValue: Decimal;
//         VarhsnCode: Integer;
//         Varquantity: Decimal;
//         VartaxableAmount: Decimal;
//         VarsgstRate: Integer;
//         VarcgstRate: Integer;
//         VarigstRate: Integer;
//         VarcessRate: Integer;

//         RecLocation: Record Location;

//         RecLocation2: Record Location;
//         RecState: Record State;
//         RecItem: Record Item;
//         Dt: Text[10];
//         TransferShipment: Record "Transfer Shipment Line";

//     BEGIN
//         EInvoiceEWayBillMaster.RESET;
//         EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//         EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//         EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//         EInvoiceEWayBillMaster.FINDFIRST;

//         //GenerateAuthenticationAPIForSameState(EInvoiceEWayBillMaster."Location Code");
//         //GenerateAuthenticationAPISameState(EInvoiceEWayBillMaster."Location Code");

//         MasterGstApiDetails.GET(EInvoiceEWayBillMaster."Location Code");

//         IF MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST THEN BEGIN

//             Clear(VJsonObjectHeader);

//             Rec_Transfer_Header.Reset();
//             Rec_Transfer_Header.SetRange("No.", DocNo);
//             if Rec_Transfer_Header.FindFirst() then begin

//                 VJsonObjectHeader.Add('supplyType', 'O');
//                 VJsonObjectHeader.Add('subSupplyType', '5');
//                 VJsonObjectHeader.Add('subSupplyDesc', '');
//                 VJsonObjectHeader.Add('docType', 'CHL');
//                 VJsonObjectHeader.Add('docNo', Rec_Transfer_Header."No.");
//                 Dt := FORMAT(Rec_Transfer_Header."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 VJsonObjectHeader.Add('docDate', Dt);
//                 RecLocation.Reset();
//                 RecLocation.SetRange(Code, Rec_Transfer_Header."Transfer-from Code");
//                 if RecLocation.FindFirst() then begin
//                     VJsonObjectHeader.Add('fromGstin', RecLocation."GST Registration No.");
//                     VJsonObjectHeader.Add('fromTrdName', RecLocation.Name);
//                     VJsonObjectHeader.Add('fromAddr1', RecLocation.Address);
//                     VJsonObjectHeader.Add('fromAddr2', RecLocation."Address 2");
//                     VJsonObjectHeader.Add('fromPlace', RecLocation.City);

//                     RecState.Reset();
//                     RecState.Get(RecLocation."State Code");
//                     Evaluate(VaractFromStateCode, RecState."State Code (GST Reg. No.)");
//                     VJsonObjectHeader.Add('actFromStateCode', VaractFromStateCode);
//                     Evaluate(VarfromPincode, RecLocation."Post Code");
//                     VJsonObjectHeader.Add('fromPincode', VarfromPincode);
//                     // Evaluate(VarfromStateCode, '5');
//                     VJsonObjectHeader.Add('fromStateCode', VaractFromStateCode);
//                     VJsonObjectHeader.Add('dispatchFromGSTIN', RecLocation."GST Registration No.");
//                     VJsonObjectHeader.Add('dispatchFromTradeName', RecLocation.Name);
//                 end;

//                 RecLocation2.Reset();
//                 RecLocation2.SetRange(Code, Rec_Transfer_Header."Transfer-to Code");
//                 if RecLocation2.FindFirst() then begin
//                     VJsonObjectHeader.Add('toGstin', RecLocation2."GST Registration No.");
//                     VJsonObjectHeader.Add('toTrdName', RecLocation2.Name);
//                     VJsonObjectHeader.Add('toAddr1', RecLocation2.Address);
//                     VJsonObjectHeader.Add('toAddr2', RecLocation2."Address 2");
//                     VJsonObjectHeader.Add('toPlace', RecLocation2.City);
//                     Evaluate(VartoPincode, RecLocation2."Post Code");
//                     VJsonObjectHeader.Add('toPincode', VartoPincode);
//                     RecState.Reset();
//                     RecState.Get(RecLocation2."State Code");
//                     Evaluate(VaractToStateCode, RecState."State Code (GST Reg. No.)");
//                     VJsonObjectHeader.Add('actToStateCode', VaractToStateCode);

//                     RecState.Reset();
//                     RecState.Get(RecLocation2."State Code");
//                     Evaluate(VartoStateCode, RecState."State Code (GST Reg. No.)");
//                     VJsonObjectHeader.Add('toStateCode', VartoStateCode);
//                 end;

//                 Evaluate(VartransactionType, '4');
//                 VJsonObjectHeader.Add('transactionType', VartransactionType);

//                 // VJsonObjectHeader.Add('dispatchFromGSTIN', '05AAACH6886N1Z0');
//                 // VJsonObjectHeader.Add('dispatchFromTradeName', 'ABC Traders');
//                 // VJsonObjectHeader.Add('shipToGSTIN', ''); //PBS KK
//                 // VJsonObjectHeader.Add('shipToTradeName', '');

//                 Clear(VartotalValue);
//                 TransferShipment.Reset();
//                 TransferShipment.SetRange("Document No.", DocNo);
//                 if TransferShipment.FindSet() then begin
//                     repeat
//                         VartotalValue += TransferShipment.Amount;
//                     until TransferShipment.Next() = 0;
//                 end;
//                 VJsonObjectHeader.Add('totalValue', VartotalValue);
//                 VJsonObjectHeader.Add('totInvValue', VartotalValue);
//                 Evaluate(VarcgstValue, '0');
//                 VJsonObjectHeader.Add('cgstValue', VarcgstValue);
//                 Evaluate(VarsgstValue, '0');
//                 VJsonObjectHeader.Add('sgstValue', VarsgstValue);
//                 Evaluate(VarigstValue, '0');
//                 VJsonObjectHeader.Add('igstValue', VarigstValue);
//                 Evaluate(VarcessValue, '0');
//                 VJsonObjectHeader.Add('cessValue', VarcessValue);
//                 Evaluate(VarcessNonAdvolValue, '0');
//                 VJsonObjectHeader.Add('cessNonAdvolValue', VarcessNonAdvolValue);

//                 VJsonObjectHeader.Add('transMode', EInvoiceEWayBillMaster."Transport Method");

//                 VJsonObjectHeader.Add('transDistance', Format(EInvoiceEWayBillMaster."Distance (Km)"));

//                 VJsonObjectHeader.Add('transporterName', COPYSTR(EInvoiceEWayBillMaster."Transporter Name", 1, 30));

//                 if EInvoiceEWayBillMaster."Transporter Id" <> '' then
//                     VJsonObjectHeader.Add('transporterId', EInvoiceEWayBillMaster."Transporter Id");

//                 VJsonObjectHeader.Add('transDocNo', EInvoiceEWayBillMaster."Transport Document No.");
//                 VJsonObjectHeader.Add('transDocDate', FORMAT(EInvoiceEWayBillMaster."Transport Document Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//                 IF EInvoiceEWayBillMaster."Transport Method" = '1' THEN BEGIN
//                     VJsonObjectHeader.Add('vehicleNo', EInvoiceEWayBillMaster."Vehicle No.");
//                     VJsonObjectHeader.Add('vehicleType', COPYSTR(FORMAT(EInvoiceEWayBillMaster."Vehicle Type"), 1, 1));
//                 end;

//                 Clear(JArray);
//                 Clear(JObjectLines);


//                 TransferLineRec.reset;
//                 TransferLineRec.SetRange("Document No.", DocNo);
//                 TransferLineRec.find('-');
//                 repeat
//                     JArray.Add(JObjectLines);
//                     JObjectLines.Add('productName', TransferLineRec."Item No.");
//                     JObjectLines.Add('productDesc', TransferLineRec.Description);
//                     RecItem.Reset();
//                     RecItem.Get(TransferLineRec."Item No.");
//                     // if RecItem."HSN/SAC Code" <> '' then
//                     //     Evaluate(VarhsnCode, RecItem."HSN/SAC Code");
//                     Evaluate(VarhsnCode, TransferLineRec."HSN/SAC Code");
//                     if VarhsnCode = 20052020 then VarhsnCode := 20052000;
//                     if VarhsnCode = 17049040 then VarhsnCode := 170490;
//                     if VarhsnCode = 95030099 then VarhsnCode := 9503;
//                     if VarhsnCode = 21060000 then VarhsnCode := 21069060;
//                     if VarhsnCode = 63049000 then VarhsnCode := 63049190;
//                     if VarhsnCode = 39269090 then VarhsnCode := 3926;
//                     if VarhsnCode = 940410 then VarhsnCode := 94041000;
//                     if VarhsnCode = 74199939 then VarhsnCode := 7419;
//                     if VarhsnCode = 711700 then VarhsnCode := 7117;
//                     if VarhsnCode = 210300 then VarhsnCode := 21031000;
//                     JObjectLines.Add('hsnCode', VarhsnCode);
//                     JObjectLines.Add('quantity', TransferLineRec."Quantity");

//                     JObjectLines.Add('qtyUnit', 'OTH');
//                     JObjectLines.Add('taxableAmount', TransferLineRec.Amount);
//                     Evaluate(VarsgstRate, '0');
//                     JObjectLines.Add('sgstRate', VarsgstRate);
//                     Evaluate(varcgstRate, '0');
//                     JObjectLines.Add('cgstRate', varcgstRate);
//                     Evaluate(VarigstRate, '0');
//                     JObjectLines.Add('igstRate', VarigstRate);
//                     Evaluate(VarcessRate, '0');
//                     JObjectLines.Add('cessRate', VarcessRate);
//                     Clear(JObjectLines);
//                 until TransferLineRec.next = 0;
//                 VJsonObjectHeader.Add('itemList', JArray);

//             end;
//             Clear(JArray);


//             VJsonObjectHeader.WriteTo(VJsonText);

//             MESSAGE(VJsonText);


//             Content.WriteFrom(VJsonText);
//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();
//             contentHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             contentHeaders.Add('client_id', MasterGstApiDetails."Intrastate Client ID");
//             contentHeaders.Add('client_secret', MasterGstApiDetails."Intrastate Client Secret");
//             contentHeaders.Add('username', MasterGstApiDetails."User Name");
//             //  contentHeaders.Add('auth-token', MasterGstApiDetails."Auth-Token");

//             contentHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");
//             contentHeaders.Add('Content-Type', 'application/json');
//             HttpWebRequest.Content := Content;
//             HttpWebRequest.SetRequestUri(MasterGstApiDetails."Intrastate E-Way Bill Url");
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/type/GENERATE_EWAYBILL/version/V1_03?email=manish%40pristinebs.com');
//             // HttpWebRequest.SetRequestUri('https://api.mastergst.com/ewaybillapi/v1.03/ewayapi/genewaybill?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'POST';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('unable to Generate Eway bill');

//             Message(Format(HttpResponse));
//             HttpResponse.Content().ReadAs(Result);
//             Message(Result);

//             jobject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);
//             IF JToken.AsValue().AsText() = '1' THEN BEGIN
//                 JObject.Get('data', JToken);
//                 JObject := JToken.AsObject();
//                 EInvoiceEWayBillMaster.RESET;
//                 EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Total No. of Hits Counter" += 1;
//                 JObject.Get('ewayBillNo', JToken);
//                 EInvoiceEWayBillMaster."E-Way Bill No." := JToken.AsValue().AsText();
//                 JObject.Get('ewayBillDate', JToken);
//                 Evaluate(VarEwayBillDate, JToken.AsValue().AsText());
//                 EInvoiceEWayBillMaster."E-Way Bill Date" := VarEwayBillDate;
//                 // JObject.Get('validUpto', JToken);
//                 // Evaluate(VarEwayBillValiddata, JToken.AsValue().AsText());

//                 VarEwayBillValiddata := CreateDateTime(Today, 235900T);
//                 EInvoiceEWayBillMaster."E-Way Bill Valid Till" := VarEwayBillValiddata;
//                 JObject.Get('alert', JToken);
//                 EInvoiceEWayBillMaster.alert := JToken.AsValue().AsText();

//                 EInvoiceEWayBillMaster.Modify;
//                 Commit;
//                 MESSAGE('E-Way Bill Generated Successfully.');
//             END ELSE BEGIN
//                 EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//                 EInvoiceEWayBillMaster.FINDFIRST;
//                 EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//                 JObject.Get('status_cd', JToken);
//                 EInvoiceEWayBillMaster."Response Description" := DELSTR(JToken.AsValue().AsText(), 250);
//                 EInvoiceEWayBillMaster.Modify;
//                 Commit;
//                 MESSAGE('Unable to Generate E-Way Bill. Please try again.');
//             END;
//         END;
//         //         EInvoiceEWayBillMaster.MODIFY(TRUE);
//     END;



//     PROCEDURE GenerateEWayBillForJobWork(DocNo: Code[20]; DocType: option " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return");
//     VAR
//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;
//         RecRef: RecordRef;
//         Var_DistanceInInt32: Integer;
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VJsonArrayLines: JsonArray;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record "E-Invoice & E-Way Bill Master";
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         jobject2: JsonObject;
//         EwaybillReq: text;
//         VarEwayBillDate: DateTime;
//         VarEwayBillValiddata: DateTime;
//         JArray: JsonArray;
//         JObjectLines: JsonObject;

//         // Rec_Transfer_Header: Record "Transfer Header";
//         // TransferLineRec: Record "Transfer Line";


//         Rec_Transfer_Header: Record "Transfer Shipment Header";
//         TransferLineRec: Record "Transfer Shipment Line";

//         VaractFromStateCode: Integer;
//         VarfromPincode: Integer;
//         VarfromStateCode: Integer;
//         VartoPincode: Integer;
//         VaractToStateCode: Integer;
//         VartoStateCode: Integer;
//         VartransactionType: Integer;
//         VartotalValue: Decimal;
//         VarcgstValue: Decimal;
//         VarsgstValue: Decimal;
//         VarigstValue: Decimal;
//         varcessValue: Decimal;
//         varcessNonAdvolValue: Decimal;
//         vartotInvValue: Decimal;
//         VarhsnCode: Integer;
//         Varquantity: Decimal;
//         VartaxableAmount: Decimal;
//         VarsgstRate: Integer;
//         VarcgstRate: Integer;
//         VarigstRate: Integer;
//         VarcessRate: Integer;

//         RecLocation: Record Location;

//         RecLocation2: Record Location;
//         RecState: Record State;
//         RecItem: Record Item;
//         Dt: Text[10];
//         TransferShipment: Record "Transfer Shipment Line";
//         SalesInvoiceLine: Record "Sales Invoice Line";
//         SalesShipmentHeader: Record "Sales Shipment Header";
//         shiptoaddress: Record "Ship-to Address";


//     BEGIN
//         EInvoiceEWayBillMaster.RESET;
//         EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//         EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//         EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//         EInvoiceEWayBillMaster.FINDFIRST;

//         GenerateAuthenticationAPIForSameState(EInvoiceEWayBillMaster."Location Code");
//         MasterGstApiDetails.GET(EInvoiceEWayBillMaster."Location Code");

//         IF MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST THEN BEGIN

//             Clear(VJsonObjectHeader);



//             SalesInvoiceHeader.Get(DocNo);

//             SalesShipmentHeader.Reset();
//             SalesShipmentHeader.SetRange("Order No.", SalesInvoiceHeader."Order No.");
//             if SalesShipmentHeader.FindFirst() then begin

//                 VJsonObjectHeader.Add('supplyType', 'O');
//                 VJsonObjectHeader.Add('subSupplyType', '4');
//                 VJsonObjectHeader.Add('subSupplyDesc', '');
//                 VJsonObjectHeader.Add('docType', 'CHL');
//                 VJsonObjectHeader.Add('docNo', SalesShipmentHeader."No.");
//                 Dt := FORMAT(SalesShipmentHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 VJsonObjectHeader.Add('docDate', Dt);
//                 RecLocation.Reset();
//                 RecLocation.SetRange(Code, SalesShipmentHeader."Location Code");
//                 if RecLocation.FindFirst() then begin
//                     VJsonObjectHeader.Add('fromGstin', RecLocation."GST Registration No.");
//                     VJsonObjectHeader.Add('fromTrdName', RecLocation.Name);
//                     VJsonObjectHeader.Add('fromAddr1', RecLocation.Address);
//                     VJsonObjectHeader.Add('fromAddr2', RecLocation."Address 2");
//                     VJsonObjectHeader.Add('fromPlace', RecLocation.City);

//                     RecState.Reset();
//                     RecState.Get(RecLocation."State Code");
//                     Evaluate(VaractFromStateCode, RecState."State Code (GST Reg. No.)");
//                     VJsonObjectHeader.Add('actFromStateCode', VaractFromStateCode);
//                     Evaluate(VarfromPincode, RecLocation."Post Code");
//                     VJsonObjectHeader.Add('fromPincode', VarfromPincode);
//                     // Evaluate(VarfromStateCode, '5');
//                     VJsonObjectHeader.Add('fromStateCode', VaractFromStateCode);
//                     VJsonObjectHeader.Add('dispatchFromGSTIN', RecLocation."GST Registration No.");
//                     VJsonObjectHeader.Add('dispatchFromTradeName', RecLocation.Name);
//                 end;

//                 shiptoaddress.Reset();
//                 shiptoaddress.SetRange(Code, SalesShipmentHeader."Ship-to Code");
//                 if shiptoaddress.FindFirst() then
//                     VJsonObjectHeader.Add('toGstin', shiptoaddress."GST Registration No.");
//                 VJsonObjectHeader.Add('toTrdName', shiptoaddress.Name);
//                 VJsonObjectHeader.Add('toAddr1', shiptoaddress.Address);
//                 VJsonObjectHeader.Add('toAddr2', shiptoaddress."Address 2");
//                 VJsonObjectHeader.Add('toPlace', shiptoaddress.City);
//                 Evaluate(VartoPincode, shiptoaddress."Post Code");
//                 VJsonObjectHeader.Add('toPincode', VartoPincode);
//                 RecState.Reset();
//                 RecState.Get(shiptoaddress.State);
//                 Evaluate(VaractToStateCode, RecState."State Code (GST Reg. No.)");
//                 VJsonObjectHeader.Add('actToStateCode', VaractToStateCode);

//                 RecState.Reset();
//                 RecState.Get(shiptoaddress.State);
//                 Evaluate(VartoStateCode, RecState."State Code (GST Reg. No.)");
//                 VJsonObjectHeader.Add('toStateCode', VartoStateCode);
//             end;
//             Evaluate(VartransactionType, '4');
//             VJsonObjectHeader.Add('transactionType', VartransactionType);

//             // VJsonObjectHeader.Add('dispatchFromGSTIN', '05AAACH6886N1Z0');
//             // VJsonObjectHeader.Add('dispatchFromTradeName', 'ABC Traders');
//             // VJsonObjectHeader.Add('shipToGSTIN', ''); //PBS KK
//             // VJsonObjectHeader.Add('shipToTradeName', '');

//             // Clear(VartotalValue);
//             // SalesInvoiceLine.Reset();
//             // SalesInvoiceLine.SetRange("Document No.", DocNo);
//             // if SalesInvoiceLine.FindSet() then begin
//             //     repeat
//             //         VartotalValue += SalesInvoiceLine."Expected Cost";
//             //     until SalesInvoiceLine.Next() = 0;
//             // end;
//             VJsonObjectHeader.Add('totalValue', VartotalValue);
//             VJsonObjectHeader.Add('totInvValue', VartotalValue);
//             Evaluate(VarcgstValue, '0');
//             VJsonObjectHeader.Add('cgstValue', VarcgstValue);
//             Evaluate(VarsgstValue, '0');
//             VJsonObjectHeader.Add('sgstValue', VarsgstValue);
//             Evaluate(VarigstValue, '0');
//             VJsonObjectHeader.Add('igstValue', VarigstValue);
//             Evaluate(VarcessValue, '0');
//             VJsonObjectHeader.Add('cessValue', VarcessValue);
//             Evaluate(VarcessNonAdvolValue, '0');
//             VJsonObjectHeader.Add('cessNonAdvolValue', VarcessNonAdvolValue);

//             VJsonObjectHeader.Add('transMode', EInvoiceEWayBillMaster."Transport Method");

//             VJsonObjectHeader.Add('transDistance', Format(EInvoiceEWayBillMaster."Distance (Km)"));

//             VJsonObjectHeader.Add('transporterName', COPYSTR(EInvoiceEWayBillMaster."Transporter Name", 1, 30));

//             if EInvoiceEWayBillMaster."Transporter Id" <> '' then
//                 VJsonObjectHeader.Add('transporterId', EInvoiceEWayBillMaster."Transporter Id");

//             VJsonObjectHeader.Add('transDocNo', EInvoiceEWayBillMaster."Transport Document No.");
//             VJsonObjectHeader.Add('transDocDate', FORMAT(EInvoiceEWayBillMaster."Transport Document Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//             IF EInvoiceEWayBillMaster."Transport Method" = '1' THEN BEGIN
//                 VJsonObjectHeader.Add('vehicleNo', EInvoiceEWayBillMaster."Vehicle No.");
//                 VJsonObjectHeader.Add('vehicleType', COPYSTR(FORMAT(EInvoiceEWayBillMaster."Vehicle Type"), 1, 1));
//             end;

//             Clear(JArray);
//             Clear(JObjectLines);


//             // SalesInvoiceLine.reset;
//             // SalesInvoiceLine.SetRange("Document No.", DocNo);
//             // SalesInvoiceLine.find('-');
//             // repeat
//             //     JArray.Add(JObjectLines);
//             //     JObjectLines.Add('productName', SalesInvoiceLine."No.");
//             //     JObjectLines.Add('productDesc', SalesInvoiceLine.Description);
//             //     RecItem.Reset();
//             //     if RecItem.Get(SalesInvoiceLine."No.") then begin
//             //         Evaluate(VarhsnCode, RecItem."HSN/SAC Code");
//             //         if VarhsnCode = 20052020 then VarhsnCode := 20052000;
//             //         if VarhsnCode = 17049040 then VarhsnCode := 170490;
//             //         if VarhsnCode = 95030099 then VarhsnCode := 9503;
//             //         if VarhsnCode = 21060000 then VarhsnCode := 21069060;
//             //         if VarhsnCode = 63049000 then VarhsnCode := 63049190;
//             //         if VarhsnCode = 39269090 then VarhsnCode := 3926;
//             //         if VarhsnCode = 940410 then VarhsnCode := 94041000;
//             //         if VarhsnCode = 74199939 then VarhsnCode := 7419;
//             //         if VarhsnCode = 711700 then VarhsnCode := 7117;
//             //         if VarhsnCode = 210300 then VarhsnCode := 21031000;
//             //     end;
//             //     JObjectLines.Add('hsnCode', VarhsnCode);
//             //     JObjectLines.Add('quantity', SalesInvoiceLine."Custom Qty");

//             //     JObjectLines.Add('qtyUnit', 'MTS');
//             //     JObjectLines.Add('taxableAmount', SalesInvoiceLine."Expected Cost");
//             //     Evaluate(VarsgstRate, '0');
//             //     JObjectLines.Add('sgstRate', VarsgstRate);
//             //     Evaluate(varcgstRate, '0');
//             //     JObjectLines.Add('cgstRate', varcgstRate);
//             //     Evaluate(VarigstRate, '0');
//             //     JObjectLines.Add('igstRate', VarigstRate);
//             //     Evaluate(VarcessRate, '0');
//             //     JObjectLines.Add('cessRate', VarcessRate);
//             //     Clear(JObjectLines);
//             // until SalesInvoiceLine.next = 0;
//             VJsonObjectHeader.Add('itemList', JArray);

//         end;
//         Clear(JArray);


//         VJsonObjectHeader.WriteTo(VJsonText);

//         MESSAGE(VJsonText);


//         Content.WriteFrom(VJsonText);
//         content.GetHeaders(contentHeaders);
//         contentHeaders.Clear();
//         contentHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//         contentHeaders.Add('client_id', MasterGstApiDetails."Intrastate Client ID");
//         contentHeaders.Add('client_secret', MasterGstApiDetails."Intrastate Client Secret");
//         contentHeaders.Add('username', MasterGstApiDetails."User Name");
//         // contentHeaders.Add('auth-token', MasterGstApiDetails."Auth-Token");
//         contentHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");
//         contentHeaders.Add('Content-Type', 'application/json');
//         HttpWebRequest.Content := Content;
//         // HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/type/GENERATE_EWAYBILL/version/V1_03?email=manish%40pristinebs.com');
//         HttpWebRequest.SetRequestUri('https://api.mastergst.com/ewaybillapi/v1.03/ewayapi/genewaybill?email=manish%40pristinebs.com');
//         HttpWebRequest.Method := 'POST';
//         IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//             Error('unable to Generate Eway bill');
//         HttpResponse.Content().ReadAs(Result);

//         Message(Result);
//         jobject.ReadFrom(Result);
//         JObject.Get('status_cd', JToken);
//         IF JToken.AsValue().AsText() = '1' THEN BEGIN
//             JObject.Get('data', JToken);
//             JObject := JToken.AsObject();
//             EInvoiceEWayBillMaster.RESET;
//             EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//             EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//             EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//             EInvoiceEWayBillMaster.FINDFIRST;
//             EInvoiceEWayBillMaster."Total No. of Hits Counter" += 1;
//             JObject.Get('ewayBillNo', JToken);
//             EInvoiceEWayBillMaster."E-Way Bill No." := JToken.AsValue().AsText();
//             JObject.Get('ewayBillDate', JToken);
//             Evaluate(VarEwayBillDate, JToken.AsValue().AsText());
//             EInvoiceEWayBillMaster."E-Way Bill Date" := VarEwayBillDate;
//             // JObject.Get('validUpto', JToken);
//             // Evaluate(VarEwayBillValiddata, JToken.AsValue().AsText());

//             VarEwayBillValiddata := CreateDateTime(Today, 235900T);
//             EInvoiceEWayBillMaster."E-Way Bill Valid Till" := VarEwayBillValiddata;
//             JObject.Get('alert', JToken);
//             EInvoiceEWayBillMaster.alert := JToken.AsValue().AsText();

//             EInvoiceEWayBillMaster.Modify;
//             Commit;
//             MESSAGE('E-Way Bill Generated Successfully.');
//         END ELSE BEGIN
//             EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//             EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//             EInvoiceEWayBillMaster.FINDFIRST;
//             EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//             JObject.Get('status_cd', JToken);
//             EInvoiceEWayBillMaster."Response Description" := DELSTR(JToken.AsValue().AsText(), 250);
//             EInvoiceEWayBillMaster.Modify;
//             Commit;
//             MESSAGE('Unable to Generate E-Way Bill. Please try again.');
//         END;
//     END;
//     //         EInvoiceEWayBillMaster.MODIFY(TRUE);




//     PROCEDURE GenerateAuthenticationAPIForSameState(SelectedLoc: Code[20]);
//     var
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         VarSessionGen: Text;
//         VarSessionExp: Text;
//         AuthExpTime: DateTime;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record "E-Invoice & E-Way Bill Master";
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         Combind: Text;

//     BEGIN

//         MasterGstApiDetails.Get(SelectedLoc);
//         MasterGstApiDetails.TESTFIELD(MasterGstApiDetails."User Name");
//         MasterGstApiDetails.TESTFIELD(MasterGstApiDetails.Password);

//         if MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST then begin

//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();
//             HttpWebClient.DefaultRequestHeaders.Add('username', MasterGstApiDetails."User Name");
//             HttpWebClient.DefaultRequestHeaders.Add('password', MasterGstApiDetails.Password);
//             HttpWebClient.DefaultRequestHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             HttpWebClient.DefaultRequestHeaders.Add('client_id', MasterGstApiDetails."Intrastate Client ID");
//             HttpWebClient.DefaultRequestHeaders.Add('client_secret', MasterGstApiDetails."Intrastate Client Secret");
//             HttpWebClient.DefaultRequestHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");//PBS KK GST
//             contentHeaders.Add('Content-Type', 'application/json');
//             //Combind := 'https://api.mastergst.com/ewaybillapi/v1.03/authenticate?email=manish%40pristinebs.com&' + 'username=' + MasterGstApiDetails."User Name" + '&' + 'password=' + MasterGstApiDetails.Password;
//             Combind := 'https://apisandbox.whitebooks.in/ewaybillapi/v1.03/authenticate?email=manish%40pristinebs.com';
//             // Message('URL:= %1', Combind);
//             HttpWebRequest.SetRequestUri(Combind);
//             HttpWebRequest.Method := 'GET';
//             IF Not HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('Authentication failed');
//             HttpResponse.Content().ReadAs(Result);

//             Message('Response- %1', Result);

//         end;
//     end;





//     PROCEDURE CancelEinvoice(DocNo: Code[20]; DocType: Option " ","Sales Invoice","Sales Cr.Memo","Export Invoice","Api Setup Details","Transfer","Purchase Return"; CnlRsn: Option; CnlRem: Option "Wrong entry","Duplicate","Data Entry Mistake","Order Canceled","Other");
//     VAR
//         SalesInvoiceHeader: Record 112;
//         SalesCrMemoHeader: Record 114;
//         RecRef: RecordRef;
//         HttpWebClient: HttpClient;
//         HttpWebRequest: HttpRequestMessage;
//         HttpResponse: HttpResponseMessage;
//         Content: HttpContent;
//         Result: text;
//         VJsonObjectHeader: JsonObject;
//         VJsonArray: JsonArray;
//         VJsonText: Text;
//         ContentHeaders: HttpHeaders;
//         //FormUrlEncodedContent: DotNet FormUrlEncodedContent;
//         // Class1: DotNet Class1;
//         ActualToken: text;
//         JObject, NewJsonObj : JsonObject;
//         JToken, NewJsonTokenObj : JsonToken;
//         HttpWebHeader: HttpHeaders;
//         // HttpWebClient: HttpClient;
//         // HttpResponse: HttpResponseMessage;
//         //// Content: HttpContent;
//         // Result, Output : Text;
//         // AuthExpTime: DateTime;
//         VJsonArrayLines: JsonArray;
//         MasterGstApiDetails: Record 14;
//         EInvoiceEWayBillMaster: Record 50030;
//         jsValue: JsonValue;
//         VJsonObjectLines: JsonObject;
//         jobject2: JsonObject;
//         CancelReq: text;
//     BEGIN

//         EInvoiceEWayBillMaster.RESET;
//         EInvoiceEWayBillMaster.SETCURRENTKEY("Document No.", "Document Type");
//         EInvoiceEWayBillMaster.SETRANGE("Document No.", DocNo);
//         EInvoiceEWayBillMaster.SETRANGE("Document Type", DocType);
//         EInvoiceEWayBillMaster.FINDFIRST;

//         GenerateAuthenticationAPI(EInvoiceEWayBillMaster."Location Code");
//         MasterGstApiDetails.GET(EInvoiceEWayBillMaster."Location Code");


//         IF MasterGstApiDetails."E invoice Provider" = MasterGstApiDetails."E invoice Provider"::MasterGST THEN BEGIN
//             VJsonObjectHeader.Add('IRN', EInvoiceEWayBillMaster."IRN Hash");
//             VJsonObjectHeader.Add('CnlRsn', FORMAT(CnlRsn));
//             VJsonObjectHeader.Add('CnlRem', FORMAT(CnlRem));
//             VJsonObjectHeader.WriteTo(VJsonText);
//             MESSAGE('%1', VJsonText);

//             Content.WriteFrom(VJsonText);
//             content.GetHeaders(contentHeaders);
//             contentHeaders.Clear();

//             contentHeaders.Add('ip_address', MasterGstApiDetails."IP Address");
//             contentHeaders.Add('client_id', MasterGstApiDetails."Client ID");
//             contentHeaders.Add('client_secret', MasterGstApiDetails."Client Secret");
//             contentHeaders.Add('username', MasterGstApiDetails."User Name");
//             contentHeaders.Add('auth-token', MasterGstApiDetails."Auth-Token");
//             contentHeaders.Add('gstin', MasterGstApiDetails."GSTIN Number");
//             contentHeaders.Add('Content-Type', 'application/json');
//             HttpWebRequest.Content := Content;
//             HttpWebRequest.SetRequestUri('https://api.mastergst.com/einvoice/type/CANCEL/version/V1_03?email=manish%40pristinebs.com');
//             HttpWebRequest.Method := 'POST';
//             IF NOT HttpWebClient.Send(HttpWebRequest, HttpResponse) then
//                 Error('failed to cancel');
//             // Clear(Result);
//             // Read the response content as json.
//             HttpResponse.Content().ReadAs(Result);

//             Message('Response- %1', Result);
//             JObject.ReadFrom(Result);
//             JObject.Get('status_cd', JToken);

//             IF JToken.AsValue().AsText() = '1' THEN BEGIN
//                 EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//                 JObject.Get('status_desc', JToken);
//                 EInvoiceEWayBillMaster.Reset;
//                 EInvoiceEWayBillMaster.SetRange("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.FindFirst;
//                 EInvoiceEWayBillMaster."Response Description" := JToken.AsValue().AsText();
//                 EInvoiceEWayBillMaster."E-Inv. Cancelled Date" := CURRENTDATETIME;
//                 EInvoiceEWayBillMaster."Cancel Reason" := CnlRem;
//                 EInvoiceEWayBillMaster."Total No. of Hits Counter" += 1;
//                 MESSAGE('E-Invoice Get Cancelled Successfully.');
//                 EInvoiceEWayBillMaster.Modify;
//             END ELSE BEGIN
//                 EInvoiceEWayBillMaster.SetRange("Document No.", DocNo);
//                 EInvoiceEWayBillMaster.FindFirst;
//                 EInvoiceEWayBillMaster."Response Code" := JToken.AsValue().AsText();
//                 JObject.Get('status_desc', JToken);
//                 IF STRLEN(JToken.AsValue().AsText()) > 250 THEN
//                     EInvoiceEWayBillMaster."Response Description" := DELSTR(JToken.AsValue().AsText(), 250)
//                 ELSE
//                     EInvoiceEWayBillMaster."Response Description" := JToken.AsValue().AsText();
//                 EInvoiceEWayBillMaster.Modify;
//                 MESSAGE('Unable to Cancelled the E-Invoice. Please try again.');
//             END;

//         END;
//         //         EInvoiceEWayBillMaster.MODIFY(TRUE);
//     END;



//     var
//         myInt: Integer;
// }