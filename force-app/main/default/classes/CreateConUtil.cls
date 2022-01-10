public class CreateConUtil {
    public static Contact checkAndCreateRecords(CaseCreateRequest.Audience audience, String formType) {
        //to check for contacts, use Email and AccountId
        List<Contact> conts = [SELECT Id FROM Contact WHERE Email = :audience.Email AND Account_Number__c = :audience.EBSACCTID];
        system.debug('Cont List: ' + conts);
        system.debug('AccID: ' + audience.EBSACCTID);
        
        //if doesnt exist, create contact
        if(conts == null || conts.size() == 0) {
            List<Account> acc = [SELECT Id, Customer_Account_Number__c FROM Account WHERE Customer_Account_Number__c = :audience.EBSACCTID];
            system.debug('Account List: ' + acc);
            
            Id accId = (acc != null && acc.size() > 0) ? acc[0].Id : null;
            Contact con = createNewContact(audience, accId);
            
            if(con != null) {
                createNewResponsibilityType(audience, accId, con.Id, formType);
                return con;
            }
        }
        return null;
    }
    
    public static Contact createNewContact(CaseCreateRequest.Audience audience, Id accId) {
        try {
            Contact con = new Contact();
            con.AccountId = accId != null ? accId : null;
            con.FirstName = audience.FirstName;
            con.LastName = audience.LastName;
            con.Email = audience.Email;
            //con.Contact_ID__c = (audience.EBSID != null && audience.EBSID != '') ? audience.EBSID : null;
            system.debug('contID: ' + con.Contact_id__c);
            
            insert con;
            
            return con;
        } catch(Exception ex) {
            system.debug(ex);
            CreateContactResponse.success_response = False;
            CreateContactResponse.message_response = ex.getMessage();
        }
        return null;    
    }
    
    public static Responsibility_Type__c createNewResponsibilityType(CaseCreateRequest.Audience audience, Id accId, Id contactId, String formType) {
        try {
            Responsibility_Type__c res = new Responsibility_Type__c();
            res.Account__c = accId != null ? accId : null;
            res.Contact__c = contactId != null ? contactId : null;
            res.Contact_ID__c = audience.EBSID;
            res.First_Name__c = audience.FirstName;
            res.Last_Name__c = audience.LastName;
            res.Email__c = audience.Email;
            res.Responsibility_Type__c = formType;
            insert res;
            return res;
        } catch(Exception ex) {
            
        }
        return null;
        
    }
    
    public static List<Contact> createContacts(List<CaseCreateRequest.Audience> audiences, String formType) {
        List<Contact> contacts = new List<Contact>();
        for(CaseCreateRequest.Audience audience : audiences) {                 
            
            //If EBSID is empty or null, check if contact exists
            if(audience.EBSID == null || audience.EBSID == '') {
            
                List<Responsibility_Type__c> resTypes = [SELECT Id FROM Responsibility_Type__c WHERE Email__c = :audience.Email AND Customer_Account_Number__c = :audience.EBSACCTID];
                system.debug('AccID: ' + audience.EBSACCTID);
                
                if(resTypes == null || resTypes.size() == 0) {
                    Contact con = checkAndCreateRecords(audience, formType);
                    
                    if(con != null) {
                        contacts.add(con);    
                    }
                }
            } else {
                //else EBSID is not empty
                //check if EBSID is present in SF
                List<Responsibility_Type__c> resTypes = 
                    [SELECT Id, Account__c, Contact__c, Contact_ID__c, First_Name__c, Last_Name__c, Email__c, 
                    Responsibility_Type__c  
                    FROM Responsibility_Type__c 
                    WHERE Contact_ID__c = :audience.EBSID 
                    AND Responsibility_Type__c = :formType];
                    
                system.debug('AccID: ' + audience.EBSACCTID);
                
                if(resTypes == null || resTypes.size() == 0) {
                
                    //if no match found. check against Email, AccID and Responsibility_Type
                    List<Responsibility_Type__c> resType = [SELECT Id, Contact_ID__c FROM Responsibility_Type__c WHERE Customer_Account_Number__c = :audience.EBSACCTID AND Responsibility_Type__c = :formType AND Email__c = :audience.Email];
                    system.debug('AccID: ' + audience.EBSACCTID);
                    
                    if(resType != null && resTypes.size() > 0) {
                        //if resp types exists without EBSID, assign EBSID
                        Responsibility_Type__c res = resType[0];
                        if(res.Contact_ID__c == null || res.Contact_ID__c == '') {
                            res.Contact_ID__c = audience.EBSID;
                        }
                        update res;
                    } else {
                        //if responsibility type does not exist
                        Contact con = checkAndCreateRecords(audience, formType);
                        if(con != null) {
                            contacts.add(con);    
                        }
                    }
                } else {
                
                    Responsibility_Type__c res = resTypes[0];

                    res.First_Name__c = audience.FirstName;
                    res.Last_Name__c = audience.LastName;
                    res.Email__c = audience.Email;
                    res.Responsibility_Type__c = formType;
                    update res;
                                
                    CreateContactResponse.success_response = TRUE;
                    CreateContactResponse.message_response = 'Responsibility Type Updated.';                
                
                }
            }
        }
        return contacts;
    }
}