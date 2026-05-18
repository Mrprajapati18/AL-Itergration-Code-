pageextension 50006 "Trans. Receipt Lines PBS" extends "Posted Transfer Receipt Lines"
{
    layout
    {
        addafter("Item No.")
        {
            field("Product Family Id"; Rec."Product Family Id")
            {
                ApplicationArea = All;
                Caption = 'Product Family';
                Editable = false;
                ToolTip = 'Specifies the Product Family of the Item.';
            }
            field("Product Family Name"; Rec."Product Family Name")
            {
                ApplicationArea = All;
                Caption = 'Product Family Name';
                Editable = false;
                ToolTip = 'Specifies the Product Family Name of the Item.';
            }
            field("Specfice Gravity"; Rec."Specfice Gravity")
            {
                ApplicationArea = All;
                Caption = 'Specfice Gravity';
                Editable = false;
            }
            field("Case No."; Rec."Case No.")
            {
                ApplicationArea = All;
                Caption = 'Case No.';
                Editable = false;
            }
        }
    }
}