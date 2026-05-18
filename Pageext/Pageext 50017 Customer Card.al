pageextension 50017 "Customer Card PBS" extends "Customer Card"
{
    layout
    {

    }
    actions
    {
        addafter(Invoices)
        {
            action(SMSSendCustomer)
            {
                ApplicationArea = All;
                Caption = 'SMS Send Customer';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = true;
                Image = SendTo;


                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                    SMSMgmt.SendDealerOnboardSMS(Rec."No.");
                end;
            }
        }
    }
}