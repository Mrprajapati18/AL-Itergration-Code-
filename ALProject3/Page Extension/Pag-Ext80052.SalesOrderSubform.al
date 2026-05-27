pageextension 80007 "SalesOrderSubform" extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field(Priority; Rec.Priority)
            {
                ApplicationArea = All;
                Caption = 'Priority';
                StyleExpr = RowStyle;
                Editable = false;
            }
        }
        modify(Type)
        {
            StyleExpr = RowStyle;
        }
        modify("No.")
        {
            StyleExpr = RowStyle;
        }
        modify("Item Reference No.")
        {
            StyleExpr = RowStyle;
        }
        modify("IC Partner Code")
        {
            StyleExpr = RowStyle;
        }
        modify("IC Partner Ref. Type")
        {
            StyleExpr = RowStyle;
        }
        modify("IC Partner Reference")
        {
            StyleExpr = RowStyle;
        }
        modify("IC Item Reference")
        {
            StyleExpr = RowStyle;
        }
        modify(Description)
        {
            StyleExpr = RowStyle;
        }
        modify("Unit Cost (LCY)")
        {
            StyleExpr = RowStyle;
        }
        modify("Unit Price Incl. of Tax")
        {
            StyleExpr = RowStyle;
        }
        modify("Variant Code")
        {
            StyleExpr = RowStyle;
        }
        modify("Description 2")
        {
            StyleExpr = RowStyle;
        }
        modify("Unit Price")
        {
            StyleExpr = RowStyle;
        }
        modify("Location Code")
        {
            StyleExpr = RowStyle;
        }
        modify("Bin Code")
        {
            StyleExpr = RowStyle;
        }
        modify(Quantity)
        {
            StyleExpr = RowStyle;
        }
        modify("Qty. to Ship")
        {
            StyleExpr = RowStyle;
        }
        modify("Gross Weight")
        {
            StyleExpr = RowStyle;
        }
        modify("Net Weight")
        {
            StyleExpr = RowStyle;
        }
        modify("Unit of Measure Code")
        {
            StyleExpr = RowStyle;
        }
        modify("Line Discount %")
        {
            StyleExpr = RowStyle;
        }
        modify(FOC)
        {
            StyleExpr = RowStyle;
        }
        modify("Line Discount Amount")
        {
            StyleExpr = RowStyle;
        }
        modify("Line Amount")
        {
            StyleExpr = RowStyle;
        }
        modify("GST Group Code")
        {
            StyleExpr = RowStyle;
        }
        modify("HSN/SAC Code")
        {
            StyleExpr = RowStyle;
        }
        modify("GST On Assessable Value")
        {
            StyleExpr = RowStyle;
        }
        modify("GST Place of Supply")
        {
            StyleExpr = RowStyle;
        }
        modify("GST Jurisdiction Type")
        {
            StyleExpr = RowStyle;
        }
        modify("GST Group Type")
        {
            StyleExpr = RowStyle;
        }
        modify(Exempted)
        {
            StyleExpr = RowStyle;
        }
        modify("Quantity Shipped")
        {
            StyleExpr = RowStyle;
        }
        modify("Qty. to Invoice")
        {
            StyleExpr = RowStyle;
        }
        modify("Quantity Invoiced")
        {
            StyleExpr = RowStyle;
        }
        modify("Qty. to Assign")
        {
            StyleExpr = RowStyle;
        }
        modify("Item Charge Qty. to Handle")
        {
            StyleExpr = RowStyle;
        }
        modify("Qty. Assigned")
        {
            StyleExpr = RowStyle;
        }
        modify("Shipment Date")
        {
            StyleExpr = RowStyle;
        }
    }

    actions
    {
        addafter("&Line")
        {
            action(HighlightRed)
            {
                ApplicationArea = All;
                Caption = 'Highlight Row';
                Image = Apply;

                trigger OnAction()
                begin
                    if Rec.Type = Rec.Type::Item then begin
                        GlobalDocNo := Rec."Document No.";
                        GlobalLineNo := Rec."Line No.";
                        ShowRed := true;
                        Rec.Priority := 'Yes';
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end else
                        Message('Please select a row where Type Item first.');
                end;
            }

            action(ClearHighlight)
            {
                ApplicationArea = All;
                Caption = 'Clear Highlight';
                Image = ClearFilter;

                trigger OnAction()
                begin
                    ShowRed := false;
                    GlobalDocNo := '';
                    GlobalLineNo := 0;
                    Rec.Priority := 'No';
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        RowStyle: Text;
        ShowRed: Boolean;
        GlobalDocNo: Code[20];
        GlobalLineNo: Integer;

    trigger OnAfterGetRecord()
    begin
        RowStyle := 'Standard';
        if ShowRed then
            if (Rec."Document No." = GlobalDocNo) and (Rec."Line No." = GlobalLineNo) then
                RowStyle := 'Unfavorable';
    end;
}