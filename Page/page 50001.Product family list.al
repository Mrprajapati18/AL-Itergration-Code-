page 50001 "Product Family List"
{
    ApplicationArea = All;
    Caption = 'Product Family List';
    PageType = List;
    SourceTable = ProductFamily;
    UsageCategory = Lists;
    // CardPageId = "Product Family";            

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product Family Id"; Rec."Product Family Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Family ID.';
                }
                field("Product Family Name"; Rec."Product Family Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Family Name.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewRecord)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                // RunObject = page "Product Family";
                ToolTip = 'Create a new Product Family.';
            }
        }
    }
}