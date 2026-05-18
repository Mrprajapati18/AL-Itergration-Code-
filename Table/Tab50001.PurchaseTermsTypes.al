
table 50001 "Purchase Terms Types"
{
    Caption = 'Purchase Terms Types';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            ToolTip = 'Specifies the unique entry number for the purchase term. This is auto-generated.';
        }

        field(2; "Purchase Terms Type"; Code[100])
        {
            Caption = 'Purchase Terms Type';
            NotBlank = true;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the type of purchase term (e.g., PAYMENT TERMS, DELIVERY TERMS).';
        }

        field(3; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a detailed description of the purchase term.';
        }
    }

    keys
    {

        key(PK; "Purchase Terms Type")
        {
            Clustered = true;
        }
    }
}
