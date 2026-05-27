
pageextension 80055 "MY Seeds Customer Card Ext" extends "Customer Card"
{

    actions
    {

        addfirst("&Customer")
        {
            action(SendSalesReturnSMS)
            {
                ApplicationArea = All;
                Caption = 'Send Sales Return SMS';
                ToolTip = 'Send a Sales Return confirmation SMS to this customer using the DLT approved template.';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "MY Seeds SMS Management";
                begin
                    SMSMgmt.SendSalesReturnSMS(Rec."No.");
                end;
            }
        }

        addlast(navigation)
        {
            action(SMSLog)
            {
                ApplicationArea = All;
                Caption = 'SMS Log';
                ToolTip = 'View SMS history sent to this customer.';
                Image = History;
                RunObject = page "MY Seeds SMS Log";
                RunPageLink = "Customer No." = field("No.");
            }
        }
    }
}
