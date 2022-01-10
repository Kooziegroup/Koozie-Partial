public with sharing class cqCheckCloseCase {
    public static Map<Case, List<Clarification_Question__c>> checkCloseCase(Map<Case, List<Clarification_Question__c>> mpCaseDetails) {

        List<Case> clsCase = new List<Case>();
        Map<Case, List<Clarification_Question__c>> newCaseDetails = new Map<Case, List<Clarification_Question__c>>();

        For(Case lstCase : mpCaseDetails.KeySet()){
            
            Boolean closeCase = true;
            List<Clarification_Question__c> openCQ = new List<Clarification_Question__c>();

            For(Clarification_Question__c lstCQDetails : mpCaseDetails.get(lstCase)){
                if(lstCQDetails.Status__c == '' || lstCQDetails.Status__c == 'Open' || lstCQDetails.Status__c == null){
                    closeCase = false;
                    openCQ.add(lstCQDetails);
                }
            }

            //Map to update  proof or clarification message text
            if(closeCase){
                lstCase.Status = 'Closed';
                lstCase.Cancellation_Date__c  = null;
                lstCase.Cancellation_Date_Email__c  = null;
                lstCase.Cancellation_Notice__c  = null;
                lstCase.Current_Process__c = null;
                lstCase.Next_Process__c  = null;                
                lstCase.Cadence_Intialized__c = false;
                lstCase.Clarification_Start_Date__c = null;
                lstCase.Customer_Contact_Date__c = null;
                lstCase.Customer_Contact_Date_Email__c = null;
                lstCase.Customer_Specified_Date__c = null;  
                lstCase.X24_Hour_Turn__c = null;
                lstCase.Day_3_Reminder_Call__c = null;
                lstCase.Hold_Type__c = null;
                lstCase.Initial_Email__c = null;
                                                                                                                                                                                            
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