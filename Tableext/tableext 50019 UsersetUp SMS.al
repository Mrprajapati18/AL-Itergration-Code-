tableextension 50019 "User SetUp SMS PBS" extends "User Setup"
{
    fields
    {
        field(50001; "SMS Message"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'SMS Message';
        }
    }
}