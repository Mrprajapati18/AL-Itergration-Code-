pageextension 50014 "Sales Return Order PBS" extends "Sales Return Order"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action(SendToSMS)
            {
                ApplicationArea = all;
                Caption = 'Send To SMS';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = true;
                Image = SendTo;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                    SMSMgmt.SendSalesReturnSMS(Rec."Sell-to Customer No.");
                end;
            }
        }
    }
}