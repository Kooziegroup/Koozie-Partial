public class AssignCasesUsingAssignmentRulesPB
{
    @InvocableMethod
    public static void CaseAssign(List<id> CaseIds)
    {
        CaseAssignPB(CaseIDs);
    }
    
    @future(callout=true)
    public static void CaseAssignPB(List<id> CaseIds){
        //Variables to process cases
        List<Case> lstCase = new List<Case>();
        Map<String, String> mpProfile = new Map<String, String>();
        List<Case> Cases = [select id,Case_Reassigned__c,createdBy.ProfileID from Case where Case.id in :CaseIds];   
        
        List<Profile> lstProfile = new List<Profile>([Select id, name from profile where name like '%claim%' or name like '%customer service%' or name like '%administrator%']);
        
        For(Profile pList : lstProfile){        
            mpProfile.put(pList.Id, pList.Name);
        }         
            
        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];                        
            
        For(Case c : cases){
            if(mpProfile.get(c.createdBy.ProfileID) == null){        
                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                   
                //Setting the DMLOption on Case instance
                c.setOptions(dmlOpts);
                lstCase.add(c);
            }
        }
        
        if(lstCase.size() >0){
            update lstCase;
        }        
    }  
}