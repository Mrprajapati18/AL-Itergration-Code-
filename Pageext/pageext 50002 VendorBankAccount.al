pageextension 50002 "Vendor Bank Account PBS" extends "Vendor Bank Account Card"
{
    layout
    {
        addafter("Bank Branch No.")
        {
            field("IFSC Code"; Rec."IFSC Code")
            {
                ApplicationArea = All;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}