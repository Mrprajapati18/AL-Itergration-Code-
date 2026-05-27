codeunit 80002 "WhatsApp Sender"
{
    procedure SendWhatsAppMessage(CustomerNo: Code[20]; PhoneNo: Text; InvoiceNo: Text; MessageText: Text): Text
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        JsonBody: Text;
        ApiKey: Text;
        TemplateName: Text;
        ResponseText: Text;
        WhatsAppHistory: Record "WhatsApp Message History";
        WhatsAppSetup: Record "WhatsApp Setup";
    begin
        if not WhatsAppSetup.Get('DEFAULT') then begin
            WhatsAppSetup.Init();
            WhatsAppSetup."Primary Key" := 'DEFAULT';
            WhatsAppSetup."API Key" := '8o4RgbkWZdm5NcidrDOU0ZbNJ1tM6ilipAimWOtPfd5c3120';
            WhatsAppSetup."Template Name" := 'payment_reminder';
            WhatsAppSetup.Insert();
        end;

        ApiKey := WhatsAppSetup."API Key";
        TemplateName := WhatsAppSetup."Template Name";

        JsonBody := '{"phone":"' + JsonEscapeText(PhoneNo) + '",' +
                    '"template":"' + JsonEscapeText(TemplateName) + '",' +
                    '"body":"' + JsonEscapeText(MessageText) + '"}';

        
        Message('WhatsApp request body: %1', JsonBody);

        HttpContent.WriteFrom(JsonBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('Authorization', 'Bearer ' + ApiKey);

        HttpRequest.Method := 'POST';
        HttpRequest.SetRequestUri('https://chat.leminai.com/api/wpbox/sendtemplatemessage');
        HttpRequest.Content := HttpContent;

        // Send
        if not HttpClient.Send(HttpRequest, HttpResponse) then
            Error('Failed to connect to the WhatsApp API. Please check your internet connection.');

        HttpResponse.Content.ReadAs(ResponseText);

        // Insert into history
        WhatsAppHistory.Init();
        WhatsAppHistory."Customer No." := CustomerNo;
        WhatsAppHistory."Phone No." := PhoneNo;
        WhatsAppHistory."Invoice No." := InvoiceNo;
        WhatsAppHistory.Message := MessageText;
        WhatsAppHistory."Sent Date" := Today;
        WhatsAppHistory."Sent Time" := Time;
        WhatsAppHistory."User ID" := UserId;
        WhatsAppHistory.Response := ResponseText;

        if HttpResponse.IsSuccessStatusCode then begin
            WhatsAppHistory.Status := WhatsAppHistory.Status::Sent;
            WhatsAppHistory.Insert();
            exit('SUCCESS');
        end else begin
            WhatsAppHistory.Status := WhatsAppHistory.Status::Failed;
            WhatsAppHistory.Insert();
            if HttpResponse.HttpStatusCode = 401 then
                Error('Invalid API token. Please check your WhatsApp Setup and ensure the API Key is correct.')
            else
                Error('WhatsApp API error (HTTP %1):\n%2', HttpResponse.HttpStatusCode, ResponseText);
        end;
    end;

    local procedure JsonEscapeText(InputText: Text): Text
    var
        Result: Text;
        i: Integer;
        cv: Integer;
    begin
        Result := '';
        for i := 1 to StrLen(InputText) do begin
            cv := InputText[i];
            case cv of
                34:
                    Result += '\"';
                92:
                    Result += '\\';
                10:
                    Result += '\n';
                13:
                    Result += '\r';
                9:
                    Result += '\t';
                else
                    Result += Format(InputText[i]);
            end;
        end;
        exit(Result);
    end;
}