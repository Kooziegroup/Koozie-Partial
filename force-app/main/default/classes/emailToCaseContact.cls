public with sharing class emailToCaseContact {
    public static Map<String, List<Contact>> emailToCaseContact(List<Case> caseList) {

        //For Email matching
        List<string> ebsEmailList = new List<String>();
        Set<string> ebsEmailSet = new Set<string>();
        Set<string> emailListSet = new Set<string>();
        Map<String, List<Contact>> ebsEMailMap = new Map<String, List<Contact>>();
        Map<String, String> mpAccountEmail = new Map<String, String>();
        Map<String, String> mpCaseRTEmail = new Map<String, String>();

        //For domain matching
        List<string> ebsDomainList = new List<String>();
        Set<string> ebsDomainSet = new Set<string>();
        Set<string> domainListSet = new Set<string>();        
        Map<String, List<Contact>> ebsDomainMap = new Map<string, List<Contact>>();

        //Get list of email addresses to query
        For(Case cCont : caseList){
            if(cCont.SuppliedEmail != null && cCont.SuppliedEmail != '') {
                ebsEmailList.add(cCont.SuppliedEmail);   
                ebsEmailSet.add(cCont.SuppliedEmail);
                mpAccountEmail.put(cCont.SuppliedEmail, cCont.EBS_Account_Number__c);
                mpCaseRTEmail.put(cCont.SuppliedEmail, cCont.RecordType.Name);
                system.debug(mpAccountEmail);
            }
        }

        if(ebsEmailList.size() > 0){

            //Get list of contacts in Salesforce
            List<Contact> contList = new List<Contact>([SELECT ID, AccountID, Contact_Status__c, Responsibility_Type__c, Email 
                FROM Contact 
                WHERE Recordtype.Name != 'Website Contact' 
                AND Account.Status__c != 'Inactive'
                AND email =: ebsEmailList]);

            if(contList.size()> 0){

                For(Contact contListToMap : contList){

                    If(emailListSet.contains(contListToMap.Email)){
                        //If email exists in map, add new contact to map
                        List<Contact> contListMap = new List<Contact>();
                        contListMap = ebsEmailMap.get(contListToMap.Email);
                        contListMap.add(contListToMap);
                        ebsEmailMap.put(contListToMap.Email, contListMap);

                        ebsEmailSet.remove(contListToMap.Email);
                    } else {
                        //If email is not in map, just add values to map
                        List<Contact> contListMap = new List<Contact>();
                        contListMap.add(contListToMap);
                        ebsEmailMap.put(contListToMap.Email, contListMap);
                    }                    
                }

            //If there's no match, parse the email address to include account
            }else {

                if(ebsEmailSet.size() > 0){

                    List<String> strList = new List<String>(ebsEmailSet);
                    List<Contact> contInsert = new List<Contact>();

                    For(String contEmailString : strList){
                        String strDomain = contEmailString.split('@').get(1);     
                        Contact con = new Contact();                   
                        
                        if(mpCaseRTEmail.get(contEmailString) == 'Clarification'){
                            String caseAcct = mpAccountEmail.get(contEmailString);
                            Account acctID = new Account(Customer_Account_Number__c=caseAcct);
                            con = new Contact(firstname='Clarification', lastName= contEmailString, account=acctID, email=contEmailString, responsibility_type__c = 'SALES_SERVICE');
                        } else {
                            con = new Contact(firstname='Email', lastName= contEmailString, email=contEmailString, responsibility_type__c = 'SALES_SERVICE');
                        }
                        contInsert.add(con);
                    }

                    if(contInsert.size()> 0){
                        insert contInsert;

                        For(Contact con : contInsert){
                            List<Contact> lstContMap = new List<Contact>();
                            lstContMap.add(con);
                            ebsDomainMap.put(con.Email, lstContMap);
                        }

                        //Add contacts to map
                        ebsEmailMap.putAll(ebsDomainMap);
                    }
                }
            }
        } 

        //Return map of contacts
        return ebsEMailMap;
    }

    public static Map<String, List<Responsibility_Type__c>> emailToCaseRT(List<Case> caseList) {

        //For Email matching
        List<string> ebsEmailList = new List<String>();
        Set<string> ebsEmailSet = new Set<string>();
        Set<string> emailListSet = new Set<string>();
        List<String> acctIDList = new List<String>();
        Map<string, Case> mpCaseDetails = new Map<string, Case>();
        Map<String, List<Responsibility_Type__c>> ebsEMailMap = new Map<String, List<Responsibility_Type__c>>();

        //For domain matching
        List<string> ebsDomainList = new List<String>();
        Set<string> ebsDomainSet = new Set<string>();
        Set<string> domainListSet = new Set<string>();        
        Map<String, List<Responsibility_Type__c>> ebsDomainMap = new Map<string, List<Responsibility_Type__c>>();

        //Get list of email addresses to query
        For(Case cRespType : caseList){
            if(cRespType.SuppliedEmail != null && cRespType.SuppliedEmail != '') {
                ebsEmailList.add(cRespType.SuppliedEmail);   
                ebsEmailSet.add(cRespType.SuppliedEmail);
                acctIDList.add(cRespType.EBS_Account_Number__c);
                mpCaseDetails.put(cRespType.SuppliedEmail, cRespType);
            }
        }

        if(ebsEmailList.size() > 0){

            //Get list of contacts in Salesforce
            List<Responsibility_Type__c> rtList = new List<Responsibility_Type__c>
            ([SELECT ID, Contact_Status__c, Contact__r.Account.Status__c, Responsibility_Type__c, Email__c 
                FROM Responsibility_Type__c  
                WHERE Responsibility_Type__c != 'Website' 
                AND Contact__r.Account.Status__c != 'Inactive'
                AND Email__c =: ebsEmailList]);
                
            
            Map<String, Contact> mpContList = new Map<String, Contact>();
            Map<String, Account> mpAcctList = new Map<String, Account>();
            
            List<Contact> contList = new List<Contact>
                ([SELECT ID, Account.Status__c, Email 
                FROM Contact  
                WHERE Account.Status__c != 'Inactive'
                AND Email =: ebsEmailList]);    
                
            List<Account> AccoutnList = new List<Account>
                ([SELECT ID, Customer_Account_Number__c
                FROM Account
                WHERE Customer_Account_Number__c =: acctIDList]);                    

            For(Contact con : contList){
                mpContList.put(con.Email, con);         
            }
            
            For(Account acct : AccoutnList){
                mpAcctList.put(acct.Customer_Account_Number__c, acct);         
            }                        

            if(rtList.size()> 0){

                For(Responsibility_Type__c RTListToMap : rtList){

                    If(emailListSet.contains(RTListToMap.Email__c)){
                        //If email exists in map, add new contact to map
                        List<Responsibility_Type__c> rtListMap = new List<Responsibility_Type__c>();
                        rtListMap = ebsEmailMap.get(RTListToMap.Email__c);
                        rtListMap.add(RTListToMap);
                        ebsEmailMap.put(RTListToMap.Email__c, rtListMap);

                        ebsEmailSet.remove(RTListToMap.Email__c);
                    } else {
                        //If email is not in map, just add values to map
                        List<Responsibility_Type__c> rtListMap = new List<Responsibility_Type__c>();
                        rtListMap.add(RTListToMap);
                        ebsEmailMap.put(RTListToMap.Email__c, rtListMap);
                    }                    
                }

            //If there's no match, parse the email address to include account
            }else {

                if(ebsEmailSet.size() > 0){

                    List<String> strList = new List<String>(ebsEmailSet);
                    List<Responsibility_Type__c> contInsert = new List<Responsibility_Type__c>();
                    List<Account> acctOrphan = new List<Account>([Select ID From Account Where name = 'ORPHANED CLARIFCATION CONTACTS' Limit 1]);
                    Contact conInsert = new Contact();
                    

                    For(String contEmailString : strList){
                        
                        String contactId = '';
                        String accountID = '';                      
                    
                        For(Case cInfo : caseList){
                            if(cInfo.SuppliedEmail == contEmailString && mpAcctList.get(cInfo.EBS_Account_Number__c) != null){
                                accountID = mpAcctList.get(cInfo.EBS_Account_Number__c).ID;         
                            } else {
                                accountID = acctOrphan[0].ID;
                            }
                                                      
                        }
                        
                        if(mpContList.get(contEmailString) != null){
                            contactID = mpContList.get(contEmailString).ID;
                            
                            if(accountID == null){
                                accountID = mpContList.get(contEmailString).AccountID;
                            }
                        } else {                            
                            
                            conInsert.FirstName = 'Clarification';
                            conInsert.LastName = contEmailString;
                            conInsert.responsibility_type__c = 'SALES_SERVICE';
                            conInsert.email = contEmailString;
                            conInsert.AccountID = accountID;
                            
                            Insert conInsert ;
                            
                            contactID = conInsert.ID;
                        
                        }
                        
                        Case caseRT = new Case();
                        caseRT = mpCaseDetails.get(contEmailString);
                    
                        String strDomain = contEmailString.split('@').get(1);
                        Responsibility_Type__c con = new Responsibility_Type__c();
                        con.last_Name__c = contEmailString;
                        con.Email__c = contEmailString;
                        con.Contact__c = contactID;
                        con.Account__c = AccountID;
                        con.Responsibility_Type__c = 'Clarifications';                        
                        
                        /*//Proof or Clarification Contact
                        if(caseRT != null && caseRT.Description != null){
                            if(caseRT.Description == 'Proof.'){
                            
                                con.Responsibility_Type__c = 'Proof';
                            } else {
                                con.Responsibility_Type__c = 'Clarifications';
                            }                           
                        } */
                                                
                        contInsert.add(con);
                    }

                    if(contInsert.size()> 0){
                        insert contInsert;

                        For(Responsibility_Type__c con : contInsert){
                            List<Responsibility_Type__c> lstRTMap = new List<Responsibility_Type__c>();
                            lstRTMap.add(con);
                            ebsDomainMap.put(con.Email__c, lstRTMap);
                        }

                        //Add contacts to map
                        ebsEmailMap.putAll(ebsDomainMap);
                    }
                }
            }
        } 

        //Return map of contacts
        return ebsEMailMap;
    }

    
    public static map<string, List<Contact>> rtCreateContact(List<String> ebsEmailSet){
    
        Map<String, List<Contact>> ebsDomainMap = new Map<string, List<Contact>>();
        Map<String, List<Contact>> ebsEMailMap = new Map<String, List<Contact>>();
    
        if(ebsEmailSet.size() > 0){

            List<String> strList = new List<String>(ebsEmailSet);
            List<Contact> contInsert = new List<Contact>();

             For(String contEmailString : strList){
                String strDomain = contEmailString.split('@').get(1);
                Contact con = new Contact(firstname='Clarification',lastName= contEmailString, email=contEmailString,responsibility_type__c = 'SALES_SERVICE');
                contInsert.add(con);
            }

            if(contInsert.size()> 0){
                insert contInsert;

                For(Contact con : contInsert){
                    List<Contact> lstContMap = new List<Contact>();
                    lstContMap.add(con);
                    ebsDomainMap.put(con.Email, lstContMap);
                }

                //Add contacts to map
                    ebsEmailMap.putAll(ebsDomainMap);
            }
        }
        
        return ebsEmailMap;
    }  
}