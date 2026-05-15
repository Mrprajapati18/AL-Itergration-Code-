

codeunit 50010 "PBS Stock Transfer Email Mgt"
{
    procedure SendStockTransferShipmentEmail(ShipmentNo: Code[20])
    var
        TransferShipHeader: Record "Transfer Shipment Header";
        TransferShipHeaderRpt: Record "Transfer Shipment Header";
        ToLocation: Record Location;
        CompanyInfo: Record "Company Information";
        EmailAccount: Record "Email Account";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailScenario: Codeunit "Email Scenario";
        TempBlob: Codeunit "Temp Blob";
        ReportOutStream: OutStream;
        AttachmentInStream: InStream;
        ToEmail: List of [Text];
        DestinationEmail: Text;
        SubjectTxt: Text;
        BodyTxt: Text;
        AttachmentName: Text;
    begin
        if not TransferShipHeader.Get(ShipmentNo) then
            Error('Transfer Shipment %1 not found.', ShipmentNo);

        CompanyInfo.Get();

        if TransferShipHeader."Transfer-to Code" = '' then
            Error('Transfer To Location is blank.');

        if not ToLocation.Get(TransferShipHeader."Transfer-to Code") then
            Error('Location %1 not found.', TransferShipHeader."Transfer-to Code");

        DestinationEmail := ToLocation."E-Mail";
        if DestinationEmail = '' then
            Error('Email is blank in Location Card %1.', ToLocation.Code);

        ToEmail.Add(DestinationEmail);

        // Report 50015 PDF generate 
        AttachmentName := StrSubstNo('Transfer_Shipment_%1.pdf', ShipmentNo);
        TempBlob.CreateOutStream(ReportOutStream);
        TransferShipHeaderRpt.SetRange("No.", ShipmentNo);

        Report.SaveAs(50015, '', ReportFormat::Pdf, ReportOutStream, TransferShipHeaderRpt);
        if not EmailScenario.GetEmailAccount(
                Enum::"Email Scenario"::Default, EmailAccount) then
            Error('No default email account found. Please set up Email Account in BC.');

        SubjectTxt := StrSubstNo('Stock Transfer Shipment - %1', TransferShipHeader."No.");
        BodyTxt :=
            '<html><body>' +
            '<p>Dear Team,</p>' +
            '<p>Please find the attached Stock Transfer Shipment report.</p>' +
            '<table border="1" cellpadding="5" cellspacing="0">' +
            '<tr><td><b>Shipment No.</b></td><td>' + TransferShipHeader."No." + '</td></tr>' +
            '<tr><td><b>Transfer Order No.</b></td><td>' + TransferShipHeader."Transfer Order No." + '</td></tr>' +
            '<tr><td><b>From Location</b></td><td>' + TransferShipHeader."Transfer-from Code" + '</td></tr>' +
            '<tr><td><b>To Location</b></td><td>' + TransferShipHeader."Transfer-to Code" + '</td></tr>' +
            '<tr><td><b>Posting Date</b></td><td>' + Format(TransferShipHeader."Posting Date") + '</td></tr>' +
            '</table>' +
            '<br/><p>Regards,<br/>' + CompanyInfo.Name + '</p>' +
            '</body></html>';

        EmailMessage.Create(ToEmail, SubjectTxt, BodyTxt, true);

        TempBlob.CreateInStream(AttachmentInStream);
        EmailMessage.AddAttachment(AttachmentName, 'application/pdf', AttachmentInStream);
        Email.Send(EmailMessage, EmailAccount);
        Message('Email with PDF sent successfully to %1.', DestinationEmail);
    end;
}