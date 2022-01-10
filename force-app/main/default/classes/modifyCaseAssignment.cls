public class modifyCaseAssignment{
    public static void caseOwnerAssignment(Set<ID> lstCaseID, Map<ID, String> oldStatus, Map<ID, String> oldAccount, String trigContext){
        List<ID> caseIDs = new List<ID>();
        List<Case> lstCaseCreate = new List<Case>();
        
        List<Case> lstCase = new List<Case>([
            Select ID, ContactID, AccountID, Status, EBS_Order_ID__c, EBS_Account_Number__c, EBS_Order__c, 
            SuppliedEmail, Clarification_Team__c, Proof_Team__c, RecordType.Name, OwnerID, hasBeenAssigned__c,
            Clarification_Hold__c
            From Case 
            Where ID =: lstCaseID]);        

        For(case c : lstCase){
            String ccaStringID = 'cca'+ c.Id;

            //Get old case values if update
            if(trigContext == 'Update'){

                //Get old case values
                String cOld = oldStatus.get(c.ID);
                String cOldAcct = oldAccount.get(c.ID);

                If
                (
                    (
                        (
                            c.Status != cOld && 
                            !(string.valueOf(c.OwnerID).startsWithIgnoreCase('005')) 
                            && c.Status != 'Awaiting Clarification Response'
                        ) && 
                        (
                            c.Status == 'Follow-up Needed' || 
                                (c.Status == 'Customer Response' &&  !(string.valueOf(c.OwnerID).startsWithIgnoreCase('005'))) ||
                                (c.Clarification_Hold__c)
                        )
                    ) ||
                    (
                        c.RecordType.Name == 'Delayed Order' &&
                        c.hasBeenAssigned__c == false
                    ) ||
                    c.AccountID != cOldAcct ||
                    c.hasBeenAssigned__c == false
                ){
                    If(!checkRecursive.SetOfIDs.contains(ccaStringID)){ 
                        caseIDs.add(c.ID);
                        checkRecursive.SetOfIDs.add(ccaStringID);
                    }   
                } 

            } else {

                If(!checkRecursive.SetOfIDs.contains(ccaStringID) && (c.Status != 'Awaiting Clarification Response' || c.Clarification_Hold__c)){ 
                    caseIDs.add(c.ID);
                    checkRecursive.SetOfIDs.add(ccaStringID);
                }
            }
        } 

        if(caseIDs.size() > 0){

            AssignCasesUsingAssignmentRules.CaseAssign(caseIDs);
        }   
    }   
}