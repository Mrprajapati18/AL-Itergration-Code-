table 80002 "WhatsApp Message History"
{
    Caption = 'WhatsApp Message History';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(3; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(4; "Invoice No."; Text[20])
        {
            Caption = 'Invoice No.';
        }
        field(5; "Message"; Text[2048])
        {
            Caption = 'Message';
        }
        field(6; "Sent Date"; Date)
        {
            Caption = 'Sent Date';
        }
        field(7; "Sent Time"; Time)
        {
            Caption = 'Sent Time';
        }
        field(8; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Sent,Failed;
            OptionCaption = 'Sent,Failed';
        }
        field(9; "Response"; Text[2048])
        {
            Caption = 'API Response';
        }
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer No.", "Sent Date")
        {
        }
    }
}