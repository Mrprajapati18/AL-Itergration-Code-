// pageextension 50012 "Bank Ledger SMS PBS" extends "Bank Account Ledger Entries"
// {
//     actions
//     {
//         addfirst(Report)
//         {
//             action(SendPaymentSMS)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Send Payment Received SMS';
//                 ToolTip = 'Send a Payment Received SMS to the customer linked to this bank entry.';
//                 Image = Send;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     SMSMgmt: Codeunit "PBS My Seed SMS Management";
//                 begin
//                       SMSMgmt.SendBankPaymentSMS(Rec."Sell-to Customer No.", Rec."No.");
//                 end;
//             }
//         }
//     }
// }