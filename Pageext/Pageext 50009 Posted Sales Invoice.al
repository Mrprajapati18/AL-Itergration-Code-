
pageextension 50009 "Posted Sales Invoice PBS" extends "Posted Sales Invoice"
{

    actions
    {

        addfirst(Invoice)
        {
            action(SendSalesReturnSMS)
            {
                ApplicationArea = All;
                Caption = 'Send Sales Return SMS';
                ToolTip = 'Send a Sales Return confirmation SMS to this customer using the DLT approved template.';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                    SMSMgmt.SendSalesInvoiceSMS(Rec."Sell-to Customer No.", Rec."No.");
                end;
            }
        }
    }
}


