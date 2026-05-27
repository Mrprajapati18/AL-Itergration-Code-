 
 page 80012 "MY Seeds SMS Send Dialog"
{
    Caption = 'Send Sales Return SMS';
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(CustomerInfo)
            {
                Caption = 'Customer Information';
                field(CustomerNameField; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field(PhoneNoField; PhoneNo)
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    Editable = false;
                }
            }
            group(TemplateVariables)
            {
                Caption = 'Message Variables (Fill All Fields)';

                field(Var1Field; Var1_CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name (in Message)';
                    ToolTip = 'e.g. Ganesh';
                    NotBlank = true;
                }
                field(Var2Field; Var2_InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                    ToolTip = 'e.g. INV/333/3KJ3N';
                    NotBlank = true;
                }
                field(Var3Field; Var3_Variety1)
                {
                    ApplicationArea = All;
                    Caption = 'Variety 1 (e.g. TEJA 8KG)';
                    ToolTip = 'e.g. TEJA 8KG';
                    NotBlank = true;
                }
                field(Var4Field; Var4_Variety2)
                {
                    ApplicationArea = All;
                    Caption = 'Variety 2 (e.g. TOMATO MAYA 32KG)';
                    ToolTip = 'e.g. TOMATO MAYA 32KG';
                }
                field(Var5Field; Var5_Variety3)
                {
                    ApplicationArea = All;
                    Caption = 'Variety 3 (e.g. MAIZE SUPER 6KG)';
                    ToolTip = 'e.g. MAIZE SUPER 6KG';
                }
                field(Var6Field; Var6_Variety4)
                {
                    ApplicationArea = All;
                    Caption = 'Variety 4 (e.g. PADDY ANAND 32KG)';
                    ToolTip = 'e.g. PADDY ANAND 32KG';
                }
            }
            group(Preview)
            {
                Caption = 'Message Preview';
                field(PreviewMsg; GetPreviewMessage())
                {
                    ApplicationArea = All;
                    Caption = 'Preview';
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }

    var
        CustomerName: Text[100];
        PhoneNo: Text[30];
        Var1_CustomerName: Text[100];
        Var2_InvoiceNo: Text[50];
        Var3_Variety1: Text[100];
        Var4_Variety2: Text[100];
        Var5_Variety3: Text[100];
        Var6_Variety4: Text[100];

    procedure SetCustomerInfo(CustName: Text[100]; CustPhone: Text[30])
    begin
        CustomerName := CustName;
        PhoneNo := CustPhone;
        Var1_CustomerName := CustName;
    end;

    local procedure GetPreviewMessage(): Text
    var
        Msg: Text;
        V4: Text;
        V5: Text;
        V6: Text;
    begin
        V4 := Var4_Variety2;
        V5 := Var5_Variety3;
        V6 := Var6_Variety4;

        Msg := 'Dear ' + Var1_CustomerName +
               ', Sales return against invoice ' + Var2_InvoiceNo +
               ' for Variety ' + Var3_Variety1;

        if V4 <> '' then
            Msg += ', ' + V4;
        if V5 <> '' then
            Msg += ', ' + V5;
        if V6 <> '' then
            Msg += ' ' + V6;

        Msg += ' has been received and confirmed -MY SEEDS';
        exit(Msg);
    end;

    procedure GetFinalMessage(): Text
    begin
        exit(GetPreviewMessage());
    end;

    procedure GetPhoneNo(): Text[30]
    begin
        exit(PhoneNo);
    end;
}
