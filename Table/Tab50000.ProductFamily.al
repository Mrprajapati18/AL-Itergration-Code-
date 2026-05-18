table 50000 ProductFamily
{
    Caption = 'ProductFamily';
    DataClassification = ToBeClassified;

    
    fields
    {
        field(1; "Product Family Id"; Code[50])
        {
            Caption = 'Product Family';
        }
        field(2; "Product Family Name"; Text[100])
        {
            Caption = 'Product Family Name';
        }
        field(3; "Specific Gravity"; Decimal)
        {
           Caption = 'Specific Gravity';
        }
        field(4; "Case No."; Text[50])
        {
            Caption = 'Case No.';
        }
        
    }
    keys
    {
        key(PK; "Product Family Id")
        {
            Clustered = true;
        }
    }
}
