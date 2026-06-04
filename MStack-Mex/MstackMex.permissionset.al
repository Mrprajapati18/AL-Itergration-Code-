permissionset 50000 "Mstack-Mex"
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
        codeunit "PBS Integration MEX"=X,
        page "Customer Api Creation List"=X,
        page ItemCreationAPI=X,
        page "PBS Customer API Creation Card"=X,
        page "PBS Vendor API Creation Card "=X,
        page "Ship to Address API List"=X,
        page "Ship to Address card "=X,
        page "Vendor API Ceation card"=X,
        page "Vendor API Creation"=X,
        page "Vendor Bank Acc Card"=X,
        page "Vendor Bank Acc List"=X;
}