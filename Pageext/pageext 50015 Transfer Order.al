pageextension 50015 "Transfer Order PBS" extends "Transfer Order"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action(SendSMSTransferOder)
            {
                ApplicationArea = All;
                Caption = 'SMS Send Trasfer Order';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = true;
                Image = SendTo;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                   SMSMgmt.SendDispatchChallanSMS(Rec."No.", Rec."No.");
                end;
            }
        }
    }
}