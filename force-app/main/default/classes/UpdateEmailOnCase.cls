public with sharing class UpdateEmailOnCase {
    public static void UpdateEmailOnCase(List<Case>caseList) {
        Map<Id,String>mapOfIdVsEbsAccountNumber = new Map<Id,String>();
        Map<Id,String> mapofIdVsEbsNumber = new Map<Id,String>();
        Set<String>accqueue = new Set<String>();
        for(Case cs:caseList){
            if(cs.EBS_Account_Number__c != null){
                mapOfIdVsEbsAccountNumber.put(cs.Id, cs.EBS_Account_Number__c);
            } 
        }
        //Set<Id> parentId = new Set<Id>();
        
        List<Account> acclist = [Select Id, Corporate_Route__c, EBS_Num__c, Customer_Category__c, Logo__c, Customer_Account_Number__c, EBS_Parent_ID__c, Parent_EBS__c
        FROM Account WHERE Customer_Account_Number__c IN: mapOfIdVsEbsAccountNumber.values()];
        System.debug('======== ' +acclist);
        for(Account acc:acclist){
            if(acc.EBS_Parent_ID__c == null && acc.Parent_EBS__c == null){
                accqueue.add(acc.Customer_Account_Number__c);
                System.debug('======== '+acc.Customer_Account_Number__c);
                mapofIdVsEbsNumber.put(acc.Id, acc.Customer_Account_Number__c);
            } else{
                accqueue.add(acc.Parent_EBS__c);
                System.debug('======== '+acc.EBS_Parent_ID__c);
                mapofIdVsEbsNumber.put(acc.Id, acc.Parent_EBS__c);  
            } 
        }
        if(acclist.size()>0){
            List<Account_Clarification_Team__c>actlist = [Select Id, Name, From_Email__c, Account_Queue__c, Customer_Category__c, EBS_Num__c, Logo__c
            FROM Account_Clarification_Team__c WHERE EBS_Num__c IN:accqueue];
            List<Account_Clarification_Team__c> defaultAct = [Select Id, name, From_Email__c, EBS_Num__c FROM Account_Clarification_Team__c
            WHERE name = 'Default'];
            System.debug('========== ' +actlist);
            for(Account_Clarification_Team__c ac:actlist){
                System.debug('========== ' +ac.Name);
                System.debug('========== ' +ac.From_Email__c);
                System.debug('========== ' +ac.Account_Queue__c);
                System.debug('========== ' +ac.EBS_Num__c);
                System.debug('========== ' +ac.Logo__c);
                System.debug('========== ' +ac.Customer_Category__c); 
                               
            }           
            if(actlist.size()>0){
                for(Account_Clarification_Team__c act:actlist){
                    for(Case c:caseList){
                        System.debug('========== ' +mapOfIdVsEbsAccountNumber.get(c.Id));
                        /* if(act.Logo__c == 'Calendar Coop' && act.Account_Queue__c == null && act.Customer_Category__c == null && act.EBS_Num__c == null){
                            c.Customer_To_Email__c = act.From_Email__c;
                            System.debug('============== '+c.Customer_To_Email__c);
                        } */
                        if(act.Logo__c == 'Calendar Coop'){
                            c.Customer_To_Email__c = act.From_Email__c;
                            c.Proof_Team_Link__c = act.Id;
                            c.Clarification_Team_Link__c = act.Id;
                            System.debug('============== '+c.Customer_To_Email__c);
                            System.debug('============== '+c.Proof_Team_Link__c);
                            System.debug('============== '+c.Clarification_Team_Link__c);
                        }
                        /* if(act.Account_Queue__c == 'Calendar Dedicated' && act.Logo__c == null && act.Customer_Category__c == null && act.EBS_Num__c == null){
                            c.Customer_To_Email__c = act.From_Email__c;
                            System.debug('============== '+c.Customer_To_Email__c);
                        } */
                        else if(act.Account_Queue__c == 'Calendar Dedicated'){
                            c.Customer_To_Email__c = act.From_Email__c;
                            c.Proof_Team_Link__c = act.Id;
                            c.Clarification_Team_Link__c = act.Id;
                            System.debug('============== '+c.Customer_To_Email__c);
                            System.debug('============== '+c.Proof_Team_Link__c);
                            System.debug('============== '+c.Clarification_Team_Link__c);
                        }
                        /* if(act.Customer_Category__c == 'Bookstore' || act.Customer_Category__c == 'Church' && act.Logo__c == null && act.Account_Queue__c == null && act.EBS_Num__c == null){
                            c.Customer_To_Email__c = act.From_Email__c;
                            System.debug('============== '+c.Customer_To_Email__c);
                        } */
                        else if(act.Customer_Category__c == 'Bookstore' || act.Customer_Category__c == 'Church' ){
                            c.Customer_To_Email__c = act.From_Email__c;
                            c.Proof_Team_Link__c = act.Id;
                            c.Clarification_Team_Link__c = act.Id;
                            System.debug('============== '+c.Customer_To_Email__c);
                            System.debug('============== '+c.Proof_Team_Link__c);
                            System.debug('============== '+c.Clarification_Team_Link__c);
                        }
                        /* if(act.Customer_Category__c == 'Casino' || act.Customer_Category__c == 'Hotel' && act.Logo__c == null && act.Account_Queue__c == null && act.EBS_Num__c == null){
                            c.Customer_To_Email__c = act.From_Email__c;
                            System.debug('============== '+c.Customer_To_Email__c);
                        } */
                        else if(act.Customer_Category__c == 'Casino' || act.Customer_Category__c == 'Hotel' ){
                            c.Customer_To_Email__c = act.From_Email__c;
                            c.Proof_Team_Link__c = act.Id;
                            c.Clarification_Team_Link__c = act.Id;
                            System.debug('============== '+c.Customer_To_Email__c);
                            System.debug('============== '+c.Proof_Team_Link__c);
                            System.debug('============== '+c.Clarification_Team_Link__c);
                        }
                        /* if(act.EBS_Num__c == '33381' && act.Logo__c == null && act.Account_Queue__c == null && act.Customer_Category__c == null){
                            c.Customer_To_Email__c = act.From_Email__c;
                            System.debug('============== '+c.Customer_To_Email__c);
                        } */
                        else if(act.EBS_Num__c == '33381' ){
                            c.Customer_To_Email__c = act.From_Email__c;
                            c.Proof_Team_Link__c = act.Id;
                            c.Clarification_Team_Link__c = act.Id;
                            System.debug('============== '+c.Customer_To_Email__c);
                            System.debug('============== '+c.Proof_Team_Link__c);
                            System.debug('============== '+c.Clarification_Team_Link__c);
                        }
                        else if(mapOfIdVsEbsAccountNumber.get(c.Id) != null && act.EBS_Num__c == mapOfIdVsEbsAccountNumber.get(c.Id)){
                            c.Customer_To_Email__c = act.From_Email__c;
                            c.Proof_Team_Link__c = act.Id;
                            c.Clarification_Team_Link__c = act.Id;
                            System.debug('============== '+c.Customer_To_Email__c);
                            System.debug('============== '+c.Proof_Team_Link__c);
                            System.debug('============== '+c.Clarification_Team_Link__c);
                        }   
                    }
                }   
            }
            else if(defaultAct.size()>0){
                for(Account_Clarification_Team__c ac:defaultAct){
                    for(Case ca:caseList){
                        if(mapOfIdVsEbsAccountNumber.get(ca.Id) != null && ac.EBS_Num__c == null || ac.EBS_Num__c != mapOfIdVsEbsAccountNumber.get(ca.Id)){
                            System.debug('Enter into If');
                            ca.Customer_To_Email__c = ac.From_Email__c;
                            ca.Proof_Team_Link__c = ac.id;
                            ca.Clarification_Team_Link__c = ac.id;
                            System.debug('============== '+ca.Customer_To_Email__c);
                        }
                    }
                } 
            }      
        }
    }
}