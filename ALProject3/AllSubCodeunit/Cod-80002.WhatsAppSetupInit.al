codeunit 80005 "WhatsApp Setup Init"
{
    trigger OnRun()
    var
        WhatsAppSetup: Record "WhatsApp Setup";
    begin
        if not WhatsAppSetup.Get('DEFAULT') then begin
            WhatsAppSetup.Init();
            WhatsAppSetup."Primary Key" := 'DEFAULT';
            WhatsAppSetup."API Key" := '8o4RgbkWZdm5NcidrDOU0ZbNJ1tM6ilipAimWOtPfd5c3120';
            WhatsAppSetup."Template Name" := 'payment_reminder';
            WhatsAppSetup.Insert();
            Message('WhatsApp Setup initialized with provided API Key and Template Name.');
        end else begin
            Message('WhatsApp Setup already exists.');
        end;
    end;
}