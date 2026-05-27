
enum 80000 "SMS Gateway Provider"
{
    Extensible = true;
    value(0; MSG91)
    {
        Caption = 'MSG91';
    }
    value(1; Textlocal)
    {
        Caption = 'Textlocal';
    }
    value(2; Exotel)
    {
        Caption = 'Exotel';
    }
    value(3; Custom)
    {
        Caption = 'Custom (Generic REST)';
    }
}