
report 80002 "Stock as On"
{
    ApplicationArea = All;
    Caption = 'Stock as On';
    DefaultLayout = RDLC;
    RDLCLayout = 'Layout\StockAsOn.rdl';
    UsageCategory = Lists;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(ItemNo; "Item No.")
            {
            }
            column(ItemName; ItemName)
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }

            column(UnitPrice; UnitPrice)
            {
            }
            column(TotalAmount; TotalAmount)
            {

            }

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                ValueEntry: Record "Value Entry";
            begin
                Clear(ItemName);
                if Item.Get(ItemLedgerEntry."Item No.") then
                    ItemName := Item.Description;

                Clear(UnitPrice);
                Clear(TotalAmount);

                ValueEntry.Reset();
                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                
                if ValueEntry.FindFirst() then
                    UnitPrice := ValueEntry."Cost per Unit";

                TotalAmount := Abs(UnitPrice * ItemLedgerEntry.Quantity); 

                if (Quantity = 0)  Or (UnitPrice = 0)then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    SetRange("Posting Date", StartDate, EndDate)
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filter....")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }

        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        ItemName: Text[100];
        UnitPrice: Decimal;
        TotalAmount: Decimal;
        StartDate: Date;
        EndDate: Date;
}