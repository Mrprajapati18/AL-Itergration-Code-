
table 50007 "MY Seeds SMS Setup"
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
        field(5; "Template ID 1"; Text[50])
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
        field(9; "Template Name"; Text[100])
        {
            Caption = 'Template Name';
            DataClassification = CustomerContent;
        }
        field(10; "Template ID 2"; Text[50])
        {
            Caption = 'DLT Template ID 2';
            DataClassification = CustomerContent;
        }
        field(11; "Template Name 2"; Text[100])
        {
            Caption = 'Template Name 2';
            DataClassification = CustomerContent;
        }
        field(12; "Template ID 3"; Text[50])
        {
            Caption = 'DLT Template ID 3';
            DataClassification = CustomerContent;
        }
        field(13; "Template Name 3"; Text[100])
        {
            Caption = 'Template Name 3';
            DataClassification = CustomerContent;
        }
        field(14; "Template ID 4"; Text[50])
        {
            Caption = 'DLT Template ID 4';
            DataClassification = CustomerContent;
        }
        field(15; "Template Name 4"; Text[100])
        {
            Caption = 'Template Name 4';
            DataClassification = CustomerContent;
        }
        field(16; "Template ID 5"; Text[50])
        {
            Caption = 'DLT Template ID 5';
            DataClassification = CustomerContent;
        }
        field(17; "Template Name 5"; Text[100])
        {
            Caption = 'Template Name 5';
            DataClassification = CustomerContent;
        }
        field(18; "Template ID 6"; Text[50])
        {
            Caption = 'DLT Template ID 6';
            DataClassification = CustomerContent;
        }
        field(19; "Template Name 6"; Text[100])
        {
            Caption = 'Template Name 6';
            DataClassification = CustomerContent;
        }
        field(20; "Template ID 7"; Text[50])
        {
            Caption = 'DLT Template ID 7';
            DataClassification = CustomerContent;
        }
        field(21; "Template Name 7"; Text[100])
        {
            Caption = 'Template Name 7';
            DataClassification = CustomerContent;
        }
        field(22; "Template ID 8"; Text[50])
        {
            Caption = 'DLT Template ID 8';
            DataClassification = CustomerContent;
        }
        field(23; "Template Name 8"; Text[100])
        {
            Caption = 'Template Name 8';
            DataClassification = CustomerContent;
        }
        field(24; "Template ID 9"; Text[50])
        {
            Caption = 'DLT Template ID 9';
            DataClassification = CustomerContent;
        }
        field(25; "Template Name 9"; Text[100])
        {
            Caption = 'Template Name 9';
            DataClassification = CustomerContent;
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
