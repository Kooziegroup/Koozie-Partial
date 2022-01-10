public class csTriggerHandler{

    public static void surveyAgentUpdate(List<Custom_Survey__c> lstCS){

        Map<String, User> mpUser = new Map<String,User>();
        List<Custom_Survey__c> csUpdate = new List<Custom_Survey__c>();
        
        List<User> lstUser = new List<User>
            ([Select ID, Agent_ID__c
              From User
              Where Agent_ID__c != null]);
              
        For(User u : lstUser){
            mpUser.put(u.Agent_ID__c, u);
        }
    
        For(Custom_Survey__c cs : lstCS){
            Custom_Survey__c csNew = new Custom_Survey__c(ID = cs.Id);
            
            if(mpUser.get(cs.Agent_ID__c) != null){            
                csNew.Agent_Name__c = mpUser.get(cs.Agent_ID__c).ID;
            }
            
            csUpdate.add(csNew);
        }
        
        If(csUpdate.size() > 0){
            update csUpdate;
        }    
    
    }

}