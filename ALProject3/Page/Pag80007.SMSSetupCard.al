page 80007 "SMS Setup Card"
{
    Caption = 'SMS Setup';
    PageType = Card;
    SourceTable = "SMS Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(GeneralGroup)
            {
                Caption = 'General';
                field("SMS Enabled"; Rec."SMS Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable or disable all SMS sending.';
                }
                field("Log All SMS"; Rec."Log All SMS")
                {
                    ApplicationArea = All;
                    ToolTip = 'Log every SMS attempt in the SMS Log table.';
                }
                field("Timeout Seconds"; Rec."Timeout Seconds")
                {
                    ApplicationArea = All;
                }
            }
            group(GatewayGroup)
            {
                Caption = 'Gateway Configuration';
                field("Gateway Provider"; Rec."Gateway Provider")
                {
                    ApplicationArea = All;
                    ToolTip = 'Your SMS provider: MSG91, Textlocal, Exotel, or Custom.';
                }
                field("API URL"; Rec."API URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Full API endpoint URL from your provider.';
                }
                field("Auth Key / API Key"; Rec."Auth Key / API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'API Key or Auth Key from your SMS provider dashboard.';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = '6-character DLT approved Sender ID (e.g. MYSEED).';
                }
                field("DLT Entity ID"; Rec."DLT Entity ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Your company DLT Entity ID registered on JIO/Airtel/BSNL portal.';
                }
            }
            group(SalesReturnTemplateGroup)
            {
                Caption = 'Sales Return Template';
                field("Sales Return Template ID"; Rec."Sales Return Template ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'DLT Template ID: 1107177571773191312';
                }
                field("Max Variety Lines in SMS"; Rec."Max Variety Lines in SMS")
                {
                    ApplicationArea = All;
                    ToolTip = 'How many item lines to include. Template supports 4 lines.';
                }
                field("Sales Return Template Text"; Rec."Sales Return Template Text")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Exact template text from DLT portal with {#alphanumeric#} placeholders.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestSMS)
            {
                Caption = 'Send Test SMS';
                ApplicationArea = All;
                Image = TestDatabase;
                trigger OnAction()
                var
                    SMSSender: Codeunit "SMS Sender";
                    TestMobile: Text;
                    TestMsg: Text;
                    Success: Boolean;
                begin
                    TestMobile := '';
                    // if not InputDialog('Test SMS', 'Enter mobile number (10 digits):', TestMobile) then
                    //     exit;
                    TestMsg := 'Dear Test Customer, Sales return against invoice TEST-001 for Variety TEJA 8KG, TOMATO MAYA 32KG, MAIZE SUPER 6KG PADDY ANAND 32KG has been received and confirmed -MY SEEDS';

                    Success := SMSSender.SendDLTMessage(
                        TestMobile, TestMsg,
                        Rec."Sales Return Template ID",
                        'TEST', '', 'Test Customer'
                    );

                    if Success then
                        Message('Test SMS sent successfully to %1.\n\nCheck SMS Log for delivery status.', TestMobile)
                    else
                        Message('Test SMS failed. Check SMS Log for error details.');
                end;
            }

            action(ViewSMSLog)
            {
                Caption = 'View SMS Log';
                ApplicationArea = All;
                Image = Log;
                RunObject = page "SMS Log List";
            }

            action(InitDefaults)
            {
                Caption = 'Insert Default Setup';
                ApplicationArea = All;
                Image = Setup;
                trigger OnAction()
                begin
                    if not Rec.Get('') then begin
                        Rec.Init();
                        Rec."Primary Key" := '';
                        Rec."SMS Enabled" := false;
                        Rec."Log All SMS" := true;
                        Rec."Timeout Seconds" := 30;
                        Rec."Max Variety Lines in SMS" := 4;
                        Rec."Sender ID" := 'MYSEED';
                        Rec."Sales Return Template ID" := '1107177571773191312';
                        Rec."Sales Return Template Text" :=
                            'Dear {#alphanumeric#}, Sales return against invoice {#alphanumeric#} for Variety {#alphanumeric#}, {#alphanumeric#}, {#alphanumeric#} {#alphanumeric#} has been received and confirmed -MY SEEDS';
                        Rec.Insert();
                        Message('Default setup created. Now fill in your API URL, Auth Key, and DLT Entity ID.');
                    end else
                        Message('Setup already exists.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert();
        end;
    end;
}
