
table 50002 "Purchase Terms Line"
{
    Caption = 'Purchase Terms Line';
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

        field(3; "Purchase Terms Type"; Code[100])
        {
            Caption = 'Purchase Terms Type';
            DataClassification = CustomerContent;
            ToolTip = 'Select the type of purchase term from the predefined list.';
            TableRelation = "Purchase Terms Types";

            trigger OnValidate()
            begin

                "Purchase Terms" := '';
            end;
        }

        field(4; "Purchase Terms"; Text[250])
        {
            Caption = 'Purchase Terms';
            DataClassification = CustomerContent;
            ToolTip = 'Auto-filled from Purchase Terms setup. Can be edited manually.';

            TableRelation = "Purchase Terms" where("Purchase Terms Type" = field("Purchase Terms Type"));

            trigger OnValidate()
            begin
                GetPurchTerms();
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
        PurchTermsLine: Record "Purchase Terms Line";
    begin
        PurchTermsLine.SetRange("Document No.", "Document No.");
        if PurchTermsLine.FindLast() then
            exit(PurchTermsLine."Line No." + 10000)
        else
            exit(10000);
    end;

    // local procedure GetPurchaseTermsDescription()
    // var
    //     PurchTerms: Record "Purchase Terms Types";
    // begin
    //     if PurchTerms.Get("Purchase Terms Type") then
    //         "Purchase Terms" := PurchTerms."Purchase Terms Type"
    //     else
    //         "Purchase Terms" := '';
    // end;

    local procedure GetPurchTerms()
    var
        PurchaseTermRec: Record "Purchase Terms";

    begin
        if PurchaseTermRec.Get("Purchase Terms") then
            "Purchase Terms" := PurchaseTermRec."Purchase Terms"
        else
            "Purchase Terms" := '';
    end;
}



