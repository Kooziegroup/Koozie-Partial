trigger emailToCaseTA on Case (before insert, before update) {

    Map<string, list<string>> CaseMap = new Map<string, list<string>>();
    List<Contact> idContact = new List<Contact>(); 
    List<Contact> emailContact = new List<Contact>();
    List<Account> idAccount = new List<Account>();
    List<EBS_Order__c> idOrder = new List<EBS_Order__c>();
    
    List<Account_Clarification_Team__c> lstACT = new List<Account_Clarification_Team__c>([Select ID, Name, Account_Team__c, From_Email__c
        From Account_Clarification_Team__c]);

    RecordType rtCase = [Select ID From RecordType Where sObjectType = 'Case' and Name = 'Clarification' Limit 1];

    Map<String, List<Contact>> mpContactList = emailToCaseContact.emailToCaseContact(trigger.new);
    Map<String, Account> mpAcct = new Map<String, Account>();
    List<String> lstAcctID = new List<String>();
    
    Map<String, EBS_Order__c> mpOrder = new Map<String, EBS_Order__c>();
    List<String> lstOrdID = new List<String>();
    
    For(Case c : trigger.new){
        if(c.EBS_Account_Number__c!= null && c.EBS_Account_Number__c!= ''){
            lstAcctID.add(c.EBS_Account_Number__c);
        }
        
        if(c.EBS_Order_ID__c != null && c.EBS_Order_ID__c!= ''){
            lstOrdID.add(c.EBS_Order_ID__c);            
        }
    }
    
    if(lstAcctID.size() > 0){
        List<Account> lstAcct = [Select ID, Customer_Account_Number__c from Account where Customer_Account_Number__c =: lstAcctID];
        
        For(Account acct : lstAcct){
            mpAcct.put(acct.Customer_Account_Number__c, acct);
        }
        
        //mpAcct = new Map<ID, Account>(lstAcct);
    }
    
    if(lstOrdID.size() > 0){
        List<EBS_Order__c> lstOrd = [Select ID,EBS_Order_Number__c from EBS_Order__c where EBS_Order_Number__c =: lstOrdID];
        
        For(EBS_Order__c eOrd : lstOrd){
            mpOrder.put(eOrd.EBS_Order_Number__c, eOrd);
        }
        
        //mpOrder = new Map<ID, EBS_Order__c>(lstOrd);
    }   

    For(Case c : trigger.new){

        //Set up account and order variables
        string ebsAccountId = (c.EBS_Account_Number__c!= null && c.EBS_Account_Number__c!= '') ? c.EBS_Account_Number__c: null;
        string ebsOrder = (c.EBS_Order_ID__c != null && c.EBS_Order_ID__c != '') ? c.EBS_Order__c: null; 

        //Search for accountID and assign to case
        if(trigger.isInsert){// && c.ContactID == null){
            
            if(mpAcct.get(ebsAccountId) != null){        
                c.AccountID = mpAcct.get(ebsAccountId).ID;               
            }
        }           

        //Don't do anything if default values are null or contact selected
        if(c.SuppliedEmail != null && c.SuppliedEmail != '' && c.ContactID == null)  {
            
            //Set up default contact
            string ebsContactId = mpContactList.get(c.SuppliedEmail)[0].ID;

            //Search for contact associated with account. 
            For(Contact contSearch : mpContactList.get(c.SuppliedEmail)){
                if(contSearch.accountID == c.AccountID){
                    ebsContactId = contSearch.ID;
                }
            }
            
            if(trigger.isInsert && c.ContactID == null){
                c.contactID = ebsContactID;
            }     
        }     

        //Search for OrderID and assign to case
        if(mpOrder.get(ebsOrder) != null){
        
            c.EBS_Order__c= mpOrder.get(ebsOrder).ID; 
        }

        //Get ACT record for Clari and add to case record
        if(c.Clarification_Team__c != null && c.Clarification_Team__c != ''){
                
            //Loop through list to get ID
            For(Account_Clarification_Team__c act : lstACT){
                if(c.Clarification_Team__c == act.Account_Team__c){
                    c.Clarification_Team_Link__c = act.ID;
                }
            }
        }
            
        //Get ACT record for Proof and add to case record
        if(c.Proof_Team__c != null && c.Proof_Team__c != ''){
                
            //Loop through list to get ID
            For(Account_Clarification_Team__c act : lstACT){
               if(c.Proof_Team__c == act.Account_Team__c){
                    c.Proof_Team_Link__c = act.ID;
                }
            }
        } 
    }
}