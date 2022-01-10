trigger emailMessageTriggerHandler on EmailMessage (after insert) {

    List<Case> lstCase = new List<Case>();
    List<ID> lstStringID = new List<ID>();
    Map<ID, ID> emCaseMap = new Map<ID,ID>();
    
    //Manage Think Automation case inserts
    Set<ID> lstEmailId = trigger.newMap.keyset();     
    
    List<ID> emID = new List<ID>(lstEmailId);   
    
    For(EmailMessage em : trigger.new){
        system.debug(em.ParentId);
        lstStringID.add(em.ParentID);    
        emCaseMap.put(em.ParentID,em.ID); 
    }
    
    if(lstStringID.size() > 0){
        lstCase = [Select ID, Status, RecordType.Name 
                    From Case
                    Where ID =: lstStringID];
                    
        lstStringID.clear();
        
        For(Case caseCheck : lstCase){
            
            system.debug(caseCheck.status);
            system.debug(caseCheck.RecordType.Name);
        
           If(caseCheck.RecordType.Name == 'Clarification' && caseCheck.Status == 'Closed'){
                if(!checkRecursive.SetOfIDs.contains(caseCheck.Id)){
                    lstStringID.add(emCaseMap.get(caseCheck.ID));
                    checkRecursive.SetOfIDs.add(caseCheck.ID); 
                }
           }
        }
        
        if(lstStringID.size() > 0){
            clarificationEmailHandler.closeClariHandler(lstStringID);           
        }
    }
}