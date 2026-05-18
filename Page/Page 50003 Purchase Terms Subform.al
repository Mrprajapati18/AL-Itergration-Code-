page 50003 "Purchase Terms Subform"
{
    Caption = 'Purchase Terms Subform';
    PageType = ListPart;
    SourceTable = "Purchase Terms Line";
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
                    ToolTip = 'Specifies the line number for this purchase term entry.';
                }

                field("Purchase Terms Type"; Rec."Purchase Terms Type")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Terms Type';
                    ToolTip = 'Select the type of purchase term. Dropdown shows values from Purchase Terms setup.';
                  
                }

                field("Purchase Terms"; Rec."Purchase Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Terms';
                    ToolTip = 'Specifies the purchase terms description. Auto-filled when type is selected, can be edited.';
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
