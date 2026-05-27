// codeunit 80001 SalesOrderPosetd
// {
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post",'OnBeforeInsertSalesInvHeader', '', false,false)]
//     local procedure OnBeforeInsertSalesInvHeader(
//      var 
//      SalesInvHeader: Record "Sales Invoice Header";
//      SalesHeader: Record "Sales Header")
//     begin
//         SalesInvHeader."Dispatch" := SalesHeader."Dispatch";
//     end;
// }