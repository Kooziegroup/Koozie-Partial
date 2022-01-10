trigger callCaseAssignment on Case  (after insert, after update) {

   List<ID> caseIDs = new List<ID>();
   List<Case> lstCaseCreate = new List<Case>();

    For(case c : trigger.new){

        String ccaStringID = 'cca'+ c.Id;

        //Get old case values if update
        if(trigger.isupdate){

            //Get old case values
            Case cOld = trigger.oldMap.get(c.ID);

            If(
                (c.Status != cOld.status && !(string.valueOf(c.OwnerID).startsWithIgnoreCase('005'))) && 
                
                (c.Status == 'Day 1 Call (24 Hour)' ||
                 c.Status == 'Day 3 Call' ||
                 c.Status == 'Day 9 Escalate to Sales' ||
                 c.Status == 'Customer Response') &&
                 (!c.Clarification_Hold__c)
            ){
                If(!checkRecursive.SetOfIDs.contains(ccaStringID)){         
                        
                        caseIDs.add(c.ID);
                        checkRecursive.SetOfIDs.add(ccaStringID);
                }   
            }         

        } else {

            If(!checkRecursive.SetOfIDs.contains(ccaStringID) && c.Status != 'Awaiting Clarification'){ 
                    
                    caseIDs.add(c.ID);
                    checkRecursive.SetOfIDs.add(ccaStringID);
                }
        }    
    } 

    if(caseIDs.size() > 0){

        AssignCasesUsingAssignmentRules.CaseAssign(caseIDs);
    }
}