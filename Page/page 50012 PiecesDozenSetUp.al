page 50012 "Dozen Decimal Setup"
{
    PageType = List;
    SourceTable = "Dozen Decimal Setup";
    Caption = 'Dozen Decimal Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Pieces; Rec.Pieces)
                {
                    ApplicationArea = All;
                    Caption = 'Pieces';
                }
                field("Decimal Value"; Rec."Decimal Value")
                {
                    ApplicationArea = All;
                    Caption = 'Decimal Value (Dozen)';
                    ToolTip = 'e.g. 0.083 = 1 piece, 0.17 = 2 pieces';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadDefaults)
            {
                ApplicationArea = All;
                Caption = 'Load Default Values';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    InsertDefaultSetup();
                    CurrPage.Update(false);
                    Message('Default values loaded successfully.');
                end;
            }
        }
    }

    local procedure InsertDefaultSetup()
    begin
        InsertSetupLine(1,  0.083);
        InsertSetupLine(2,  0.17);
        InsertSetupLine(3,  0.25);
        InsertSetupLine(4,  0.33);
        InsertSetupLine(5,  0.42);
        InsertSetupLine(6,  0.50);
        InsertSetupLine(7,  0.58);
        InsertSetupLine(8,  0.67);
        InsertSetupLine(9,  0.75);
        InsertSetupLine(10, 0.83);
        InsertSetupLine(11, 0.92);
        InsertSetupLine(12, 1.00);
    end;

    local procedure InsertSetupLine(PiecesNo: Integer; DecVal: Decimal)
    var
        SetupRec: Record "Dozen Decimal Setup";
    begin
        if SetupRec.Get(PiecesNo) then begin
            SetupRec."Decimal Value" := DecVal;
            SetupRec.Modify(true);
            exit;
        end;
        SetupRec.Init();
        SetupRec.Pieces := PiecesNo;
        SetupRec."Decimal Value" := DecVal;
        SetupRec.Insert(true);
    end;
}