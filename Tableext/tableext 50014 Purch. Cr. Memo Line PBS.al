tableextension 50014 "Purch. Cr. Memo Line PBS" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; "Product Family Id"; Code[50])
        {
            Caption = 'Product Family';
            Editable = false;
        }
        field(50001; "Product Family Name"; Text[100])
        {
            Caption = 'Product Family Name';
            Editable = false;
        }
        field(50003; "Specifice Gravity"; Decimal)
        {
            Caption = 'Specfice Gravity';
            Editable = false;
        }
        field(50004; "Case No."; Text[50])
        {
            Caption = 'Case No.';
            Editable = false;
        }
    }
}
