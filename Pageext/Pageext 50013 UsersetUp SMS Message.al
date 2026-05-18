pageextension 50013 "SMS Message UserSetup" extends "User Setup"
{
  layout
  {
    addafter(Email)
    {
      field("SMS Message";Rec."SMS Message")
      {
        ApplicationArea =  All;
        Caption = 'SMS Message';
      }
    }
  }
}