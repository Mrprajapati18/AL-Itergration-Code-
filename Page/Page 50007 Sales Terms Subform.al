page 50007 "Sale Terms Subform"
{
    Caption = 'Sale Terms Subform';
    PageType = ListPart;
    SourceTable = "Sale Terms Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    LinksAllowed = false;
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;  
                    ToolTip = 'Specifies the document number. Auto-filled from the invoice.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    ToolTip = 'Specifies the line number for this Sale term entry.';
                }

                field("Sale Terms Type"; Rec."Sales Terms Type")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Terms Type';
                    ToolTip = 'Select the type of Sale term. Dropdown shows values from Sale Terms setup.';
                  
                }

                field("Sale Terms"; Rec."Sales Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Terms';
                    ToolTip = 'Specifies the Sale terms description. Auto-filled when type is selected, can be edited.';
                }
            }
        }
    }

    
    procedure SetDocumentNo(DocNo: Code[20])
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Document No.", DocNo);
        Rec.FilterGroup(0);
    end;
}
