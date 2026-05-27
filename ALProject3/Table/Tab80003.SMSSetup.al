
table 80003 "SMS Setup"
{
    Caption = 'SMS Setup';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        
        field(10; "Gateway Provider"; Enum "SMS Gateway Provider")
        {
            Caption = 'Gateway Provider';
            
        }
        field(11; "API URL"; Text[250])
        {
            Caption = 'API URL';
        }
        field(12; "Auth Key / API Key"; Text[500])
        {
            Caption = 'Auth Key / API Key';
            ExtendedDatatype = Masked;
        }
        field(13; "Sender ID"; Code[20])
        {
            Caption = 'Sender ID';
          
        }

        field(20; "DLT Entity ID"; Text[100])
        {
            Caption = 'DLT Entity ID';
            
        }

        field(30; "Sales Return Template ID"; Text[50])
        {
            Caption = 'Sales Return Template ID';
            // 1107177571773191312
        }
        field(31; "Sales Return Template Text"; Text[1000])
        {
            Caption = 'Sales Return Template Text';
            // Exact DLT approved template text with {#alphanumeric#}
        }
        field(40; "SMS Enabled"; Boolean)
        {
            Caption = 'SMS Enabled';
            InitValue = false;
        }
        field(41; "Log All SMS"; Boolean)
        {
            Caption = 'Log All SMS';
            InitValue = true;
        }
        field(42; "Max Variety Lines in SMS"; Integer)
        {
            Caption = 'Max Variety Lines in SMS';
            InitValue = 4;
            
        }
        field(43; "Timeout Seconds"; Integer)
        {
            Caption = 'Timeout (seconds)';
            InitValue = 30;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure GetSetup(): Record "SMS Setup"
    var
        SMSSetup: Record "SMS Setup";
    begin
        if not SMSSetup.Get('') then
            Error('SMS Setup not configured. Please fill in the SMS Setup page first.');
        if not SMSSetup."SMS Enabled" then
            Error('SMS is currently disabled. Enable it from SMS Setup page.');
        exit(SMSSetup);
    end;
}


