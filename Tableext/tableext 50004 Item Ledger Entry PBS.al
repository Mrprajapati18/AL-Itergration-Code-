tableextension 50004 "Item Ledger Entry PBS" extends "Item Ledger Entry"
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
        field(50002; "Specifice Gravity"; Decimal)
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
