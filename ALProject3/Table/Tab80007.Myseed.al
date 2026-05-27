
table 80007 "MY Seeds SMS Setup"
{
    Caption = 'MY Seeds SMS Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "SMS Gateway URL"; Text[250])
        {
            Caption = 'SMS Gateway API URL';
            DataClassification = CustomerContent;
        }
        field(3; "API Key"; Text[100])
        {
            Caption = 'API Key';
            DataClassification = CustomerContent;
        }
        field(4; "Sender ID"; Text[20])
        {
            Caption = 'Sender ID (e.g. MYSEED)';
            DataClassification = CustomerContent;
        }
        field(5; "Template ID"; Text[50])
        {
            Caption = 'DLT Template ID';
            DataClassification = CustomerContent;
        }
        field(6; "PE ID"; Text[50])
        {
            Caption = 'Principal Entity (PE) ID';
            DataClassification = CustomerContent;
        }
        field(7; "Telemarketer"; Text[50])
        {
            Caption = 'Telemarketer Name';
            DataClassification = CustomerContent;
        }
        field(8; "Enabled"; Boolean)
        {
            Caption = 'SMS Sending Enabled';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
