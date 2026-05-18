table 50009 DozenPicsConversion
{
    DataClassification = ToBeClassified;
    Caption = 'Piece Dozen Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(2; "Dozen"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Dozen';
            DecimalPlaces = 0 : 3;
            MinValue = 0;
            

            trigger OnValidate()
            var
                FullDozens: Integer;
                DecimalPart: Decimal;
            begin
                if Dozen = 0 then begin
                    Pieces := 0;
                    exit;
                end;

                FullDozens := Dozen DIV 1;
                DecimalPart := Round(Dozen - FullDozens, 0.001);

                if DecimalPart <> 0 then
                    ValidateDozenDecimal(DecimalPart);

                Pieces := CalcPiecesFromDozen(Dozen);
            end;
        }

        field(3; "Pieces"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Pieces';
            MinValue = 0;

            trigger OnValidate()
            begin
                Dozen := CalcDozenFromPieces(Pieces);
            end;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ValidateDozenDecimal(DecimalPart: Decimal)
    var
        SetupRec: Record "Dozen Decimal Setup";
        Tolerance: Decimal;
        ValidValuesTxt: Text;
    begin
        Tolerance := 0.005; 

        SetupRec.Reset();
        SetupRec.SetRange("Decimal Value",DecimalPart - Tolerance,DecimalPart + Tolerance);
        if not SetupRec.FindFirst() then begin
            ValidValuesTxt := GetValidDecimalValuesList();
            Error( 'Invalid dozen decimal value: %1\' + 'Valid decimal values are:\%2', DecimalPart, ValidValuesTxt);
        end;
    end;
    procedure GetValidDecimalValuesList(): Text
    var
        SetupRec: Record "Dozen Decimal Setup";
        ResultTxt: Text;
    begin
        SetupRec.Reset();
        SetupRec.SetCurrentKey("Pieces");
        if SetupRec.FindSet() then
            repeat
                ResultTxt += StrSubstNo('%1 pieces = %2 doz\',SetupRec.Pieces,SetupRec."Decimal Value");
            until SetupRec.Next() = 0;
        exit(ResultTxt);
    end;

    procedure CalcPiecesFromDozen(DozenQty: Decimal): Integer
    var
        FullDozens: Integer;
        DecimalPart: Decimal;
    begin
        if DozenQty = 0 then
            exit(0);

        FullDozens := DozenQty DIV 1;
        DecimalPart := Round(DozenQty - FullDozens, 0.001);

        exit((FullDozens * 12) + GetPiecesFromDecimal(DecimalPart));
    end;

    procedure CalcDozenFromPieces(PiecesQty: Integer): Decimal
    begin
        if PiecesQty = 0 then
            exit(0);
        exit(PiecesQty / 12);
    end;

    procedure GetPiecesFromDecimal(DecimalValue: Decimal): Integer
    var
        SetupRec: Record "Dozen Decimal Setup";
        Tolerance: Decimal;
    begin
        if DecimalValue = 0 then
            exit(0);

        Tolerance := 0.005;
        SetupRec.Reset();
        SetupRec.SetRange("Decimal Value",
            DecimalValue - Tolerance,
            DecimalValue + Tolerance);

        if SetupRec.FindFirst() then
            exit(SetupRec.Pieces);

        exit(0);
    end;
}