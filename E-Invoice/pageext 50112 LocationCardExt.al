// pageextension 50112 LocationCardExt extends "Location Card"
// {
//     layout
//     {
//         addafter(General)
//         {

//         }
//         addlast("Tax Information")
//         {
//             group("E invoice Setup")
//             {
//                 field("User Name"; Rec."User Name")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("User Email Id"; Rec."User Email Id")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field(Password; Rec.Password)
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("IP Address"; Rec."IP Address")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Client ID"; Rec."Client ID")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Client Secret"; Rec."Client Secret")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("GSTIN Number"; Rec."GSTIN Number")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Auth-Token"; Rec."Auth-Token")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Auth-Token Generation Time"; Rec."Auth-Token Generation Time")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Auth-Token Expiration Time"; Rec."Auth-Token Expiration Time")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Response Code"; Rec."Response Code")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Response Description"; Rec."Response Description")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Total No. of Hits"; Rec."Total No. of Hits")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("E invoice Provider"; Rec."E invoice Provider")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Intrastate Client ID"; Rec."Intrastate Client ID")
//                 {
//                     ApplicationArea = all;
//                 }

//                 field("Intrastate Client Secret"; Rec."Intrastate Client Secret")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Auth-Token Url"; Rec."Auth-Token Url")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("E-Invoice Url"; Rec."E-Invoice Url")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Interstate E-Way Bill Url"; Rec."Interstate E-Way Bill Url")
//                 {
//                     ApplicationArea = all;

//                 }
//                 field("Intrastate E-Way Bill Url"; Rec."Intrastate E-Way Bill Url")
//                 {
//                     ApplicationArea = all;

//                 }

//                 field("Bank Name"; Rec."Bank Name")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Bank Branch No."; Rec."Bank Branch No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Bank Account No."; Rec."Bank Account No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("IFSC Code"; Rec."IFSC Code")
//                 {
//                     ApplicationArea = all;
//                 }

//             }
//         }
//     }


//     actions
//     {
//         addafter("&Location")
//         {
//             action("Get Auth-Token")
//             {
//                 Image = Process;
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     MasterGSTApi: Codeunit MasterGst;
//                 begin
//                     MasterGSTApi.GenerateAuthenticationAPI(Rec."Code");
//                     CurrPage.UPDATE;
//                 end;
//             }
//         }
//         // Add changes to page actions here

//     }
//     trigger OnAfterGetRecord()
//     begin

//     end;

//     var
//         Edit: Boolean;
//         myInt: Integer;
// }