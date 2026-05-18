
pageextension 50010 "Sales Order SMS PBS" extends "Sales Order"
{
    actions
    {
        addbefore(Invoices)
        {
            action(SendSalesOrderSMS)
            {
                ApplicationArea = All;
                Caption = 'Send to SMS';
                ToolTip = 'Send an Order Confirmation SMS to this customer using Template ID 2 from MY Seeds SMS Setup.';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                    SMSMgmt.SendSalesOrderSMS(Rec."Sell-to Customer No.", Rec."No.");
                end;
            }
        }
    }
    
}

