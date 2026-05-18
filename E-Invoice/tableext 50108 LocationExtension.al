// tableextension 50108 LocationExtension extends Location
// {
//     fields
//     {
//         // Add changes to table fields 

//         field(50000; "User Email Id"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50001; "User Name"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//             trigger OnValidate()
//             BEGIN

//             END;

//         }
//         field(50002; Password; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50003; "IP Address"; Text[100])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50004; "Client ID"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50005; "Client Secret"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50006; "GSTIN Number"; Text[15])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50007; "Auth-Token"; Text[250])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50008; "Auth-Token Generation Time"; DateTime)
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50009; "Auth-Token Expiration Time"; DateTime)
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50010; "Response Code"; Text[20])
//         {
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50011; "Response Description"; Text[250])
//         {
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50012; "Total No. of Hits"; Integer)
//         {
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50013; "E invoice Provider"; Option)
//         {
//             OptionMembers = " ","MasterGST","JioGST";
//             Description = '//JioGST Field';
//         }
//         field(50014; "Intrastate Client ID"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50015; "Intrastate Client Secret"; Text[150])
//         {
//             DataClassification = ToBeClassified;
//             Description = '//Api Hitting Details DoNot Delete these fields';
//         }
//         field(50016; "Bank Name"; Text[100])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(50017; "Bank Branch No."; Text[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(50018; "Bank Account No."; Text[30])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(50019; "IFSC Code"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(50020; "RGP In NOS"; code[20])
//         {

//         }
//         field(50021; "RGP Out NOS"; code[20])
//         {

//         }
//         field(50022; "T.I.N No."; code[20])
//         {

//         }
//         field(50023; "C.I.N No."; Code[10])
//         {

//         }
//         field(50024; "P.A.N No."; code[10])
//         {

//         }
//     }


//     var
//         myInt: Integer;
// }