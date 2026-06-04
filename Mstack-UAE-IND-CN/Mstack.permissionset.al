namespace Mstack;

permissionset 50000 Mstack
{
    Assignable = true;
    Permissions = tabledata "E-Invoice & E-Way Bill Master" = RIMD,
        tabledata "PBS Customer API Crtn Master" = RIMD,
        tabledata "PBS ShipTo Address API" = RIMD,
        tabledata "PBS TDS Section API" = RIMD,
        tabledata "PBS Vendor API Creation Master" = RIMD,
        tabledata "PBS Vendor Bank Acc API" = RIMD,
        tabledata ProductFamily = RIMD,
        tabledata "Purchase Terms" = RIMD,
        tabledata "Purchase Terms Line" = RIMD,
        tabledata "Purchase Terms Types" = RIMD,
        tabledata "Sale Terms Line" = RIMD,
        tabledata "Sales Terms" = RIMD,
        tabledata "Sales Terms Types" = RIMD,
        table "E-Invoice & E-Way Bill Master" = X,
        
        table "PBS Customer API Crtn Master" = X,
        table "PBS ShipTo Address API" = X,
        table "PBS TDS Section API"=X,
        table "PBS Vendor API Creation Master" = X,
        table "PBS Vendor Bank Acc API" = X,
        table ProductFamily = X,
        table "Purchase Terms" = X,
        table "Purchase Terms Line" = X,
        table "Purchase Terms Types" = X,
        table "Sale Terms Line" = X,
        table "Sales Terms" = X,
        table "Sales Terms Types" = X,
        report "Credit Note" = X,
        report DebitNote = X,
        report TaxInvoice = X,
        codeunit "PBS Event Subscribers" = X,
        codeunit "PBS Integration" = X,
       
        page "PBS Customer API Creation Card" = X,
        // page "PBS ShipTo API Creation List" = X,

        page "PBS Vendor API Creation Card " = X,
        // page "PBS Vendor Bank List API" = X,
        page "Product Family List" = X,
        page "Purchase Terms" = X,
        page "Purchase Terms Subform" = X,
        page "Purchase Terms Types" = X,
        page "Sale Terms" = X,
        page "Sale Terms Subform" = X,
        page "Sales Terms Types" = X;
}