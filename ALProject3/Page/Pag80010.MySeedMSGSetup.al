
page 80010 "MY Seeds SMS Setup"
{
    Caption = 'MY Seeds SMS Setup';
    PageType = Card;
    SourceTable = "MY Seeds SMS Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'SMS Gateway Configuration';

                field(Enabled; Rec."Enabled")
                {
                    ApplicationArea = All;
                    Caption = 'Enable SMS Sending';
                    ToolTip = 'Enable or disable SMS sending from Business Central';
                }
                field(SMSGatewayURL; Rec."SMS Gateway URL")
                {
                    ApplicationArea = All;
                    Caption = 'SMS Gateway API URL';
                    ToolTip = 'Full API URL of your SMS provider (e.g. Vodafone Idea / 2Factor / Textlocal)';
                }
                field(APIKey; Rec."API Key")
                {
                    ApplicationArea = All;
                    Caption = 'API Key / Auth Token';
                    ExtendedDatatype = Masked;
                }
                field(SenderID; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    Caption = 'Sender ID';
                    
                }
                field(TemplateID; Rec."Template ID")
                {
                    ApplicationArea = All;
                    Caption = 'DLT Template ID';
                    ToolTip = 'e.g. 1107177571773191312';
                }
                field(PEID; Rec."PE ID")
                {
                    ApplicationArea = All;
                    Caption = 'PE ID (Principal Entity ID)';
                }
                field(Telemarketer; Rec."Telemarketer")
                {
                    ApplicationArea = All;
                    Caption = 'Telemarketer';
                    ToolTip = 'e.g. Vodafone Idea';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec."Template ID" := '1107177571773191312';
            Rec."Sender ID" := 'MYSEED';
            Rec."Telemarketer" := 'Vodafone Idea';
            Rec.Insert();
        end;
    end;
}
