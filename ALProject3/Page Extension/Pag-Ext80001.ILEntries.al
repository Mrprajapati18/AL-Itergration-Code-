pageextension 80003 ILEntries extends "Item Ledger Entries"
{
    layout
    {
        addafter("Return Reason Code")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                TableRelation = "Reason Code";
            }
        }
    }
}
