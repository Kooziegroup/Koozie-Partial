public with sharing class cqParseClarMessage {
    public static void cqParseClarMessage(Map<Case, List<Clarification_Question__c>> mpCaseDetails) {

        List<Case> caseUpdate = new List<Case>();

        For(Case lstCase : mpCaseDetails.keyset()){

            string clarText = '<html><body>';    
            string proofText = '<html><body>For your convenience you may approve your proof(s) on-line by clicking the link below.\n';  
            string proofURLText = '';
            string fullProofText = '';
            integer clarNum = 0;
            integer proofNum = 0;      

            For(Clarification_Question__c clarQuest : mpCaseDetails.get(lstCase)){
            
                IF(clarQuest.Question_Type__c == 'Clarification'){
                    clarText += string.valueOf(clarNum + 1) + ')  ' + clarQuest.Message_Text__c + '\n';
                    clarNum +=1;
                    System.debug('======= ' +clarText);
                }
                
                IF(clarQuest.Question_Type__c == 'Proof'){
                    string proofURL = (string.isBlank(clarQuest.Online_Proof_URL__c))? 'NO URL' : clarQuest.Online_Proof_URL__c;
                    proofText += string.valueOf(proofNum + 1) + ')  ' + clarQuest.Message_Text__c + '\n';
                    
                    proofURLText += 'Line Number: ' + string.valueOf(proofNum + 1) + '           Product Number: ' + clarQuest.Product_Number__c + '\n';
                    proofURLText += 'Proof On-Line: ' + proofURL + '\n';
                    
                    proofNum +=1;
                    System.debug('======= ' +proofText);
                }                
            }  

            clarText += '</body></html>';
            proofText += '</body></html>';
            System.debug('======= ' +clarText);
            System.debug('======= ' +proofText);
            
            if(clarNum > 0){
                lstCase.Clarification_Description__c = clarText; 
            }
            
            if(proofNum  > 0){
                fullProofText += proofText + '\n';
                fullProofText += proofURLText;
                
                lstCase.Proof_Description__c = fullProofText;
            }  

            caseUpdate.add(lstCase);
        }

        if(caseUpdate.size() > 0){
            update caseUpdate;
        }

    }
}