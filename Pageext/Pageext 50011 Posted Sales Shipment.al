pageextension 50011 "Posted Sales Shipment SMS PBS" extends "Posted Sales Shipment"
{
    actions
    {
        addfirst(processing)
        {
            action(SendShipmentSMS)
            {
                ApplicationArea = All;
                Caption = 'Send Shipment Notification SMS';
                ToolTip = 'Send a Shipment Notification SMS to this customer using the DLT approved template.';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SMSMgmt: Codeunit "PBS My Seed SMS Management";
                begin
                    SMSMgmt.SendShipmentSMS(Rec."Sell-to Customer No.", Rec."No.");
                end;
            }
        }
    }
}
