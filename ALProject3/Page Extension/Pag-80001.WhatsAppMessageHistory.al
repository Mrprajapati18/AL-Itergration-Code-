page 80003 "WhatsApp Message History"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WhatsApp Message History";
    Caption = 'WhatsApp Message History';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                }
                field("Sent Date"; Rec."Sent Date")
                {
                    ApplicationArea = All;
                }
                field("Sent Time"; Rec."Sent Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Customer")
            {
                ApplicationArea = All;
                Caption = 'View Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."Customer No.") then
                        Page.Run(Page::"Customer Card", Customer);
                end;
            }
        }
    }
}