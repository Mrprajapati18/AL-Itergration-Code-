table 80004 "SMS Log"
{
    Caption = 'SMS Log';
    DataClassification = CustomerContent;
    DrillDownPageId = "SMS Log List";
    LookupPageId = "SMS Log List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Document Type"; Text[50])
        {
            Caption = 'Document Type';

        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(5; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(6; "Mobile No."; Text[20])
        {
            Caption = 'Mobile No.';
        }
        field(7; "Template ID"; Text[50])
        {
            Caption = 'Template ID';
        }
        field(8; "Message Sent"; Text[2000])
        {
            Caption = 'Message Sent';

        }
        field(9; "API Response"; Text[2000])
        {
            Caption = 'API Response';
        }
        field(10; "HTTP Status"; Integer)
        {
            Caption = 'HTTP Status';
        }
        field(11; Success; Boolean)
        {
            Caption = 'Success';
        }
        field(12; "Error Message"; Text[500])
        {
            Caption = 'Error Message';
        }
        field(13; "Sent At"; DateTime)
        {
            Caption = 'Sent At';
        }
        field(14; "Sent By"; Code[50])
        {
            Caption = 'Sent By';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Message ID (Gateway)"; Text[100])
        {
            Caption = 'Message ID (Gateway)';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Document; "Document Type", "Document No.")
        {

        }
        key(Customer; "Customer No.", "Sent At")
        {

        }
    }
}


