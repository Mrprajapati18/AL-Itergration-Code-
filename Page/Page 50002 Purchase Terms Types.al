page 50002 "Purchase Terms Types"
{
    Caption = 'Purchase Terms Types';
    PageType = List;
    SourceTable = "Purchase Terms Types";
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
                field("Purchase Terms Type"; Rec."Purchase Terms Type")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Terms Type';
                    ToolTip = 'Specifies the type of purchase term.';
                }
                
            }
        }
    }
}
