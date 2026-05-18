table 50006 "Sales Terms"
{
   Caption = 'Sales Terms';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            ToolTip = 'Specifies the unique entry number for the Sales term. This is auto-generated.';
        }

        field(2; "Sales Terms Type"; Code[100])
        {
            Caption = 'Sales Terms Type';
            NotBlank = true;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the type of Sales term (e.g., PAYMENT TERMS, DELIVERY TERMS).';
            TableRelation = "Sales Terms Types"."Sales Terms Type";
        }

        field(3; "Sales Terms"; Text[250])
        {
            Caption = 'Sales Terms';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a detailed description of the Sales term.';
        }
    }

    keys
    {

        key(PK; "Sales Terms")
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