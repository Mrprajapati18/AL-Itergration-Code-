codeunit 80001 "SMS Sender"
{
    procedure SendDLTMessage(
        MobileNo: Text;
        Message: Text;
        TemplateID: Text;
        DocumentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text
    ): Boolean
    var
        SMSSetup: Record "SMS Setup";
        Success: Boolean;
        ResponseText: Text;
        StatusCode: Integer;
        GatewayMsgID: Text;
        ErrorMsg: Text;
    begin
        SMSSetup := SMSSetup.GetSetup();

        MobileNo := CleanMobileNo(MobileNo);
        if not ValidateMobile(MobileNo) then begin
            WriteLog(DocumentNo, CustomerNo, CustomerName, MobileNo,
                     TemplateID, Message, 0, false, '', 'Invalid mobile number: ' + MobileNo, '');
            exit(false);
        end;

        // Route to the correct gateway handler
        case SMSSetup."Gateway Provider" of
            "SMS Gateway Provider"::MSG91:
                Success := SendViaMSG91(SMSSetup, MobileNo, Message, TemplateID, ResponseText, StatusCode, GatewayMsgID, ErrorMsg);
            "SMS Gateway Provider"::Textlocal:
                Success := SendViaTextlocal(SMSSetup, MobileNo, Message, TemplateID, ResponseText, StatusCode, GatewayMsgID, ErrorMsg);
            "SMS Gateway Provider"::Exotel:
                Success := SendViaExotel(SMSSetup, MobileNo, Message, TemplateID, ResponseText, StatusCode, GatewayMsgID, ErrorMsg);
            "SMS Gateway Provider"::Custom:
                Success := SendViaCustom(SMSSetup, MobileNo, Message, TemplateID, ResponseText, StatusCode, GatewayMsgID, ErrorMsg);
        end;


        WriteLog(DocumentNo, CustomerNo, CustomerName, MobileNo,
                 TemplateID, Message, StatusCode, Success, ResponseText, ErrorMsg, GatewayMsgID);

        exit(Success);
    end;

    procedure SendRaw(MobileNo: Text; Message: Text; TemplateID: Text; DocumentNo: Code[20])
    begin
        SendDLTMessage(MobileNo, Message, TemplateID, DocumentNo, '', 'Manual Resend');
    end;

    local procedure SendViaMSG91(
        SMSSetup: Record "SMS Setup";
        MobileNo: Text;
        Message: Text;
        TemplateID: Text;
        var ResponseText: Text;
        var StatusCode: Integer;
        var GatewayMsgID: Text;
        var ErrorMsg: Text
    ): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        JObj: JsonObject;
        JRecipient: JsonObject;
        JRecipients: JsonArray;
        RequestBody: Text;
        JResp: JsonObject;
        JToken: JsonToken;
    begin
        // Build payload
        JRecipient.Add('mobiles', '91' + MobileNo);
        JRecipients.Add(JRecipient);

        JObj.Add('template_id', TemplateID);
        JObj.Add('short_url', '0');
        JObj.Add('recipients', JRecipients);
        JObj.WriteTo(RequestBody);

        // Setup request
        Content.WriteFrom(RequestBody);
        Content.GetHeaders(Headers);
        if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        Request.Method := 'POST';
        Request.SetRequestUri(SMSSetup."API URL");
        Request.Content := Content;

        Request.GetHeaders(Headers);
        Headers.Add('authkey', SMSSetup."Auth Key / API Key");
        Headers.Add('Accept', 'application/json');

        Client.Timeout := SMSSetup."Timeout Seconds" * 1000;

        if not Client.Send(Request, Response) then begin
            ErrorMsg := GetLastErrorText();
            StatusCode := 0;
            exit(false);
        end;

        StatusCode := Response.HttpStatusCode();
        Response.Content().ReadAs(ResponseText);

        if Response.IsSuccessStatusCode() then begin
            //  MSG91 returns { "type": "success", "message": "1 message(s) sent successfully." }
            if JResp.ReadFrom(ResponseText) then
                if JResp.Get('message', JToken) then
                    GatewayMsgID := JToken.AsValue().AsText();
            exit(true);
        end;

        ErrorMsg := ExtractErrorMsg(ResponseText);
        exit(false);
    end;

    // Textlocal Implementation
    // POST https://api.txtlocal.in/send/
    // Form-encoded body with DLT template_id

    local procedure SendViaTextlocal(
        SMSSetup: Record "SMS Setup";
        MobileNo: Text;
        Message: Text;
        TemplateID: Text;
        var ResponseText: Text;
        var StatusCode: Integer;
        var GatewayMsgID: Text;
        var ErrorMsg: Text
    ): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        FormBody: Text;
        JResp: JsonObject;
        JToken: JsonToken;
        JMessages: JsonArray;
        JMsg: JsonToken;
    begin
        FormBody := 'apikey=' + SMSSetup."Auth Key / API Key" +
                    '&numbers=91' + MobileNo +
                    '&message=' + Message +
                    '&sender=' + SMSSetup."Sender ID" +
                    '&template_id=' + TemplateID +
                    '&dlt_entity_id=' + SMSSetup."DLT Entity ID";

        Content.WriteFrom(FormBody);
        Content.GetHeaders(Headers);
        if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(SMSSetup."API URL");
        Request.Content := Content;

        Client.Timeout := SMSSetup."Timeout Seconds" * 1000;

        if not Client.Send(Request, Response) then begin
            ErrorMsg := GetLastErrorText();
            StatusCode := 0;
            exit(false);
        end;

        StatusCode := Response.HttpStatusCode();
        Response.Content().ReadAs(ResponseText);

        if JResp.ReadFrom(ResponseText) then begin
            if JResp.Get('status', JToken) then
                if JToken.AsValue().AsText() = 'success' then begin
                    if JResp.Get('messages', JToken) then begin
                        JMessages := JToken.AsArray();
                        if JMessages.Count() > 0 then begin
                            JMessages.Get(0, JMsg);
                            if JMsg.AsObject().Get('id', JToken) then
                                GatewayMsgID := JToken.AsValue().AsText();
                        end;
                    end;
                    exit(true);
                end;
            ErrorMsg := ExtractErrorMsg(ResponseText);
        end;

        exit(false);
    end;

    // Exotel Implementation
    // POST https://api.exotel.com/v1/Accounts/{SID}/Sms/send
    // Basic Auth, form-encoded

    local procedure SendViaExotel(
        SMSSetup: Record "SMS Setup";
        MobileNo: Text;
        Message: Text;
        TemplateID: Text;
        var ResponseText: Text;
        var StatusCode: Integer;
        var GatewayMsgID: Text;
        var ErrorMsg: Text
    ): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        FormBody: Text;
        JResp: JsonObject;
        JToken: JsonToken;
        JSMSMessage: JsonToken;
    begin
        FormBody := 'From=' + SMSSetup."Sender ID" +
                    '&To=0' + MobileNo +
                    '&Body=' + Message +
                    '&DltTemplateId=' + TemplateID +
                    '&DltEntityId=' + SMSSetup."DLT Entity ID";

        Content.WriteFrom(FormBody);
        Content.GetHeaders(Headers);
        if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(SMSSetup."API URL");
        Request.Content := Content;

        Request.GetHeaders(Headers);

        // Exotel uses Basic Auth with API key:token
        // Headers.Add('Authorization', 'Basic ' + Base64Encode(SMSSetup."Auth Key / API Key"));

        Client.Timeout := SMSSetup."Timeout Seconds" * 1000;

        if not Client.Send(Request, Response) then begin
            ErrorMsg := GetLastErrorText();
            StatusCode := 0;
            exit(false);
        end;

        StatusCode := Response.HttpStatusCode();
        Response.Content().ReadAs(ResponseText);

        if Response.IsSuccessStatusCode() then begin
            // Exotel returns { "SMSMessage": { "Sid": "...", "Status": "queued" } }
            if JResp.ReadFrom(ResponseText) then
                if JResp.Get('SMSMessage', JSMSMessage) then
                    if JSMSMessage.AsObject().Get('Sid', JToken) then
                        GatewayMsgID := JToken.AsValue().AsText();
            exit(true);
        end;

        ErrorMsg := ExtractErrorMsg(ResponseText);
        exit(false);
    end;
    //  Sends JSON: mobile, message, template_id, sender, entity_id
    local procedure SendViaCustom(
        SMSSetup: Record "SMS Setup";
        MobileNo: Text;
        Message: Text;
        TemplateID: Text;
        var ResponseText: Text;
        var StatusCode: Integer;
        var GatewayMsgID: Text;
        var ErrorMsg: Text
    ): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        JObj: JsonObject;
        RequestBody: Text;
        JResp: JsonObject;
        JToken: JsonToken;
    begin
        JObj.Add('mobile', '91' + MobileNo);
        JObj.Add('message', Message);
        JObj.Add('template_id', TemplateID);
        JObj.Add('sender', SMSSetup."Sender ID");
        JObj.Add('entity_id', SMSSetup."DLT Entity ID");
        JObj.WriteTo(RequestBody);

        Content.WriteFrom(RequestBody);
        Content.GetHeaders(Headers);
        if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        Request.Method := 'POST';
        Request.SetRequestUri(SMSSetup."API URL");
        Request.Content := Content;

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + SMSSetup."Auth Key / API Key");
        Headers.Add('Accept', 'application/json');

        Client.Timeout := SMSSetup."Timeout Seconds" * 1000;

        if not Client.Send(Request, Response) then begin
            ErrorMsg := GetLastErrorText();
            StatusCode := 0;
            exit(false);
        end;

        StatusCode := Response.HttpStatusCode();
        Response.Content().ReadAs(ResponseText);

        if Response.IsSuccessStatusCode() then begin
            if JResp.ReadFrom(ResponseText) then
                if JResp.Get('message_id', JToken) then
                    GatewayMsgID := JToken.AsValue().AsText();
            exit(true);
        end;

        ErrorMsg := ExtractErrorMsg(ResponseText);
        exit(false);
    end;


    local procedure WriteLog(
        DocumentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text;
        MobileNo: Text;
        TemplateID: Text;
        MessageSent: Text;
        StatusCode: Integer;
        Success: Boolean;
        APIResponse: Text;
        ErrorMsg: Text;
        GatewayMsgID: Text
    )
    var
        SMSLog: Record "SMS Log";
    begin
        SMSLog.Init();
        SMSLog."Document Type" := 'Sales Credit Memo';
        SMSLog."Document No." := DocumentNo;
        SMSLog."Customer No." := CustomerNo;
        SMSLog."Customer Name" := CopyStr(CustomerName, 1, 100);
        SMSLog."Mobile No." := CopyStr(MobileNo, 1, 20);
        SMSLog."Template ID" := CopyStr(TemplateID, 1, 50);
        SMSLog."Message Sent" := CopyStr(MessageSent, 1, 2000);
        SMSLog."API Response" := CopyStr(APIResponse, 1, 2000);
        SMSLog."HTTP Status" := StatusCode;
        SMSLog.Success := Success;
        SMSLog."Error Message" := CopyStr(ErrorMsg, 1, 500);
        SMSLog."Message ID (Gateway)" := CopyStr(GatewayMsgID, 1, 100);
        SMSLog."Sent At" := CurrentDateTime();
        SMSLog."Sent By" := CopyStr(UserId(), 1, 50);
        SMSLog.Insert();
    end;

    local procedure CleanMobileNo(MobileNo: Text): Text
    begin

        MobileNo := MobileNo.Replace('+91', '').Replace(' ', '').Replace('-', '').Replace('(', '').Replace(')', '');
        if MobileNo.StartsWith('0') then
            MobileNo := MobileNo.Substring(2);
        if MobileNo.StartsWith('91') and (StrLen(MobileNo) = 12) then
            MobileNo := MobileNo.Substring(3);
        exit(MobileNo);
    end;

    local procedure ValidateMobile(MobileNo: Text): Boolean
    begin
        if StrLen(MobileNo) <> 10 then exit(false);
        if not (MobileNo[1] in ['6', '7', '8', '9']) then exit(false);
        exit(true);
    end;

    local procedure ExtractErrorMsg(ResponseText: Text): Text
    var
        JObj: JsonObject;
        JToken: JsonToken;
    begin
        if JObj.ReadFrom(ResponseText) then begin
            if JObj.Get('message', JToken) then exit(JToken.AsValue().AsText());
            if JObj.Get('error', JToken) then exit(JToken.AsValue().AsText());
            if JObj.Get('errors', JToken) then exit(JToken.AsValue().AsText());
        end;
        exit(CopyStr(ResponseText, 1, 200));
    end;
}
