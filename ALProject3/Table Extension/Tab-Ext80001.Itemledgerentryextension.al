tableextension 80001 Itemledgerentryextension extends "Item Ledger Entry"
{
    fields
    {
        field(42; "Reason Code"; Code[10]) 
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            
        }
        
    }
}
