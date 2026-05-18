page 50009 "MY Seeds SMS Log"
{
    Caption = 'SMS Log';
    PageType = List;
    SourceTable = "MY Seeds SMS Log";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Sent DateTime"; Rec."Sent DateTime")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                }
                field("Message Sent"; Rec."Message Sent")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                }
                field("Sent By"; Rec."Sent By")
                {
                    ApplicationArea = All;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                field("PE ID"; Rec."PE ID")
                {
                    ApplicationArea = All;
                }
                field("API Response"; Rec."API Response")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Sent:
                StatusStyle := 'Favorable';
            Rec.Status::Failed:
                StatusStyle := 'Unfavorable';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
