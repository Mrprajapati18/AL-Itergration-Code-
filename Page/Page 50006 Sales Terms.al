page 50006 "Sale Terms"
{
    Caption = 'Sale Terms';
    PageType = List;
    SourceTable = "Sales Terms";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the unique auto-generated entry number.';
                    Editable = false;
                }
                field("Sale Terms Type"; Rec."Sales Terms Type")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Terms Type';
                    ToolTip = 'Specifies the type of Sale term.';
                }
                field("Sale Terms"; Rec."Sales Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Terms';
                }
            }
        }
    }
}