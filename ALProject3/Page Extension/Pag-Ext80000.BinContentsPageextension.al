pageextension 80002 BinContentsPageextension extends "Bin Contents"
{
    layout
    {
        addafter("Bin Type Code")
        {
            field("Physical Address"; Rec."Physical Address")
            {
                ApplicationArea = All;
            }
        }
    }
}


