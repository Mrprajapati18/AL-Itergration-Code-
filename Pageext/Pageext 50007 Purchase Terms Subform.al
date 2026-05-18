
pageextension 50007 "Purchase Invoice PBS" extends "Purchase Invoice"
{
    layout
    {
        addafter("Invoice Details")
        {
            part("Purchase Terms Subform"; "Purchase Terms Subform")
            {
                ApplicationArea = All;
                Caption = 'Purchase Terms';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage."Purchase Terms Subform".Page.SetDocumentNo(Rec."No.");
    end;
}
