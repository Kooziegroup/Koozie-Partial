//Script to update issues we're having with cadence
global class scheduledDay3Issue implements Schedulable {

    public void execute(SchedulableContext SC) {
        pull3DayIssue();
    }

    public void pull3DayIssue(){
    
        List<Case> lstCase = new List<Case>();   
        List<ID> lstCaseID = new List<ID>();   
        
        List<Case> caseExtract = new List<Case>
            ([Select ID, CADENCE_OWNER_CHANGE__C, 
                RECORDTYPE.NAME, OWNER.NAME
            FROM CASE
            WHERE CADENCE_OWNER_CHANGE__C = TRUE
            AND RECORDTYPE.NAME = 'Clarification'
            AND STATUS IN ('Day 3 Call','Day 1 Call (24 Hour)','Day 9 Escalate to Sales','New')
            AND OWNER.NAME = 'Clarification Pending']);    
            
        If(caseExtract .size() > 0){
            For(Case caseLoop : caseExtract){
            
                caseLoop.CADENCE_OWNER_CHANGE__C = FALSE;      
                lstCaseID.add(caseLoop.ID);      
                lstCase.add(caseLoop);
            }
        }    
    
        if(lstCase.size() >0){
            try{
                Update lstCase;
                AssignCasesUsingAssignmentRules.CaseAssign(lstCaseID);
            } catch (DMLException e){
                system.debug(e.getMessage());
            }            
        }    
    
    }
}