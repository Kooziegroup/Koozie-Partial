trigger clariQuesTriggerHandler on Clarification_Question__c (before insert, before update, after update,after insert) {
    
    if(trigger.isbefore){
        if(trigger.isInsert || trigger.isUpdate){  
        
            List<ID> cqVoidId = new List<ID>();  
        
            For(Clarification_Question__c cqLoop : trigger.new){
                If(!(checkRecursive.SetOfIDs.contains(cqLoop.Id))){
                    cqVoidID.add(cqLoop.Id);
                    checkRecursive.SetOfIDs.add(cqLoop.Id);
                }                             
            }        
        
            if(cqVoidID.size() > 0){
                clariQuestLineLink.cQLineLink(trigger.new);   
            } 
        }
    } else {
        if(trigger.isUpdate){
        
            List<ID> cqVoidId = new List<ID>();
            List<ID> caseVoidId = new List<ID>();
            
            For(Clarification_Question__c cqLoop : trigger.new){

                if(cqLoop.Void_Question__c == true && trigger.oldMap.get(cqLoop.ID).Void_Question__c == false){

                     If(!(checkRecursive.SetOfIDsUpdate.contains(cqLoop.Id))){
                        cqVoidID.add(cqLoop.Id);
                        caseVoidId.add(cqLoop.Case__c);

                        checkRecursive.SetOfIDsUpdate.add(cqLoop.Id);
                    }                    
                }            
            }
            
            if(cqVoidID.size() > 0){
                eBSVoidFeature.updateCQQuestion(cqVoidID,caseVoidId);
            }
            
        }
        if(trigger.isInsert){
            List<case> updateCaseList = new list<case>();
            // update last question type
            For(Clarification_Question__c cqLoop : trigger.new){
                case cs = new case();
                cs.id = cqLoop.Case__c;
                if(cqLoop.Question_Type__c=='Clarification' && cqLoop.status__c  !='Closed' ){
                    cs.Last_Question_Type__c = 'Clarification';
                }
                if(cqLoop.Question_Type__c=='Proof' && cqLoop.status__c  !='Closed'){
                    cs.Last_Question_Type__c = 'Proof';
                }
                if(cqLoop.Question_Type__c=='Notification' && cqLoop.status__c  !='Closed'){
                    cs.Last_Question_Type__c = 'Notification';
                } 
                updateCaseList.add(cs);
            } 
            system.debug('updateCaseList@@@@@@@@@@@@@@@@@@@@@@@@@'+updateCaseList);
            if(!updateCaseList.isempty()){
                update updateCaseList;
            }
        }
    }
    
}