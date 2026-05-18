
table 50101 "Piece Dozen Buffer"
{
    DataClassification = ToBeClassified;
    Caption = 'Piece Dozen Buffer';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }

        field(2; "Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qty';
            DecimalPlaces = 0 : 3;
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
