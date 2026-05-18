page 50011 "Dozen Pics Conversion"
{
    PageType = List;
    SourceTable = DozenPicsConversion;
    Caption = 'Dozen to Pieces Conversion';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                }

                field(Dozen; Rec.Dozen)
                {
                    ApplicationArea = All;
                    Caption = 'Dozen';
                    Style = Favorable;
                    ToolTip = 'Dozen value enter (e.g. 2.25 = 2 full dozen + 3 pieces)';
                }

                field(Pieces; Rec.Pieces)
                {
                    ApplicationArea = All;
                    Caption = 'Pieces';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Click the Action button values auto-calculate.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalcPieces)
            {
                ApplicationArea = All;
                Caption = 'Calculate Pieces';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SelectedRec: Record DozenPicsConversion;
                    FullDozens: Integer;
                    DecimalPart: Decimal;
                    RemPieces: Integer;
                    TotalPieces: Integer;
                    UpdatedCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRec);

                    if not SelectedRec.FindFirst() then begin
                        Message('Nothing Record Selected.');
                        exit;
                    end;

                    repeat
                        if SelectedRec.Dozen = 0 then begin
                            SelectedRec.Pieces := 0;
                        end else begin

                            FullDozens := SelectedRec.Dozen DIV 1;
                            DecimalPart := SelectedRec.Dozen - FullDozens;
                            RemPieces := SelectedRec.GetPiecesFromDecimal(DecimalPart);
                            TotalPieces := (FullDozens * 12) + RemPieces;

                            SelectedRec.Pieces := TotalPieces;
                        end;

                        SelectedRec.Modify(true);
                        UpdatedCount += 1;
                    until SelectedRec.Next() = 0;

                    CurrPage.Update(false);
                    Message('Selected Record calculated, %1', UpdatedCount);
                end;
            }
        }
    }
}
