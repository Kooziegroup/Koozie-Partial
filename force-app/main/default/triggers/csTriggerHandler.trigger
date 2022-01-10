trigger csTriggerHandler on Custom_Survey__c (after insert) {
    If(trigger.isInsert){
        if(trigger.isAfter){
        
            List<String> lstANI = new List<String>();
            List<String> lstCSID = new List<String>();
        
            For(Custom_Survey__c cs : trigger.new){
                lstANI.add(cs.ANI__c); 
                lstCSID.add(cs.ID);           
            }
            surveyAgentUpdate.surveyAgentUpdate(lstCSID, lstANI);
            csTriggerHandler.surveyAgentUpdate(trigger.new);
        }
    }
}