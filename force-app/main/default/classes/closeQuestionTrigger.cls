public with sharing class closeQuestionTrigger {

    @InvocableMethod(label='Close Question Trigger' description='Handles When Question Closed.' category='Clarification_Question__c')
    public static void handleQuestions(List<string> CaseID){    
        handleClosed(CaseID);    
    }    

    public static void handleClosed(List<string> CaseID){
        Map<Case, List<Clarification_Question__c>> uCaseID = new Map<Case, List<Clarification_Question__c>>();
        Map<Case, List<Clarification_Question__c>> messageCase = new Map<Case, List<Clarification_Question__c>>();
        
        uCaseID = cqGetUniqueCaseID.getUniqueCaseID(CaseID); 

        messageCase = cqCheckCloseCase.checkCloseCase(uCaseID); 

        if(messageCase.size() >0){
            cqParseClarMessage.cqParseClarMessage(messageCase);
        }
    }
}