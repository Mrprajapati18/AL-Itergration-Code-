codeunit 50001 "PBS My Seed SMS Management"
{

    procedure SendSalesReturnSMS(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 1, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API.');
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, '', TemplateID, TemplateName);
    end;

    procedure SendSalesOrderSMS(CustomerNo: Code[20]; OrderNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 2, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API for Template ID: %1.', TemplateID);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, OrderNo, TemplateID, TemplateName);
    end;

    procedure SendShipmentSMS(CustomerNo: Code[20]; ShipmentNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 3, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API.');
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, ShipmentNo, TemplateID, TemplateName);
    end;

    procedure SendDispatchChallanSMS(CustomerNo: Code[20]; DocumentNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 4, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API.');
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, DocumentNo, TemplateID, TemplateName);
    end;

    procedure SendFisoBisoSMS(CustomerNo: Code[20]; DocumentNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 5, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API.');
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, DocumentNo, TemplateID, TemplateName);
    end;

    procedure SendDealerOnboardSMS(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 6, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API.');
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, '', TemplateID, TemplateName);
    end;

    procedure SendSalesInvoiceSMS(CustomerNo: Code[20]; InvoiceNo: Code[20])
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 7, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API for Template ID: %1.', TemplateID);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, InvoiceNo, TemplateID, TemplateName);
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
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        if SourceType <> SourceType::Customer then
            Error('SMS can only be sent for Customer bank entries.');
        ValidateCustomerAndSetup(SourceNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, 8, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API for Template ID: %1.', TemplateID);
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, SourceNo, DocumentNo, TemplateID, TemplateName);
    end;

    procedure SendSMSByTemplateNo(CustomerNo: Code[20]; DocumentNo: Code[20]; TemplateNo: Integer)
    var
        Customer: Record Customer;
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        APIMessage: Text;
        TemplateID: Text[50];
        TemplateName: Text[100];
    begin
        ValidateCustomerAndSetup(CustomerNo, Customer, SMSSetup, PhoneNo);
        GetTemplateByNo(SMSSetup, TemplateNo, TemplateID, TemplateName);
        APIMessage := FetchTemplateContentFromAPI(SMSSetup, TemplateID);
        if APIMessage = '' then
            Error('Template content not received from API.');
        SendSMSWithFetchedContent(Customer, SMSSetup, PhoneNo, APIMessage, CustomerNo, DocumentNo, TemplateID, TemplateName);
    end;

    local procedure GetTemplateByNo(
        SMSSetup: Record "MY Seeds SMS Setup";
        TemplateNo: Integer;
        var TemplateID: Text[50];
        var TemplateName: Text[100])
    begin
        case TemplateNo of
            1:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 1", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name", 1, 100);
                end;
            2:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 2", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 2", 1, 100);
                end;
            3:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 3", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 3", 1, 100);
                end;
            4:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 4", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 4", 1, 100);
                end;
            5:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 5", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 5", 1, 100);
                end;
            6:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 6", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 6", 1, 100);
                end;
            7:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 7", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 7", 1, 100);
                end;
            8:
                begin
                    TemplateID := CopyStr(DelChr(SMSSetup."Template ID 8", '=', ' '), 1, 50);
                    TemplateName := CopyStr(SMSSetup."Template Name 8", 1, 100);
                end;
            else
                Error('Invalid Template Number.');
        end;

        if TemplateID = '' then
            Error('Template ID is not Found.');
        if TemplateName = '' then
            Error('Template Name is not Found.');
    end;

    local procedure FetchTemplateContentFromAPI(
        SMSSetup: Record "MY Seeds SMS Setup";
        TemplateID: Text[50]): Text
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        JsonPayload: Text;
        CleanAPIKey: Text[250];
        TemplateContent: Text;
        FetchURL: Text;
    begin
        CleanAPIKey := CopyStr(DelChr(SMSSetup."API Key", '=', ' '), 1, 250);
        FetchURL := SMSSetup."SMS Gateway URL";

        JsonPayload :=
            '{' +
            '"apikey":"' + CleanAPIKey + '",' +
            '"templateid":"' + TemplateID + '",' +
            '"action":"gettemplate"' +
            '}';

        HttpContent.WriteFrom(JsonPayload);
        HttpContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        HttpRequest.SetRequestUri(FetchURL);
        HttpRequest.Method := 'POST';
        HttpRequest.Content := HttpContent;

        if not HttpClient.Send(HttpRequest, HttpResponse) then
            exit('');
        if not HttpResponse.IsSuccessStatusCode() then
            exit('');

        HttpResponse.Content().ReadAs(ResponseText);

        TemplateContent := ExtractJsonValue(ResponseText, 'template');
        if TemplateContent = '' then
            TemplateContent := ExtractJsonValue(ResponseText, 'content');
        if TemplateContent = '' then
            TemplateContent := ExtractJsonValue(ResponseText, 'message');
        if TemplateContent = '' then
            TemplateContent := ExtractJsonValue(ResponseText, 'body');
        if TemplateContent = '' then
            TemplateContent := ExtractJsonValue(ResponseText, 'text');
        if TemplateContent = '' then
            TemplateContent := ExtractJsonValue(ResponseText, 'msg');

        exit(TemplateContent);
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
        Message: Text;
        CustomerNo: Code[20];
        DocumentNo: Code[20];
        TemplateID: Text[50];
        TemplateName: Text[100])
    begin
        if Message = '' then
            Error('Message cannot be empty.');

        SendViaSMSGatewayWithTemplate(
            SMSSetup, PhoneNo, Message,
            CustomerNo, Customer.Name, DocumentNo, TemplateID);
    end;

    local procedure SendViaSMSGatewayWithTemplate(
        SMSSetup: Record "MY Seeds SMS Setup";
        PhoneNo: Text[30];
        Message: Text;
        CustomerNo: Code[20];
        CustomerName: Text[100];
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
        MsgID: Text;
    begin
        CleanSenderID := DelChr(UpperCase(SMSSetup."Sender ID"), '=', ' ');
        CleanSenderID := DelChr(CleanSenderID, '=', '-');
        CleanSenderID := DelChr(CleanSenderID, '=', '_');

        if CleanSenderID = '' then
            Error('Sender ID cannot be blank.');

        CleanAPIKey := CopyStr(DelChr(SMSSetup."API Key", '=', ' '), 1, 250);
        CleanTemplateID := CopyStr(OverrideTemplateID, 1, 50);
        APIURL := SMSSetup."SMS Gateway URL";

        JsonPayload :=
            '{' +
            '"apikey":"' + CleanAPIKey + '",' +
            '"senderid":"' + CleanSenderID + '",' +
            '"number":"' + PhoneNo + '",' +
            '"message":"' + EscapeJsonString(Message) + '",' +
            '"templateid":"' + CleanTemplateID + '",' +
            '"format":"json"' +
            '}';

        SMSLog.Init();
        SMSLog."Customer No." := CustomerNo;
        SMSLog."Customer Name" := CustomerName;
        SMSLog."Phone No." := PhoneNo;
        SMSLog."Template ID" := CleanTemplateID;
        SMSLog."Message Sent" := CopyStr(Message, 1, 500);
        SMSLog."Sent DateTime" := CurrentDateTime();
        SMSLog.Status := LogStatus::Pending;
        SMSLog."Sent By" := CopyStr(UserId(), 1, 50);
        SMSLog."Sender ID" := CopyStr(CleanSenderID, 1, 10);
        SMSLog."Source Document No." := DocumentNo;
        SMSLog."PE ID" := CopyStr(SMSSetup."PE ID", 1, 20);
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

        if IsmTalkzError(ResponseText, ErrorMsg) then begin
            UpdateSMSLog(SMSLog, LogStatus::Failed, ErrorMsg, ResponseText);
            Error(
                'SMS sending failed.\' +
                'Gateway Error: %1\' +
                'Full Response: %2\' +
                'Sender ID Used: %3',
                ErrorMsg, ResponseText, CleanSenderID);
        end;

        MsgID := ExtractJsonValue(ResponseText, 'msgid');
        if MsgID = '' then
            MsgID := ExtractJsonValue(ResponseText, 'messageid');

        UpdateSMSLog(SMSLog, LogStatus::Sent, '', ResponseText);

        Message('SMS sent successfully to %1 (%2).\Message ID: %3', CustomerName, PhoneNo, MsgID);
    end;

    local procedure IsmTalkzError(ResponseText: Text; var ErrorMessage: Text): Boolean
    begin
        ErrorMessage := '';

        if IsMtalkzSuccess(ResponseText) then
            exit(false);

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

        ErrorMessage := ResponseText;
        exit(true);
    end;

    local procedure IsMtalkzSuccess(ResponseText: Text): Boolean
    begin
        if ResponseText.Contains('"status":"200"') or
           ResponseText.Contains('"status":"success"') or
           ResponseText.Contains('"msgid"')
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
