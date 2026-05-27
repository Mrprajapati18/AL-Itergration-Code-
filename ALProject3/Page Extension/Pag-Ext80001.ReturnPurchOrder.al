pageextension 80005 PurchaseReturnOrderListExt extends "Purchase Return Order List"
{
    layout
    {

    }
    actions
    {
        addbefore("&Return Order")
        {
            action(PrintReport)
            {
                ApplicationArea = All;
                Caption = 'Return Order Print';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                begin
                    PurchHeader.Copy(Rec);

                    if PurchHeader.FindFirst() then
                        Report.RunModal(80028, true, true, PurchHeader);

                end;
            }
        }
    }
}