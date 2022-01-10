public with sharing class checkCloseCase {
    public static Map<Case, List<Clarification_Question__c>> checkCloseCase(Map<Case, List<Clarification_Question__c>> mpCaseDetails) {

        List<Case> clsCase = new List<Case>();
        Map<Case, List<Clarification_Question__c>> newCaseDetails = new Map<Case, List<Clarification_Question__c>>();

        For(Case lstCase : mpCaseDetails.KeySet()){
            
            Boolean closeCase = true;
            List<Clarification_Question__c> openCQ = new List<Clarification_Question__c>();

            For(Clarification_Question__c lstCQDetails : mpCaseDetails.get(lstCase)){
                if(lstCQDetails.Status__c == '' || lstCQDetails.Status__c == 'Open'){
                    closeCase = false;
                    openCQ.add(lstCQDetails);
                }
            }

            //Map to update  proof or clarification message text
            if(closeCase){
                lstCase.Status = 'Closed';
                clsCase.add(lstCase);
            } else {                
                newCaseDetails.put(lstCase, openCQ);
            }
        }

        if(clsCase.size() > 0){
            update clsCase;
        }

        return newCaseDetails;
    }
}