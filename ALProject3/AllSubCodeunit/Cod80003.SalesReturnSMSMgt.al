codeunit 80003 "Sales Return SMS Mgt."
{
    procedure SendSalesReturnSMS(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        SMSSetup: Record "SMS Setup";
        Customer: Record Customer;
        SMSSender: Codeunit "SMS Sender";
        MobileNo: Text;
        FinalMessage: Text;
    begin
        if not SMSSetup.Get('') then exit;
        if not SMSSetup."SMS Enabled" then exit;


        MobileNo := GetCustomerMobile(SalesCrMemoHeader);
        if MobileNo = '' then begin

            Session.LogMessage('0000SMS',
                StrSubstNo('SMS skipped for Credit Memo %1 — no mobile number on customer %2',
                    SalesCrMemoHeader."No.", SalesCrMemoHeader."Sell-to Customer No."),
                Verbosity::Warning, DataClassification::CustomerContent,
                TelemetryScope::ExtensionPublisher, 'Category', 'SMS');
            exit;
        end;

        // Build the final message text
        FinalMessage := BuildSalesReturnMessage(SalesCrMemoHeader, SMSSetup);
        if FinalMessage = '' then exit;

        // Send!
        SMSSender.SendDLTMessage(
            MobileNo,
            FinalMessage,
            SMSSetup."Sales Return Template ID",
            SalesCrMemoHeader."No.",
            SalesCrMemoHeader."Sell-to Customer No.",
            SalesCrMemoHeader."Sell-to Customer Name"
        );
    end;


    local procedure BuildSalesReturnMessage(
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SMSSetup: Record "SMS Setup"
    ): Text
    var
        MessageText: Text;
        VarietyLines: List of [Text];
        VarietyLine: Text;
        PaddedLines: List of [Text];
        i: Integer;
        MaxLines: Integer;
        OriginalInvoiceNo: Code[20];
    begin
        // Get the DLT approved template from setup
        MessageText := SMSSetup."Sales Return Template Text";
        if MessageText = '' then begin

            MessageText := 'Dear {#alphanumeric#}, Sales return against invoice {#alphanumeric#} for Variety {#alphanumeric#}, {#alphanumeric#}, {#alphanumeric#} {#alphanumeric#} has been received and confirmed -MY SEEDS';
        end;


        MessageText := ReplaceFirst(MessageText, '{#alphanumeric#}',
            SalesCrMemoHeader."Sell-to Customer Name");

        OriginalInvoiceNo := GetOriginalInvoiceNo(SalesCrMemoHeader);
        MessageText := ReplaceFirst(MessageText, '{#alphanumeric#}', OriginalInvoiceNo);

        VarietyLines := GetVarietyLines(SalesCrMemoHeader, SMSSetup."Max Variety Lines in SMS");


        MaxLines := 4;
        for i := 1 to MaxLines do begin
            if i <= VarietyLines.Count() then
                PaddedLines.Add(VarietyLines.Get(i))
            else
                PaddedLines.Add('-');
        end;


        foreach VarietyLine in PaddedLines do
            MessageText := ReplaceFirst(MessageText, '{#alphanumeric#}', VarietyLine);

        exit(MessageText);
    end;
    // GET VARIETY LINES from Credit Memo
    local procedure GetVarietyLines(
     SalesCrMemoHeader: Record "Sales Cr.Memo Header";
     MaxLines: Integer
 ): List of [Text]
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VarietyLines: List of [Text];
        LineText: Text;
        UOMText: Text;
        QtyText: Text;
    begin
        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        SalesCrMemoLine.SetFilter(Type, '%1', SalesCrMemoLine.Type::Item);
        SalesCrMemoLine.SetFilter(Quantity, '>0');

        if SalesCrMemoLine.FindSet() then
            repeat

                QtyText := Format(SalesCrMemoLine.Quantity, 0, '<Integer>');
                UOMText := SalesCrMemoLine."Unit of Measure Code";


                LineText := UpperCase(SalesCrMemoLine.Description) + ' ' + QtyText + UOMText;

                VarietyLines.Add(CopyStr(LineText, 1, 50));

                if VarietyLines.Count() >= MaxLines then
                    SalesCrMemoLine.Next(SalesCrMemoLine.Count);

            until SalesCrMemoLine.Next() = 0;

        exit(VarietyLines);
    end;


    local procedure GetOriginalInvoiceNo(SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Code[20]
    var
        ReturnReceiptLine: Record "Return Receipt Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin

        if SalesCrMemoHeader."Applies-to Doc. No." <> '' then
            exit(SalesCrMemoHeader."Applies-to Doc. No.");


        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        SalesCrMemoLine.SetFilter(Type, '%1', SalesCrMemoLine.Type::Item);
        if SalesCrMemoLine.FindFirst() then
            if SalesCrMemoLine."No." <> '' then
                exit(SalesCrMemoLine."No.");

        exit(SalesCrMemoHeader."No.");
    end;


    local procedure GetCustomerMobile(SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Text
    var
        Customer: Record Customer;
        MobileNo: Text;
    begin
        if not Customer.Get(SalesCrMemoHeader."Sell-to Customer No.") then
            exit('');
        MobileNo := Customer."Phone No.";
        if MobileNo <> '' then exit(CleanPhone(MobileNo));

        exit('');
    end;

    local procedure CleanPhone(PhoneNo: Text): Text
    begin

        PhoneNo := PhoneNo.Replace('+', '').Replace(' ', '').Replace('-', '')
                          .Replace('(', '').Replace(')', '');

        if PhoneNo.StartsWith('91') and (StrLen(PhoneNo) = 12) then
            PhoneNo := PhoneNo.Substring(3);
        if PhoneNo.StartsWith('0') then
            PhoneNo := PhoneNo.Substring(2);
        exit(PhoneNo);
    end;

    local procedure ReplaceFirst(InputText: Text; FindText: Text; ReplaceWith: Text): Text
    var
        Position: Integer;
    begin
        Position := StrPos(InputText, FindText);
        if Position = 0 then exit(InputText);

        exit(
            CopyStr(InputText, 1, Position - 1) +
            ReplaceWith +
            CopyStr(InputText, Position + StrLen(FindText))
        );
    end;
}

