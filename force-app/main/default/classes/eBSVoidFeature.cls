public class eBSVoidFeature {
    public static  Set<ID> updateQuestion(List<Case> newCase,List<Case> oldcase,Set<Id> setCaseVar) 
    {
        set<ID> collectIDs = new set<Id>();
        List<Clarification_Question__c> clarQuest = new list<Clarification_Question__c>();
        List<Clarification_Question__c> addClarQuest = new list<Clarification_Question__c>();
        for(Case c : newCase)
        {
            collectIDs.add(c.Id);
        }
        if(collectIDs.size() > 0)
        {
            clarQuest= [SELECT ID,Status__c,Question_Type__c FROM Clarification_Question__c WHERE Case__c IN: collectIDs AND Void_Question__c=TRUE];
            
            system.debug('clarQuest@@@@@@@'+clarQuest);
            for(Clarification_Question__c cq : clarQuest)
            {
                cq.Status__c = 'Closed';
                //cq.Response__c = 'Testing void functionality';
                //cq.Question_Type__c = '';
                addClarQuest.add(cq);
            }
        }
        if(addClarQuest.size() > 0)
        {
            system.debug(' before update addClarQuest@@@@@@@'+addClarQuest);

            UPDATE addClarQuest;
        }
        //if there no open questions then remove those cases from the list lstCaseID.
        Set<Id> newCaseIdSet = new Set<Id>();
        //soql to fetch records with only question status = Open and adding those case Id's to new set.
        for(Clarification_Question__c qaRec:[SELECT ID,Status__c,Case__c FROM Clarification_Question__c WHERE Case__c IN: setCaseVar AND Status__c ='Open']){
            newCaseIdSet.add(qaRec.Case__c); 
        }
        return newCaseIdSet;
      }
      
    /*HANDLES UPDATES TO CLARIFICATION QUESTIONS VIA VOID*/
    public static void updateCQQuestion(List<ID> cqID, List<ID> caseID){
        List<Clarification_Question__c> clarQuestQuery = new List<Clarification_Question__c>();
        List<Clarification_Question__c> clarQuestUpdate = new List<Clarification_Question__c>();
        List<Clarification_Question__c> clarQuestCount = new List<Clarification_Question__c>();
        Map<String, List<Clarification_Question__c>> mpNumOpenClar = new Map<String, List<Clarification_Question__c>>();
        
        clarQuestQuery = [SELECT ID,Status__c,Question_Type__c, Case__c, Case__r.ContactID, Case__r.Clarification_To_Email__c, 
            Case__r.Proof_To_Email__c, Case__r.Clarification_CC_Email__c, Case__r.Proof_CC_Email__c, Case__r.Customer_To_Email__c,
            Case__r.Account.Customer_Category__c, Case__r.Account.Logo__c, Case__r.Account.Corporate_Route__c
            FROM Clarification_Question__c 
            WHERE ID IN: cqID 
            AND Void_Question__c=TRUE];
        
        //Query open questions for void email
        clarQuestCount = [SELECT ID,Status__c,Question_Type__c, Case__c  
            FROM Clarification_Question__c 
            WHERE ID IN: caseID 
            AND Status__c != 'Closed' 
            AND Status__c != 'EBS Closed'];
            
        system.debug('@@@@@@@@@@caseID'+caseID);
        
        //Populate map with CQ 
        For(Clarification_Question__c cqCountOpen : 
            [SELECT ID,Status__c,Question_Type__c, Case__c  
            FROM Clarification_Question__c 
            WHERE Case__c =: caseID 
            AND Status__c != 'Closed' 
            AND Status__c != 'EBS Closed']){
            
            //Add case and CQ to map
            if(mpNumOpenClar.get(cqCountOpen.Case__c) != null){
                List<Clarification_Question__c> lstQuest = new List<Clarification_Question__c>();
                lstQuest = mpNumOpenClar.get(cqCountOpen.Case__c);
                lstQuest.add(cqCountOpen);
                mpNumOpenClar.put(cqCountOpen.Case__c, lstQuest);                
            } else {
                List<Clarification_Question__c> lstQuest = new List<Clarification_Question__c>();
                lstQuest.add(cqCountOpen);
                mpNumOpenClar.put(cqCountOpen.Case__c, lstQuest);            
            }            
        }            
        
        system.debug('mpNumOpenClar@@@@@@@@@'+mpNumOpenClar);
        
        For(Clarification_Question__c cqLoop : clarQuestQuery){
            cqLoop.Status__c = 'Closed';
            
            if(cqLoop.Question_Type__c != 'Notification'){
                
                //**PLACEHOLDER****
                if (mpNumOpenClar == null || !mpNumOpenClar.isEmpty()) {
                    if(mpNumOpenClar.get(cqLoop.Case__c) !=null){
                        if(mpNumOpenClar.get(cqLoop.Case__c).size() == 1){
                            sendClariEmail.sendVoidEmail(cqLoop.Case__c, cqLoop);
                        }   
                    }
                    
                }
            }
            
            clarQuestUpdate.add(cqLoop);

        }
        
        if(clarQuestUpdate.size() > 0){
            try{
                update clarQuestUpdate;
            } catch (DMLException e){
                system.debug('Exception Occurred: e.getmessage()');
            }
        }    
    }     
}