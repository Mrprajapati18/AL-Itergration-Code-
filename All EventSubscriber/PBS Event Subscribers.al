
codeunit 50000 "PBS Event Subscribers"
{
    // ITEM JOURNAL LINE
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure OnAfterValidateItemNoOnItemJnlLine(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line")
    var
        ItemRec: Record Item;
    begin
        if Rec."Item No." = '' then begin
            Rec."Product Family Id" := '';
            Rec."Product Family Name" := '';
            Rec."Specfice Gravity" := ' ';
            Rec."Case No." := '';
            exit;
        end;
        if ItemRec.Get(Rec."Item No.") then begin
            Rec."Product Family Id" := ItemRec."Product Family Id";
            Rec."Product Family Name" := ItemRec."Product Family Name";
            // Rec."Specfice Gravity" := ItemRec."Specfice Gravity";
            // Rec."Case No." := ItemRec."Case No.";

        end;
    end;

    //  ITEM LEDGER ENTRY
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."Product Family Id" := ItemJournalLine."Product Family Id";
        NewItemLedgEntry."Product Family Name" := ItemJournalLine."Product Family Name";
        NewItemLedgEntry."Specifice Gravity" := ItemJournalLine."Specfice Gravity";
        NewItemLedgEntry."Case No." := ItemJournalLine."Case No.";

    end;
    //  VALUE ENTRY
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertValueEntry', '', false, false)]
    local procedure OnBeforeInsertValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        ValueEntry."Product Family Id" := ItemJournalLine."Product Family Id";
        ValueEntry."Product Family Name" := ItemJournalLine."Product Family Name";
        ValueEntry."Specifice Gravity" := ItemJournalLine."Specfice Gravity";
        ValueEntry."Case No." := ItemJournalLine."Case No.";
    end;
    //  PURCHASE LINE 
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNoOnPurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        ItemRec: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then begin
            Rec."Product Family Id" := '';
            Rec."Product Family Name" := '';
            Rec."Specifice Gravity" := ' ';
            Rec."Case No." := '';
            exit;
        end;

        if Rec."No." = '' then begin
            Rec."Product Family Id" := '';
            Rec."Product Family Name" := '';
            Rec."Specifice Gravity" := ' ';
            Rec."Specifice Gravity" := ' ';
            exit;
        end;

        if ItemRec.Get(Rec."No.") then begin
            Rec."Product Family Id" := ItemRec."Product Family Id";
            Rec."Product Family Name" := ItemRec."Product Family Name";
            // Rec."Specifice Gravity" := ItemRec."Specfice Gravity";
            // Rec."Case No." := ItemRec."Case No.";
        end else begin
            Rec."Product Family Id" := '';
            Rec."Product Family Name" := '';
            Rec."Specifice Gravity" := ' ';
            Rec."Case No." := '';
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchRcptLine(var Rec: Record "Purch. Rcpt. Line"; RunTrigger: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin

        if PurchLine.Get(PurchLine."Document Type"::Order, Rec."Order No.", Rec."Order Line No.") then begin
            Rec."Product Family Id" := PurchLine."Product Family Id";
            Rec."Product Family Name" := PurchLine."Product Family Name";
            Rec."Specifice Gravity" := PurchLine."Specifice Gravity";
            Rec."Case No." := PurchLine."Case No.";
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchInvLine(var Rec: Record "Purch. Inv. Line"; RunTrigger: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin
        if PurchLine.Get(PurchLine."Document Type"::Invoice, Rec."Order No.", Rec."Order Line No.") then begin
            Rec."Product Family Id" := PurchLine."Product Family Id";
            Rec."Product Family Name" := PurchLine."Product Family Name";
            Rec."Specifice Gravity" := PurchLine."Specifice Gravity";
            Rec."Case No." := PurchLine."Case No.";
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Cr. Memo Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchCrMemoLine(var Rec: Record "Purch. Cr. Memo Line"; RunTrigger: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin
        if PurchLine.Get(PurchLine."Document Type"::"Credit Memo", Rec."Order No.", Rec."Order Line No.") then begin
            Rec."Product Family Id" := PurchLine."Product Family Id";
            Rec."Product Family Name" := PurchLine."Product Family Name";
            Rec."Specifice Gravity" := PurchLine."Specifice Gravity";
            Rec."Case No." := PurchLine."Case No.";
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertReturnShipmentLine(var Rec: Record "Return Shipment Line"; RunTrigger: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin
        if PurchLine.Get(PurchLine."Document Type"::"Return Order", Rec."Return Order No.", Rec."Return Order Line No.") then begin
            Rec."Product Family Id" := PurchLine."Product Family Id";
            Rec."Product Family Name" := PurchLine."Product Family Name";
            Rec."Specifice Gravity" := PurchLine."Specifice Gravity";
            Rec."Case No." := PurchLine."Case No.";
            Rec.Modify();
        end;
    end;

    // SALES SHIPMENT LINE (Sales Order Post)

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesShipmentLine(var Rec: Record "Sales Shipment Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesLine.Get(SalesLine."Document Type"::Order, Rec."Order No.", Rec."Order Line No.") then begin
            Rec."Product Family Id" := SalesLine."Product Family Id";
            Rec."Product Family Name" := SalesLine."Product Family Name";
            Rec."Specfice Gravity" := SalesLine."Specfice Gravity";
            Rec."Case No." := SalesLine."Case No.";
            Rec.Modify();
        end;
    end;


    // SALES INV. LINE (Sales Invoice Post)

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesInvoiceLine(var Rec: Record "Sales Invoice Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin

        if Rec."Order No." <> '' then begin
            if SalesLine.Get(SalesLine."Document Type"::Order, Rec."Order No.", Rec."Order Line No.") then begin
                Rec."Product Family Id" := SalesLine."Product Family Id";
                Rec."Product Family Name" := SalesLine."Product Family Name";
                Rec."Specfice Gravity" := SalesLine."Specfice Gravity";
                Rec."Case No." := SalesLine."Case No.";
                Rec.Modify();
            end;
        end else begin

            if SalesLine.Get(SalesLine."Document Type"::Invoice, Rec."Document No.", Rec."Line No.") then begin
                Rec."Product Family Id" := SalesLine."Product Family Id";
                Rec."Product Family Name" := SalesLine."Product Family Name";
                Rec."Specfice Gravity" := SalesLine."Specfice Gravity";
                Rec."Case No." := SalesLine."Case No.";
                Rec.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesCrMemoLine(var Rec: Record "Sales Cr.Memo Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin

        if Rec."Order No." <> '' then begin
            if SalesLine.Get(SalesLine."Document Type"::"Return Order", Rec."Order No.", Rec."Order Line No.") then begin
                Rec."Product Family Id" := SalesLine."Product Family Id";
                Rec."Product Family Name" := SalesLine."Product Family Name";
                Rec."Specfice Gravity" := SalesLine."Specfice Gravity";
                Rec."Case No." := SalesLine."Case No.";
                Rec.Modify();
            end;
        end else begin

            if SalesLine.Get(SalesLine."Document Type"::"Credit Memo", Rec."Document No.", Rec."Line No.") then begin
                Rec."Product Family Id" := SalesLine."Product Family Id";
                Rec."Product Family Name" := SalesLine."Product Family Name";
                Rec."Specfice Gravity" := SalesLine."Specfice Gravity";
                Rec."Case No." := SalesLine."Case No.";
                Rec.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertReturnReceiptLine(var Rec: Record "Return Receipt Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesLine.Get(SalesLine."Document Type"::"Return Order", Rec."Return Order No.", Rec."Return Order Line No.") then begin
            Rec."Product Family Id" := SalesLine."Product Family Id";
            Rec."Product Family Name" := SalesLine."Product Family Name";
            Rec."Specfice Gravity" := SalesLine."Specfice Gravity";
            Rec."Case No." := SalesLine."Case No.";
            Rec.Modify();
        end;
    end;

    //  TRANSFER LINE

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure OnAfterValidateItemNoOnTransferLine(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        ItemRec: Record Item;
    begin

        if Rec."Item No." = '' then begin
            Rec."Product Family Id" := '';
            Rec."Product Family Name" := '';
            Rec."Specfice Gravity" := ' ';
            Rec."Case No." := '';
            exit;
        end;


        if ItemRec.Get(Rec."Item No.") then begin
            Rec."Product Family Id" := ItemRec."Product Family Id";
            Rec."Product Family Name" := ItemRec."Product Family Name";
            // Rec."Specfice Gravity" := ItemRec."Specfice Gravity";
            // Rec."Case No." := ItemRec."Case No.";
        end else begin
            Rec."Product Family Id" := '';
            Rec."Product Family Name" := '';
            Rec."Specfice Gravity" := ' ';
            Rec."Case No." := '';
        end;
    end;

    //  TRANSFER SHIPMENT LINE 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', false, false)]
    local procedure OnAfterInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line")
    begin
        TransShptLine."Product Family Id" := TransLine."Product Family Id";
        TransShptLine."Product Family Name" := TransLine."Product Family Name";
        TransLine."Specfice Gravity" := TransLine."Specfice Gravity";
        TransLine."Case No." := TransLine."Case No.";
        TransShptLine.Modify();
    end;

    //  TRANSFER RECEIPT LINE 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptLine', '', false, false)]
    local procedure OnAfterInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line")
    begin
        TransRcptLine."Product Family Id" := TransLine."Product Family Id";
        TransRcptLine."Product Family Name" := TransLine."Product Family Name";
        TransRcptLine."Specfice Gravity" := TransLine."Specfice Gravity";
        TransRcptLine."Case No." := TransLine."Case No.";
        TransRcptLine.Modify();
    end;
}