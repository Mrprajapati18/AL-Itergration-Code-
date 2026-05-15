pageextension 50018 "PBS Transfer Order Ext" extends "Posted Transfer Shipment"
{
    actions
    {
        addafter("&Print")
        {
            action("Send STO Email")
            {
                ApplicationArea = All;
                Caption = 'Send STO Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EmailMgmt: Codeunit "PBS Stock Transfer Email Mgt";
                begin

                    EmailMgmt.SendStockTransferShipmentEmail(Rec."No.");
                end;
            }
        }
    }
}
