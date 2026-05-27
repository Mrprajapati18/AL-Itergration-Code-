
pageextension 80006 "Send WhatsApp" extends "Customer List"
{
    layout
    {
    }

    actions
    {
        addbefore("&Customer")
        {
            action(SendWhatsAppReminder)
            {
                ApplicationArea = All;
                Caption = 'WhatsApp Msg';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                Image = SendTo;
                ToolTip = 'Send a WhatsApp payment reminder to the selected customer.';

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                    CleanPhone: Text;
                    InvoiceNo: Text;
                    ServiceDesc: Text;
                    AmountText: Text;
                    DueDateText: Text;
                    i: Integer;
                begin
                    if Rec."Phone No." = '' then
                        Error('Phone Number is not registered for Customer "%1".\nPlease update the Phone No. in the Customer Card first.', Rec.Name);

                    CleanPhone := '';
                    for i := 1 to StrLen(Rec."Phone No.") do
                        if Rec."Phone No."[i] in ['0' .. '9'] then
                            CleanPhone += Format(Rec."Phone No."[i]);

                    if StrLen(CleanPhone) = 10 then
                        CleanPhone := '91' + CleanPhone
                    else if (StrLen(CleanPhone) = 12) and (CopyStr(CleanPhone, 1, 2) = '91') then
                        CleanPhone := '91' + CopyStr(CleanPhone, 3, 10)
                    else
                        Error('Phone number "%1" format is incorrect.\nPlease enter a 10-digit mobile number (without country code).', Rec."Phone No.");

                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                    CustLedgerEntry.SetRange(Open, true);
                    CustLedgerEntry.SetCurrentKey("Due Date");

                    if not CustLedgerEntry.FindFirst() then
                        Error('No outstanding invoice found for Customer "%1".', Rec.Name);

                    InvoiceNo := CustLedgerEntry."Document No.";
                    CustLedgerEntry.CalcFields("Remaining Amount");
                    AmountText := Format(Abs(CustLedgerEntry."Remaining Amount"), 0, '<Integer Thousand><Decimals,2>');
                    DueDateText := Format(CustLedgerEntry."Due Date", 0, '<Day,2> <Month Text> <Year4>');
                    ServiceDesc := CustLedgerEntry.Description;

                    if ServiceDesc = '' then
                        ServiceDesc := 'Products/Services';

                    Message('Sending WhatsApp reminder to %1 (%2)...', Rec.Name, CleanPhone);

                    SendViaLeminAI(Rec."No.", CleanPhone, InvoiceNo, Rec.Name, AmountText, ServiceDesc, DueDateText);
                end;
            }
        }
    }

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

    local procedure SendViaLeminAI(
        CustomerNo: Code[20];
        PhoneNo: Text;
        InvoiceNo: Text;
        CustName: Text;
        Amount: Text;
        ServiceDesc: Text;
        DueDate: Text)
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        JsonBody: Text;
        ApiKey: Text;
        TemplateName: Text;
        TemplateLang: Text;
        ResponseText: Text;
        RequestUrl: Text;
        WhatsAppHistory: Record "WhatsApp Message History";
        WhatsAppSetup: Record "WhatsApp Setup";
        FullMessage: Text;
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
        TemplateLang := 'en_US';
        JsonBody :=
            '{' +
            '"token":"' + JsonEscapeText(ApiKey) + '",' +
            '"phone":"' + JsonEscapeText(PhoneNo) + '",' +
            '"template_name":"' + JsonEscapeText(TemplateName) + '",' +
            '"template_language":"' + JsonEscapeText(TemplateLang) + '",' +
            '"components":[' +
              '{' +
                '"type":"body",' +
                '"parameters":[' +
                  '{"type":"text","text":"' + JsonEscapeText(InvoiceNo) + '"},' +
                  '{"type":"text","text":"' + JsonEscapeText(CustName) + '"},' +
                  '{"type":"text","text":"' + JsonEscapeText(Amount) + '"},' +
                  '{"type":"text","text":"' + JsonEscapeText(ServiceDesc) + '"},' +
                  '{"type":"text","text":"' + JsonEscapeText(DueDate) + '"}' +
                ']' +
              '}' +
            ']' +
            '}';


        RequestUrl := 'https://chat.leminai.com/api/wpbox/sendtemplatemessage';

        HttpContent.WriteFrom(JsonBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        HttpRequest.Method := 'POST';
        HttpRequest.SetRequestUri(RequestUrl);
        HttpRequest.Content := HttpContent;

        if not HttpClient.Send(HttpRequest, HttpResponse) then
            Error('Failed to connect to the WhatsApp API. Please check your internet connection.');

        HttpResponse.Content.ReadAs(ResponseText);

        FullMessage := 'Invoice: ' + InvoiceNo + ' | Customer: ' + CustName + ' | Amount: Rs.' + Amount + ' | Service: ' + ServiceDesc +
        ' | Due: ' + DueDate;

        WhatsAppHistory.Init();
        WhatsAppHistory."Customer No." := CustomerNo;
        WhatsAppHistory."Phone No." := PhoneNo;
        WhatsAppHistory."Invoice No." := InvoiceNo;
        WhatsAppHistory.Message := FullMessage;
        WhatsAppHistory."Sent Date" := Today;
        WhatsAppHistory."Sent Time" := Time;
        WhatsAppHistory."User ID" := UserId;
        WhatsAppHistory.Response := ResponseText;

        if HttpResponse.IsSuccessStatusCode then
            WhatsAppHistory.Status := WhatsAppHistory.Status::Sent
        else
            WhatsAppHistory.Status := WhatsAppHistory.Status::Failed;

        WhatsAppHistory.Insert();

        if HttpResponse.IsSuccessStatusCode then
            Message(' WhatsApp message sent successfully to %1.', PhoneNo)
        else
            Error('WhatsApp API error (HTTP %1):\n%2', HttpResponse.HttpStatusCode, ResponseText);
    end;
}