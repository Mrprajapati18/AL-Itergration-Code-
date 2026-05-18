table 50010 "Dozen Decimal Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Dozen Decimal Setup';

    fields
    {
        field(1; "Pieces"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Pieces';
            MinValue = 1;
            MaxValue = 12;
        }
        field(2; "Decimal Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Decimal Value';
            DecimalPlaces = 0 : 3;
            MinValue = 0;
            ToolTip = 'Exact decimal value e.g. 0.083 for 1 piece, 0.17 for 2 pieces';
        }
    }

    keys
    {
        key(PK; "Pieces")
        {
            Clustered = true;
        }
        key(IDX_DecimalValue; "Decimal Value") { }
    }
}