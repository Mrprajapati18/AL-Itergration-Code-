
pageextension 50008 "Sale Invoice PBS" extends "Sales Invoice"
{
    layout
    {
        addafter("Invoice Details")
        {
            part("Sale Terms Subform"; "Sale Terms Subform")
            {
                ApplicationArea = All;
                Caption = 'Sale Terms';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage."Sale Terms Subform".Page.SetDocumentNo(Rec."No.");
    end;
}
