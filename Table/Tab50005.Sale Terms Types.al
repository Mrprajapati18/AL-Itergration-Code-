table 50005 "Sales Terms Types"
{
    Caption = 'Sales Terms Types';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            ToolTip = 'Specifies the unique entry number for the Sales term. This is auto-generated.';
        }

        field(2; "Sales Terms Type"; Code[100])
        {
            Caption = 'Sales Terms Type';
            NotBlank = true;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the type of Sales term (e.g., PAYMENT TERMS, DELIVERY TERMS).';
        }

        field(3; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a detailed description of the Sales term.';
        }
    }

    keys
    {

        key(PK; "Sales Terms Type")
        {
            Clustered = true;
        }
    }
}
