
page 50008 "MY Seeds SMS Setup"
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
                field(Telemarketer; Rec."Telemarketer")
                {
                    ApplicationArea = All;
                    Caption = 'Telemarketer';
                    ToolTip = 'e.g. Vodafone Idea';
                }
                field(PEID; Rec."PE ID")
                {
                    ApplicationArea = All;
                    Caption = 'PE ID';
                    ToolTip = 'Principal Entity ID - used for all templates';
                }

            }
            group(Template1)
            {
                Caption = 'Template Group 1';

                field(TemplateID; Rec."Template ID 1")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 1';
                }
                field(TemplateName; Rec."Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template2)
            {
                Caption = 'Template Group 2';

                field(TemplateID2; Rec."Template ID 2")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 2';
                }
                field(TemplateName2; Rec."Template Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template3)
            {
                Caption = 'Template Group 3';

                field(TemplateID3; Rec."Template ID 3")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 3';
                }
                field(TemplateName3; Rec."Template Name 3")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template4)
            {
                Caption = 'Template Group 4';

                field(TemplateID4; Rec."Template ID 4")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 4';
                }
                field(TemplateName4; Rec."Template Name 4")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template5)
            {
                Caption = 'Template Group 5';

                field(TemplateID5; Rec."Template ID 5")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 5';
                }
                field(TemplateName5; Rec."Template Name 5")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template6)
            {
                Caption = 'Template Group 6';

                field(TemplateID6; Rec."Template ID 6")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 6';
                }
                field(TemplateName6; Rec."Template Name 6")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template7)
            {
                Caption = 'Template Group 7';

                field(TemplateID7; Rec."Template ID 7")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 7';
                }
                field(TemplateName7; Rec."Template Name 7")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }
            group(Template8)
            {
                Caption = 'Template Group 8';

                field(TemplateID8; Rec."Template ID 8")
                {
                    ApplicationArea = All;
                    Caption = 'Template ID 8';
                }
                field(TemplateName8; Rec."Template Name 8")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                }
            }


        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec."Template ID 1" := '1107177571773191312';
            Rec."Sender ID" := 'MYSEED';
            Rec."Telemarketer" := 'Vodafone Idea';
            Rec.Insert();
        end;

        // if not UserSetup.Get(UserId) then
        //     Error('User setup not found');

        // if UserSetup."SMS Message" = false then
        //     Error('You are not authorised to open this page');
    end;
}
