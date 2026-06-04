namespace MStack;

permissionset 50000 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "PBS Customer API Crtn Master"=RIMD,
        tabledata "PBS Item Creation API Master"=RIMD,
        tabledata "PBS ShipTo Address API"=RIMD,
        tabledata "PBS Vendor API Creation Master"=RIMD,
        tabledata "PBS Vendor Bank Acc API"=RIMD,
        tabledata ProductFamily=RIMD,
        table "PBS Customer API Crtn Master"=X,
        table "PBS Item Creation API Master"=X,
        table "PBS ShipTo Address API"=X,
        table "PBS Vendor API Creation Master"=X,
        table "PBS Vendor Bank Acc API"=X,
        table ProductFamily=X,
        codeunit "PBS Integration USA"=X,
        page ItemCreationAPI=X,
        page "PBS Customer API Creation Card"=X,
        page "PBS Vendor API Creation Card "=X,
        page "Cust API Creation Master List"=X,
        page "Ship To Address Card"=X,
        page "Ship To Address Master"=X,
        page "Vend API Creation Master List"=X,
        page "Vendor Bank Acc Card Master"=X,
        page "Vendor Bank Acc list"=X;
}