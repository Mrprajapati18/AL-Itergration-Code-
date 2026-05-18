table 50004 "Sale Terms Line"
{
    Caption = 'Sales Terms Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(3; "Sales Terms Type"; Code[100])
        {
            Caption = 'Sales Terms Type';
            DataClassification = CustomerContent;
            ToolTip = 'Select the type of purchase term from the predefined list.';
            TableRelation = "Sales Terms Types";

            trigger OnValidate()
            begin

                "Sales Terms" := '';
            end;
        }

        field(4; "Sales Terms"; Text[250])
        {
            Caption = 'Sales Terms';
            DataClassification = CustomerContent;
            ToolTip = 'Auto-filled from Sales Terms setup. Can be edited manually.';

            TableRelation = "Sales Terms" where("Sales Terms Type" = field("Sales Terms Type"));

            trigger OnValidate()
            begin
                GetSalesTerms();
            end;
        }

    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        SalesTermsLine: Record "Sale Terms Line";
    begin
        SalesTermsLine.SetRange("Document No.", "Document No.");
        if SalesTermsLine.FindLast() then
            exit(SalesTermsLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetSalesTermsDescription()
    var
        SalesTerms: Record "Sales Terms Types";
    begin
        if SalesTerms.Get("Sales Terms Type") then
            "Sales Terms" := SalesTerms."Sales Terms Type"
        else
            "Sales Terms" := '';
    end;

    local procedure GetSalesTerms()
    var
        SalesTermRec: Record "Sales Terms";

    begin
        if SalesTermRec.Get("Sales Terms") then
            "Sales Terms" := SalesTermRec."Sales Terms"
        else
            "Sales Terms" := '';
        exit;
    end;
}




