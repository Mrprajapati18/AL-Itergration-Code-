pageextension 50016 "Item Journal PBS" extends "Item Journal"
{
    layout
    {

    }
    actions
    {
        addafter("P&osting")
        {
            action(ItemSendSMS)
            {
                ApplicationArea = All;
                Caption = 'SMS Send Item Journal';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = true;
                Image = SendTo;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                    SMSMgmt.SendFisoBisoSMS(Rec."Source No.", Rec."No.");
                    ;
                end;
            }
        }
    }
}