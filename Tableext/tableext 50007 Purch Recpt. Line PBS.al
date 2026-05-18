tableextension 50007 "Purch. Rcpt. Line PBS" extends "Purch. Rcpt. Line"
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
