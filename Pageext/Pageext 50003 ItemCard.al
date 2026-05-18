
pageextension 50003 "Item Card PBS" extends "Item Card"
{
    layout
    {
        addafter("Base Unit of Measure")
        {

            field("Product Family Id"; Rec."Product Family Id")
            {
                ApplicationArea = All;
                Caption =  'Product Family Id';
            }
            field("Product Family Name"; Rec."Product Family Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
           
        }
    }
}
