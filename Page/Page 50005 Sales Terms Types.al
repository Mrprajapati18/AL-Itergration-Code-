page 50005 "Sales Terms Types"
{
    Caption = 'Sales Terms Types';
    PageType = List;
    SourceTable = "Sales Terms Types";
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
                field("Sales Terms Type"; Rec."Sales Terms Type")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Terms Type';
                    ToolTip = 'Specifies the type of Sales term.';
                }
                
            }
        }
    }
}
