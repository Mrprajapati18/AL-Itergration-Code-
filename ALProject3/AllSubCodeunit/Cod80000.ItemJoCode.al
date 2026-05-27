codeunit 80004 ItemJnlReasonCodeTransfer
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CopyReasonCodeToILE(
        var NewItemLedgEntry: Record "Item Ledger Entry";
        var ItemJournalLine: Record "Item Journal Line";
        var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Reason Code" := ItemJournalLine."Reason Code";
    end;
}
