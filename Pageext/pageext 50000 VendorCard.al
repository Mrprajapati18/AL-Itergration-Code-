pageextension 50000 "Vendor Card PBS" extends "Vendor Card"
{
    layout
    {
        addafter("Tax Information")
        {
            group("MSME Details")
            {
                field("Udyam Reg No"; rec."Udyam Reg No")
                {
                    Caption = 'Udyam Registration No';
                    ApplicationArea = ALl;
                }
                field("Type of Enterprise"; Rec."Type of Enterprise")
                {
                    ApplicationArea = All;
                }
                field("Major Activity"; Rec."Major Activity")
                {
                    ApplicationArea = All;
                }
                field(Turnover; Rec.Turnover)
                {
                    ApplicationArea = All;
                }
                field("MSME Vendor"; Rec."MSME Vendor")
                {
                    ApplicationArea = All;
                }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}