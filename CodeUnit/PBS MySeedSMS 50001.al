
codeunit 50001 "PBS My Seed SMS Management"
{
    procedure SendSalesReturnSMS(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 1, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, '', TemplateID, TemplateName); 
    end;

    procedure SendSalesOrderSMS(CustomerNo: Code[20]; OrderNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 2, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, OrderNo, TemplateID, TemplateName);
    end;

    procedure SendShipmentSMS(CustomerNo: Code[20]; ShipmentNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 3, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, ShipmentNo, TemplateID, TemplateName);
    end;

    procedure SendDispatchChallanSMS(CustomerNo: Code[20]; DocumentNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 4, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, DocumentNo, TemplateID, TemplateName);
    end;

    procedure SendFisoBisoSMS(CustomerNo: Code[20]; DocumentNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 5, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, DocumentNo, TemplateID, TemplateName);
    end;

    procedure SendDealerOnboardSMS(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 6, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, '', TemplateID, TemplateName);
    end;

    procedure SendSalesInvoiceSMS(CustomerNo: Code[20]; InvoiceNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 7, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, InvoiceNo, TemplateID, TemplateName);
    end;

    procedure SendBankPaymentSMS(
        SourceNo: Code[20];
        DocumentNo: Code[20];
        PaidAmount: Decimal;
        SourceType: Enum "Gen. Journal Source Type")
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        if SourceType <> SourceType::Customer then
            Error('SMS can only be sent for Customer bank entries.');
        ValidateCustomerAndSetup(SourceNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 8, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, SourceNo, DocumentNo, TemplateID, TemplateName);
    end;

    procedure SendSMSByTemplateNo(CustomerNo: Code[20]; DocumentNo: Code[20]; TemplateNo: Integer)
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        TemplateID: Text[50];
        TemplateName: Text[500];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, TemplateNo, TemplateID, TemplateName);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, TemplateName, CustomerNo, DocumentNo, TemplateID, TemplateName);
    end;

    local procedure GetTemplateByNo(
        SMSSetup: Record "MY Seeds SMS Setup";
        TemplateNo: Integer;
        var TemplateID: Text[50];
        var TemplateName: Text[500])
    begin
        case TemplateNo of
            1:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 1", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name", 1, 500);
                end;
            2:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 2", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 2", 1, 500);
                end;
            3:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 3", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 3", 1, 500);
                end;
            4:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 4", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 4", 1, 500);
                end;
            5:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 5", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 5", 1, 500);
                end;
            6:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 6", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 6", 1, 500);
                end;
            7:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 7", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 7", 1, 500);
                end;
            8:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 8", '<>', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 8", 1, 500);
                end;
            else
                Error('Invalid Template Number.');
        end;

        if TemplateID = '' then
            Error('Template ID is not configured for Template No. %1.', TemplateNo);
        if TemplateName = '' then
            Error('Template Name (Message Text) is not configured for Template No. %1.\Please fill the approved DLT message text in the Template Name field of SMS Setup.', TemplateNo);
    end;

    local procedure ValidateCustomerAndSetup(
        CustomerNo: Code[20];
        var Customer: Record Customer;
        var SMSSetup: Record "MY Seeds SMS Setup";
        var PhoneNo: Text[30])
    begin
        if not Customer.Get(CustomerNo) then
            Error('Customer not found: %1', CustomerNo);

        PhoneNo := GetCleanPhoneNo(Customer."Mobile Phone No.");
        if PhoneNo = '' then
            PhoneNo := GetCleanPhoneNo(Customer."Phone No.");
        if PhoneNo = '' then
            Error('Customer mobile number is missing.');

        if not SMSSetup.Get('') then
            Error('SMS Setup is not configured.');
        if not SMSSetup.Enabled then
            Error('SMS Sending is disabled.');
        if SMSSetup."SMS Gateway URL" = '' then
            Error('SMS Gateway URL is missing.');
        if SMSSetup."API Key" = '' then
            Error('API Key is missing.');
        if SMSSetup."Sender ID" = '' then
            Error('Sender ID is missing.');
        if SMSSetup."PE ID" = '' then
            Error('PE ID is missing.');
        if not IsValidIndianMobile(PhoneNo) then
            Error('Invalid Indian mobile number: %1', PhoneNo);
    end;

    local procedure SendSMSWithFetchedContent(
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        MessageText: Text;
        CustomerNo: Code[20];
        DocumentNo: Code[20];
        TemplateID: Text[50];
        TemplateName: Text[500])
    begin
        if MessageText = '' then
            Error('Message cannot be empty.');

        SendViaSMSGatewayWithTemplate(
            SMSSetup, PhoneNo, MessageText,
            CustomerNo, Customer.Name, DocumentNo, TemplateID);
    end;

    local procedure SendViaSMSGatewayWithTemplate(
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        MessageText: Text;
        CustomerNo: Code[20];
        CustomerName: Text[500];
        DocumentNo: Code[20];
        OverrideTemplateID: Text[50])
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        SMSLog: Record "MY Seeds SMS Log";
        LogStatus: Option "Pending","Sent","Failed";
        ErrorMsg: Text;
        JsonPayload: Text;
        APIURL: Text;
        CleanSenderID: Text[20];
        CleanAPIKey: Text[250];
        CleanTemplateID: Text[50];
        CleanPEID: Text[20];
        MsgID: Text;
    begin
        CleanSenderID := CopyStr(DelChr(UpperCase(SMSSetup."Sender ID"), '<>', ' '), 1, 20);
        if CleanSenderID = '' then
            Error('Sender ID cannot be blank.');

        CleanAPIKey := CopyStr(DelChr(SMSSetup."API Key", '<>', ' '), 1, 250);
        CleanTemplateID := CopyStr(DelChr(OverrideTemplateID, '<>', ' '), 1, 50);
        CleanPEID := CopyStr(DelChr(SMSSetup."PE ID", '<>', ' '), 1, 20);
        APIURL := DelChr(SMSSetup."SMS Gateway URL", '<>', ' ');

        JsonPayload :=
            '{' +
            '"apikey":"' + CleanAPIKey + '",' +
            '"senderid":"' + CleanSenderID + '",' +
            '"number":"' + PhoneNo + '",' +
            '"message":"' + EscapeJsonString(MessageText) + '",' +
            '"templateid":"' + CleanTemplateID + '",' +
            '"peid":"' + CleanPEID + '",' +
            '"format":"json"' +
            '}';

        SMSLog.Init();
        SMSLog."Customer No." := CustomerNo;
        SMSLog."Customer Name" := CustomerName;
        SMSLog."Phone No." := PhoneNo;
        SMSLog."Template ID" := CleanTemplateID;
        SMSLog."Message Sent" := CopyStr(MessageText, 1, 500);
        SMSLog."Sent DateTime" := CurrentDateTime();
        SMSLog.Status := LogStatus::Pending;
        SMSLog."Sent By" := CopyStr(UserId(), 1, 50);
        SMSLog."Sender ID" := CopyStr(CleanSenderID, 1, 10);
        SMSLog."Source Document No." := DocumentNo;
        SMSLog."PE ID" := CopyStr(CleanPEID, 1, 20);
        SMSLog.Insert(true);

        HttpContent.WriteFrom(JsonPayload);
        HttpContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        HttpRequest.SetRequestUri(APIURL);
        HttpRequest.Method := 'POST';
        HttpRequest.Content := HttpContent;

        if not HttpClient.Send(HttpRequest, HttpResponse) then begin
            ErrorMsg := 'Unable to connect to SMS Gateway.';
            UpdateSMSLog(SMSLog, LogStatus::Failed, ErrorMsg, '');
            Error(ErrorMsg);
        end;

        HttpResponse.Content().ReadAs(ResponseText);
        SMSLog."API Response" := CopyStr(ResponseText, 1, 500);

        if not HttpResponse.IsSuccessStatusCode() then begin
            ErrorMsg := 'HTTP Error ' + Format(HttpResponse.HttpStatusCode()) + ': ' + ResponseText;
            UpdateSMSLog(SMSLog, LogStatus::Failed, ErrorMsg, ResponseText);
            Error(ErrorMsg);
        end;

        if IsMtalkzSuccess(ResponseText) then begin
            MsgID := ExtractJsonValue(ResponseText, 'msgid');
            if MsgID = '' then
                MsgID := ExtractJsonValue(ResponseText, 'messageid');
            if MsgID = '' then
                MsgID := ExtractJsonValue(ResponseText, 'id');
            UpdateSMSLog(SMSLog, LogStatus::Sent, '', ResponseText);
            Message('SMS sent successfully to %1 (%2).\Message ID: %3', CustomerName, PhoneNo, MsgID);
            exit;
        end;

        if IsmTalkzError(ResponseText, ErrorMsg) then begin
            UpdateSMSLog(SMSLog, LogStatus::Failed, ErrorMsg, ResponseText);
            Error(
                'SMS sending failed.\Gateway Error: %1\Full Response: %2\Sender ID Used: %3',
                ErrorMsg, ResponseText, CleanSenderID);
        end;

        UpdateSMSLog(SMSLog, LogStatus::Sent, '', ResponseText);
        Message('SMS sent to %1 (%2).', CustomerName, PhoneNo);
    end;

    local procedure IsmTalkzError(ResponseText: Text; var ErrorMessage: Text): Boolean
    begin
        ErrorMessage := '';

        if ResponseText.Contains('"status":"AZQ') then begin
            ErrorMessage := ExtractJsonValue(ResponseText, 'message');
            if ErrorMessage = '' then
                ErrorMessage := ResponseText;
            exit(true);
        end;

        if ResponseText.Contains('"error":"') then begin
            ErrorMessage := ExtractJsonValue(ResponseText, 'error');
            if ErrorMessage = '' then
                ErrorMessage := ResponseText;
            exit(true);
        end;

        if ResponseText.Contains('Invalid senderid') or
           ResponseText.Contains('invalid senderid') or
           ResponseText.Contains('Invalid Senderid') then begin
            ErrorMessage := CopyStr(ResponseText, 1, 200);
            exit(true);
        end;

        exit(false);
    end;

    local procedure IsMtalkzSuccess(ResponseText: Text): Boolean
    begin
        if ResponseText.Contains('"status":"200"') or
           ResponseText.Contains('"status": "200"') or
           ResponseText.Contains('"status":"success"') or
           ResponseText.Contains('"status":"Success"') or
           ResponseText.Contains('"status":"OK"') or
           ResponseText.Contains('"status":"ok"') or
           ResponseText.Contains('"status":"SUBMITTED"') or
           ResponseText.Contains('"status":"submitted"') or
           ResponseText.Contains('"msgid"') or
           ResponseText.Contains('"messageid"') or
           ResponseText.Contains('"message":"message submitted successfully"') or
           ResponseText.Contains('"message":"Message Sent') or
           ResponseText.Contains('"message":"SMS sent')
        then
            exit(true);
        exit(false);
    end;

    local procedure IsValidIndianMobile(PhoneNo: Text[30]): Boolean
    begin
        if StrLen(PhoneNo) <> 12 then
            exit(false);
        if CopyStr(PhoneNo, 1, 2) <> '91' then
            exit(false);
        exit(true);
    end;

    local procedure GetCleanPhoneNo(RawPhone: Text[30]): Text[30]
    var
        CleanPhone: Text[30];
        i: Integer;
        c: Char;
    begin
        CleanPhone := '';
        for i := 1 to StrLen(RawPhone) do begin
            c := RawPhone[i];
            if c in ['0' .. '9'] then
                CleanPhone += Format(c);
        end;

        if StrLen(CleanPhone) = 10 then
            CleanPhone := '91' + CleanPhone
        else
            if (StrLen(CleanPhone) = 11) and (CleanPhone[1] = '0') then
                CleanPhone := '91' + CopyStr(CleanPhone, 2);

        exit(CleanPhone);
    end;

    local procedure ExtractJsonValue(JsonText: Text; FieldName: Text): Text
    var
        SearchKey: Text;
        StartPos: Integer;
        EndPos: Integer;
    begin
        SearchKey := '"' + FieldName + '":"';
        StartPos := StrPos(JsonText, SearchKey);
        if StartPos = 0 then
            exit('');

        StartPos := StartPos + StrLen(SearchKey);
        EndPos := StartPos;
        while (EndPos <= StrLen(JsonText)) and (JsonText[EndPos] <> '"') do
            EndPos += 1;

        exit(CopyStr(JsonText, StartPos, EndPos - StartPos));
    end;

    local procedure UpdateSMSLog(
        var SMSLog: Record "MY Seeds SMS Log";
        NewStatus: Option "Pending","Sent","Failed";
        ErrMsg: Text;
        APIResp: Text)
    begin
        SMSLog.Status := NewStatus;
        if ErrMsg <> '' then
            SMSLog."Error Message" := CopyStr(ErrMsg, 1, 500);
        if APIResp <> '' then
            SMSLog."API Response" := CopyStr(APIResp, 1, 500);
        SMSLog.Modify(true);
    end;

    local procedure EscapeJsonString(InputStr: Text): Text
    var
        Result: Text;
    begin
        Result := InputStr;
        Result := Result.Replace('\', '\\');
        Result := Result.Replace('"', '\"');
        Result := Result.Replace('/', '\/');
        exit(Result);
    end;
}
