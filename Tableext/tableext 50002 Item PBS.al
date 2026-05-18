tableextension 50002 "Item PBS" extends Item
{
    fields
    {
        field(50000; "Product Family Id"; Code[50])
        {
            Caption = 'Product Family';

            trigger OnValidate()
            var
                ProductFamilyRec: Record ProductFamily;
            begin
                if Rec."Product Family Id" = '' then begin
                    Rec."Product Family Name":='';
                    exit;
                end;
                ProductFamilyRec.Get(Rec."Product Family Id");
                Rec."Product Family Id":=ProductFamilyRec."Product Family Id";
                Rec."Product Family Name":=ProductFamilyRec."Product Family Name";
            end;
        }
        field(50001; "Product Family Name"; Text[100])
        {
            Caption = 'Product Family Name';
            Editable = false;
        }
    }
}
