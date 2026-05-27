table 80001 "WhatsApp Setup"
{
    Caption = 'WhatsApp Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
            
            
        }
        field(2; "API Key"; Text[250])
        {
            Caption = 'API Key';
            DataClassification = ToBeClassified;
        }
        field(3; "Template Name"; Text[50])
        {
            Caption = 'Template Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    
}