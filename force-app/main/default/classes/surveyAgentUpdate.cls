public class surveyAgentUpdate{
    @future
    public static void surveyAgentUpdate(List<String> lstCSID, List<String> lstANI){

        Map<String, User> mpUser = new Map<String,User>();
        Map<String, Contact> mpCont = new Map<String,Contact>();
        Map<String, Account> mpAcct = new Map<String,Account>();
        List<Custom_Survey__c> csUpdate = new List<Custom_Survey__c>();
        system.debug('LSTANI: ' + lstANI);
        
        //Add users (contacts and accounts) to map     
        For(User u : [Select ID, Agent_ID__c, Name, isActive
                     From User
                     Where Agent_ID__c != null]){
            mpUser.put(u.Agent_ID__c, u);
        }
        
        For(Contact con : [Select ID, Phone, AccountID, Clean_Phone_Number__c,Clean_Mobile_Number__c
                          From Contact
                          Where Phone != null 
                          AND (Clean_Phone_Number__c =: lstANI OR Clean_Mobile_Number__c =:lstANI)
                          AND Recordtype.Name = 'CRM Contact'
                          Limit 10]){
            mpCont.put(con.Clean_Phone_Number__c, con);
            mpCont.put(con.Clean_Mobile_Number__c, con);
        }
        
        For(Account acc : [Select ID, Phone, Clean_Phone_Number__c
                          From Account
                          Where Phone != Null 
                          AND Clean_Phone_Number__c =: lstANI
                          Limit 10]){
            mpAcct.put(acc.Clean_Phone_Number__c, acc);
        }                

        //Loop through and add information to survey
        For(Custom_Survey__c cs : [Select ID, Agent_ID__c, Agent_Name__c, Contact_Name__c, 
                                    Account_Name__c, ANI__c 
                                    FROM Custom_Survey__c 
                                    Where ID =: lstCSID]){
            Custom_Survey__c csNew = new Custom_Survey__c(ID = cs.Id);
            
            //Add user information if a match
            if(mpUser.get(cs.Agent_ID__c) != null){
                if(mpUser.get(cs.Agent_ID__c).isActive){
                    csNew.Agent_Name__c = mpUser.get(cs.Agent_ID__c).ID;
                } else {
                     csNew.Agent_Name_Inactive__c = mpUser.get(cs.Agent_ID__c).Name;
                }
            }

            //Add contact and account information if a match 
            if(mpCont.get(cs.ANI__c) != null){
                csNew.Contact_Name__c = mpCont.get(cs.ANI__c).ID;    
                csNew.Account_Name__c = (mpCont.get(cs.ANI__c).AccountId != null) ? mpCont.get(cs.ANI__c).AccountId : null;        
            } else if(mpAcct.get(cs.ANI__c) != null){
                csNew.Account_Name__c = mpAcct.get(cs.ANI__c).ID;
            }            

            csUpdate.add(csNew);
        }
        
        If(csUpdate.size() > 0){
            update csUpdate;
        }    
    }
}