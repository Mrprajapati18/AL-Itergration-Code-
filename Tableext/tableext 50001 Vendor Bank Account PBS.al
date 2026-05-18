tableextension 50001 "Vendor Bank Account PBS" extends "Vendor Bank Account"
{
    fields
    {
        field(50000; "IFSC Code"; Code[50])
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
