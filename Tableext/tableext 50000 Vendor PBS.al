tableextension 50000 "Vendor PBS" extends Vendor
{
    fields
    {
        field(50000; "Udyam Reg No"; Code[20])
        {
            trigger OnValidate()
            begin
                if Rec."Udyam Reg No" <> '' then "MSME Vendor":=true
                else if Rec."Udyam Reg No" = '' then "MSME Vendor":=false;
            end;
        }
        field(50001; "Type of Enterprise"; Option)
        {
            OptionMembers = " ", MICRO, SMALL, MEDIUM, LARGE, NA;
        }
        field(50002; "Major Activity"; Option)
        {
            OptionMembers = " ", MANUFACTURER, RETAILER, TRADER, WHOLESALER, SERVICE, NA;
        }
        field(50003; "Turnover"; Decimal)
        {
        }
        field(50005; "MSME Vendor"; Boolean)
        {
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
}
