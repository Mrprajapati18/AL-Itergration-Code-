codeunit 80009 "Sales Return SMS Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post",
            'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(
            var SalesHeader: Record "Sales Header";
            var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
            SalesShptHdrNo: Code[20];
            RetRcpHdrNo: Code[20];
            SalesInvHdrNo: Code[20];
            SalesCrMemoHdrNo: Code[20]
        )
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesReturnSMSMgt: Codeunit "Sales Return SMS Mgt.";
    begin
        if SalesCrMemoHdrNo = '' then exit;
        if not SalesCrMemoHeader.Get(SalesCrMemoHdrNo) then exit;

        SalesReturnSMSMgt.SendSalesReturnSMS(SalesCrMemoHeader);
    end;
}


