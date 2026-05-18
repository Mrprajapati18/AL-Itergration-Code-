table 50003 "Purchase Terms"
{
   Caption = 'Purchase Terms';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            ToolTip = 'Specifies the unique entry number for the purchase term. This is auto-generated.';
        }

        field(2; "Purchase Terms Type"; Code[100])
        {
            Caption = 'Purchase Terms Type';
            NotBlank = true;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the type of purchase term (e.g., PAYMENT TERMS, DELIVERY TERMS).';
            TableRelation = "Purchase Terms Types"."Purchase Terms Type";
        }

        field(3; "Purchase Terms"; Text[250])
        {
            Caption = 'Purchase Terms';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a detailed description of the purchase term.';
        }
    }

    keys
    {

        key(PK; "Purchase Terms")
        {
            Clustered = true;
        }
    }
  
  fieldgroups
  {
    
  }
  
  var
    myInt: Integer;
  
  trigger OnInsert()
  begin
    
  end;
  
  trigger OnModify()
  begin
    
  end;
  
  trigger OnDelete()
  begin
    
  end;
  
  trigger OnRename()
  begin
    
  end;
  
}