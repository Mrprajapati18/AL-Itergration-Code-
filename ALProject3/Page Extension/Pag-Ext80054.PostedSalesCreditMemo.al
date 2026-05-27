pageextension 80054 "Posted Sales Cr. Memo SMS Ext" extends "Posted Sales Credit Memo"
{
    actions
    {
        addafter(Print)
        {
            action(SendSMSManual)
            {
                Caption = 'Send Return SMS';
                ApplicationArea = All;
                Image = SendMail;
                ToolTip = 'Manually send the sales return confirmation SMS to the customer.';

                trigger OnAction()
                var
                    SalesReturnSMSMgt: Codeunit "Sales Return SMS Mgt.";
                begin
                    SalesReturnSMSMgt.SendSalesReturnSMS(Rec);
                    Message('SMS sent successfully to customer %1.', Rec."Sell-to Customer Name");
                end;
            }

            action(ViewSMSLog)
            {
                Caption = 'SMS Log';
                ApplicationArea = All;
                Image = Log;
                RunObject = page "SMS Log List";
                RunPageLink = "Document No." = field("No.");
                ToolTip = 'View all SMS sent for this credit memo.';
            }
        }
    }
}
