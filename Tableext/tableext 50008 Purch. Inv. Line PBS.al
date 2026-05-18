tableextension 50008 "Purch. Inv. Line PBS" extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; "Product Family Id"; Code[50])
        {
            Caption = 'Product Family Id';
            Editable = false;
        }
        field(50001; "Product Family Name"; Text[100])
        {
            Caption = 'Product Family Name';
            Editable = false;
        }
        field(50003; "Specifice Gravity"; Decimal)
        {
            Caption = 'Specifice Gravity';
            Editable = false;
        }
        field(50004; "Case No."; Text[50])
        {
            Caption = 'Case No.';
            Editable = false;
        }
    }
}
