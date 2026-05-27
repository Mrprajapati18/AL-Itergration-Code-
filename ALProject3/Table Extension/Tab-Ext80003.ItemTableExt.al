tableextension 80003 "Item Table Ext" extends Item
{
    fields
    {
        field(80100; "Specific Gravity"; Decimal)
        {
            Caption = 'Specific Gravity';
            DataClassification = CustomerContent;
        }
        field(80101; "CAS Number"; Code[20])
        {
            Caption = 'CAS Number';
            DataClassification = CustomerContent;
        }
        field(80102; "Product Family Code"; Code[20])
        {
            Caption = 'Product Family Code';
            DataClassification = CustomerContent;
        }
        field(80103; "Product Family Name"; Text[100])
        {
            Caption = 'Product Family Name';
            DataClassification = CustomerContent;
        }
    }
}