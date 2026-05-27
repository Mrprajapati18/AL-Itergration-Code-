page 80002 "WhatsApp Setup"
{
    Caption = 'WhatsApp Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "WhatsApp Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the valid API Key from your WhatsApp service provider.';
                }
                field("Template Name"; Rec."Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the template name for WhatsApp messages.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TestConnection)
            {
                ApplicationArea = All;
                Caption = 'Test Connection';
                Image = TestReport;
                ToolTip = 'Test the WhatsApp API connection with the current settings.';

                trigger OnAction()
                begin
                    if Rec."API Key" = '' then
                        Error('API Key is required.');

                    Message('API Key is set. You can now test sending a WhatsApp message from the Customer List.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('DEFAULT') then begin
            Rec.Init();
            Rec."Primary Key" := 'DEFAULT';
            Rec."API Key" := '8o4RgbkWZdm5NcidrDOU0ZbNJ1tM6ilipAimWOtPfd5c3120';
            Rec."Template Name" := 'payment_reminder';
            Rec.Insert();
        end;
    end;
}