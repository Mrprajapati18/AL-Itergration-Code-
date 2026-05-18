
table 50008 "MY Seeds SMS Log"
{
    Caption = 'MY Seeds SMS Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(5; "Template ID"; Text[50])
        {
            Caption = 'Template ID';
            DataClassification = CustomerContent;
        }
        field(6; "Message Sent"; Text[500])
        {
            Caption = 'Message Sent';
            DataClassification = CustomerContent;
        }
        field(7; "Sent DateTime"; DateTime)
        {
            Caption = 'Sent DateTime';
            DataClassification = CustomerContent;
        }
        field(8; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Pending","Sent","Failed";
            OptionCaption = 'Pending,Sent,Failed';
            DataClassification = CustomerContent;
        }
        field(9; "Error Message"; Text[500])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(10; "Sent By"; Code[50])
        {
            Caption = 'Sent By';
            DataClassification = CustomerContent;
        }
        field(11; "Source Document No."; Code[20])
        {
            Caption = 'Source Document No.';
            DataClassification = CustomerContent;
        }
        field(12; "API Response"; Text[500])
        {
            Caption = 'API Response';
            DataClassification = CustomerContent;
        }
        field(13; "Sender ID"; Code[10])
        {
            Caption = 'Sender ID';
            DataClassification = CustomerContent;
        }
        field(14; "PE ID"; Code[20])
        {
            Caption = 'PE ID';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer No.", "Sent DateTime")

        {

        }
    }
}
