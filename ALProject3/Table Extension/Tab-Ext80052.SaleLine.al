tableextension 80002 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50200; Priority; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Priority';
        }
    }
}