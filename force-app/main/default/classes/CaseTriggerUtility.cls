public class CaseTriggerUtility {
    
    public static void updateVIPLargeOrder(List<case> caseList){
        //update vip large order lookup
        
        set <id> orderidset = new set<id>();
        list<case> updateCaseList = new list<case>();
        for(case cse: caseList){
            orderidset.add(cse.EBS_Order__c);
        }
        List<EBS_Order__c> OrderList = [select id,Order_Header_Total__c  from EBS_Order__c where id in:orderidset];
        Map<id,decimal> ordermap = new map<id,decimal>();
        for(EBS_Order__c ord:OrderList){
            ordermap.put(ord.id,ord.Order_Header_Total__c);
        }
        for(case cse:caseList){
            
            system.debug (ordermap);
            string largeOrderType = [select id ,name from recordtype where name='Large Orders'].id;

            if(cse.RecordTypeId !=null && cse.RecordTypeId !=largeOrderType){
                if(ordermap!=null){
                    if(ordermap.get(cse.EBS_Order__c) !=null && ordermap.get(cse.EBS_Order__c)>=20000){
                        List<case> cs = new List<case>();
                        cs = [select id,EBS_Order__c,recordtype.name  from case where  recordtype.name ='Large orders' and  EBS_Order__c=:cse.EBS_Order__c limit 1];
                        if(!cs.isempty()){
                            cse.Large_Order_Parent__c =cs[0].id;
                        }
                    }
                }
            }
        }
    }
    
    public static void UpdateEmailOnCase(List<Case>caseList) {
        Map<Id,String>mapOfIdVsEbsAccountNumber = new Map<Id,String>();
        //Map<Id,String> mapofIdVsEbsNumber = new Map<Id,String>();
        Map<String,Account> mapofEbsVsAccount = new Map<String,Account>();
        //Set<String>accqueue = new Set<String>();
        Map<String, String>mapOfAcoountEbsVsParentEbs = new  Map<String, String>();
        Id ebs = Label.X33381_id;
        Id coop = Label.Calendar_Coop;
        Id calendar = Label.Calendar_Dedicated;
        Id bookstore = Label.Bookstore;
        Id hotel = Label.Hotel;
        Id church = Label.Church;
        Id casino = Label.Casino;
        Id defau = Label.Default;

        for(Case cs:caseList){
            if(cs.EBS_Account_Number__c != null){
                mapOfIdVsEbsAccountNumber.put(cs.Id, cs.EBS_Account_Number__c); 
            } 
        }
       
        for(Account acc: [Select Id, Routing_Override__c, EBS_Num__c, Customer_Category__c, Logo__c, Customer_Account_Number__c,
        EBS_Parent_ID__c, Parent_EBS__c, ParentId FROM Account WHERE Customer_Account_Number__c IN: mapOfIdVsEbsAccountNumber.values()]){
                            
            mapofEbsVsAccount.put(acc.Customer_Account_Number__c,acc);

            if(acc.ParentId != null && acc.EBS_Parent_ID__c != null && acc.Parent_EBS__c != null){

                mapOfAcoountEbsVsParentEbs.put(acc.Customer_Account_Number__c, acc.Parent_EBS__c);
                System.debug('============ ' + mapOfAcoountEbsVsParentEbs.keySet());
                System.debug('============ ' + mapOfAcoountEbsVsParentEbs.values());
            }
        }
        Map<String, Account_Clarification_Team__c> mapOfEbsVsACT = new Map<String, Account_Clarification_Team__c>();

        for(Account_Clarification_Team__c actt : [Select Id, Name, From_Email__c, Account_Queue__c, Customer_Category__c, 
            EBS_Num__c, Logo__c FROM Account_Clarification_Team__c WHERE EBS_Num__c =:mapOfAcoountEbsVsParentEbs.values() OR EBS_Num__c =:mapofEbsVsAccount.keyset()]){
                    
                mapOfEbsVsACT.put(actt.EBS_Num__c, actt);

            }
                System.debug('========= '+ mapOfEbsVsACT);

        for(case ca:caseList){
            System.debug('Entered into For Loop');
            if(ca.EBS_Account_Number__c != null && mapofEbsVsAccount.containskey(ca.EBS_Account_Number__c)){
                Account accc = mapofEbsVsAccount.get(ca.EBS_Account_Number__c);    
                System.debug('Entered into If' + accc);  //0009
                
                if(accc.EBS_Parent_ID__c != null){
                    String ebsp = accc.EBS_Parent_ID__c;
                    System.debug('===========' + accc.EBS_Parent_ID__c);       //0008
                   
                    Account ac = [Select Id, Routing_Override__c, EBS_Num__c, Customer_Category__c, Logo__c, Customer_Account_Number__c,
                    EBS_Parent_ID__c, Parent_EBS__c, ParentId, Parent.ParentId, Parent.Logo__c, Parent.Routing_Override__c, Parent.EBS_Num__c,
                    Parent.Customer_Category__c, Parent.Customer_Account_Number__c FROM Account WHERE EBS_Parent_ID__c =:ebsp];
                    System.debug('======= ' +ac);
                    System.debug('======= ' +ac.Parent);
                    System.debug('======= ' +ac.Parent.Logo__c);

                    
                    if(ac.Parent.Logo__c == 'Calendar Coop'){
                        System.debug('Went inside Parent');
                        ca.Customer_To_Email__c = 'csinfo@calendarcs.com';
                        ca.Proof_Team_Link__c = coop;
                        ca.Clarification_Team_Link__c = coop;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }
                    
                    else if(ac.Parent.Routing_Override__c == 'Calendar Dedicated'){
                        ca.Customer_To_Email__c = 'coopspecialtyteam@kooziegroup.com';
                        ca.Proof_Team_Link__c = calendar;
                        ca.Clarification_Team_Link__c = calendar;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }
                    
                    else if(ac.Parent.Customer_Category__c == 'Bookstore'){
                        ca.Customer_To_Email__c = 'anchorwallace@anchorwallace.com';
                        ca.Proof_Team_Link__c = bookstore;
                        ca.Clarification_Team_Link__c = bookstore;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }

                    else if(ac.Parent.Customer_Category__c == 'Church'){
                        ca.Customer_To_Email__c = 'anchorwallace@anchorwallace.com';
                        ca.Proof_Team_Link__c = Church;
                        ca.Clarification_Team_Link__c = Church;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }

                    else if(ac.Parent.Customer_Category__c == 'Casino'){
                        ca.Customer_To_Email__c = 'cshotel@kooziegroup.com';
                        ca.Proof_Team_Link__c = casino;
                        ca.Clarification_Team_Link__c = casino;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }

                    else if(ac.Parent.Customer_Category__c == 'Hotel'){
                        ca.Customer_To_Email__c = 'cshotel@kooziegroup.com';
                        ca.Proof_Team_Link__c = hotel;
                        ca.Clarification_Team_Link__c = hotel;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }

                    else if(ac.Parent.Customer_Account_Number__c == '33381'){
                        ca.Customer_To_Email__c = 'proformabcsteam@kooziegroup.com';
                        ca.Proof_Team_Link__c = ebs;
                        ca.Clarification_Team_Link__c = ebs;
                        System.debug('========= '+ ca.Customer_To_Email__c);
                    }

                    else if(ac.Parent.Customer_Account_Number__c != null){
                        Account_Clarification_Team__c actt = mapOfEbsVsACT.get(ac.Parent.Customer_Account_Number__c);
                        ca.Customer_To_Email__c = actt.From_Email__c;
                        ca.Proof_Team_Link__c = actt.Id;
                        ca.Clarification_Team_Link__c = actt.Id;
                        System.debug('============== '+ca.Customer_To_Email__c);
                    }

                    else{
                        ca.Customer_To_Email__c = 'customerservice@kooziegroup.com';
                        ca.Proof_Team_Link__c = defau;
                        ca.Clarification_Team_Link__c = defau;
                        System.debug('============== '+ca.Customer_To_Email__c);
                    } 
                }
                else if(accc.EBS_Parent_ID__c == null){

                Account acc = mapofEbsVsAccount.get(ca.EBS_Account_Number__c);
                
                if(acc.Logo__c == 'Calendar Coop'){
                    ca.Customer_To_Email__c = 'csinfo@calendarcs.com';
                    ca.Proof_Team_Link__c = coop;
                    ca.Clarification_Team_Link__c = coop;
                }

                else if(acc.Routing_Override__c == 'Calendar Dedicated'){
                    ca.Customer_To_Email__c = 'coopspecialtyteam@kooziegroup.com';
                    ca.Proof_Team_Link__c = calendar;
                    ca.Clarification_Team_Link__c = calendar;
                }

                else if(acc.Customer_Category__c == 'Bookstore'){
                    ca.Customer_To_Email__c = 'anchorwallace@anchorwallace.com';
                    ca.Proof_Team_Link__c = bookstore;
                    ca.Clarification_Team_Link__c = bookstore;
                }

                else if(acc.Customer_Category__c == 'Church'){
                    ca.Customer_To_Email__c = 'anchorwallace@anchorwallace.com';
                    ca.Proof_Team_Link__c = Church;
                    ca.Clarification_Team_Link__c = Church;
                }

                else if(acc.Customer_Category__c == 'Casino'){
                    ca.Customer_To_Email__c = 'cshotel@kooziegroup.com';
                    ca.Proof_Team_Link__c = casino;
                    ca.Clarification_Team_Link__c = casino;
                }

                else if(acc.Customer_Category__c == 'Hotel'){
                    ca.Customer_To_Email__c = 'cshotel@kooziegroup.com';
                    ca.Proof_Team_Link__c = hotel;
                    ca.Clarification_Team_Link__c = hotel;
                }

                else if(acc.Customer_Account_Number__c == '33381'){
                    ca.Customer_To_Email__c = 'proformabcsteam@kooziegroup.com';
                    ca.Proof_Team_Link__c = ebs;
                    ca.Clarification_Team_Link__c = ebs;
                }

                else if(mapOfEbsVsACT.containskey(ca.EBS_Account_Number__c)){
                    System.debug('======== '+ mapOfEbsVsACT.containskey(ca.EBS_Account_Number__c));
                    Account_Clarification_Team__c acct = mapOfEbsVsACT.get(ca.EBS_Account_Number__c);
                    ca.Customer_To_Email__c = acct.From_Email__c;
                    ca.Proof_Team_Link__c = acct.Id;
                    ca.Clarification_Team_Link__c = acct.Id;
                } 
                else{
                    ca.Customer_To_Email__c = 'customerservice@kooziegroup.com';
                    ca.Proof_Team_Link__c = defau;
                    ca.Clarification_Team_Link__c = defau;
                    System.debug('============== '+ca.Customer_To_Email__c);
                }
            }  
        }
            else{
                ca.Customer_To_Email__c = 'customerservice@kooziegroup.com';
                ca.Proof_Team_Link__c = defau;
                ca.Clarification_Team_Link__c = defau;
                System.debug('============== '+ca.Customer_To_Email__c);
            }        
        }           
    }
}