
page 80008 "SMS Log List"
{
    Caption = 'SMS Log';
    PageType = List;
    SourceTable = "SMS Log";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

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
                field("Sent At"; Rec."Sent At")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                }
                field(Success; Rec.Success)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                }
                field("HTTP Status"; Rec."HTTP Status")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                }
                field("Message Sent"; Rec."Message Sent")
                {
                    ApplicationArea = All;
                }
                field("Message ID (Gateway)"; Rec."Message ID (Gateway)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Resend)
            {
                Caption = 'Resend SMS';
                ApplicationArea = All;
                Image = SendMail;
                trigger OnAction()
                var
                    SMSSender: Codeunit "SMS Sender";
                begin
                    if Rec."Mobile No." = '' then begin
                        Error('No mobile number on this log entry.');
                    end;
                    if Confirm('Resend SMS to %1 (%2)?', true, Rec."Customer Name", Rec."Mobile No.") then
                        SMSSender.SendRaw(Rec."Mobile No.", Rec."Message Sent", Rec."Template ID", Rec."Document No.");
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        // StatusStyle := (if Rec.Success then 'Favorable' else 'Unfavorable');
    end;
}
