///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@isTest(seealldata = true)
private class testEntHandler {

    static testMethod void testEntHandler() {          
        
        test.starttest();
        List<string> CaseId = new List<string>();
        
        RecordType r = [Select Id from RecordType Where Name = 'Delayed Order' and sObjectType = 'Case' Limit 1];
        
        Account a = new Account(Name = 'AccountTest');
        insert a;
        
        Entitlement ent = new Entitlement(Name='Testing', AccountId=a.Id, 
        StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        insert ent;        
        
        Contact cont = new Contact(firstname = 'John', lastname = 'Smith2524', AccountID =a.Id, email='Hello123@goodbye.com');
        insert cont;
        
        EntitlementContact entCon = new EntitlementContact(entitlementid = ent.id, contactID=Cont.ID);
        insert entCon;
         
        Case cas = new Case(ContactID = cont.id, 
        Status = 'New', Origin = 'Phone');
        insert cas;
        
        cas.entitlementID = null;
        update cas;
        
        Case cas1 = new Case(ContactID = cont.id, status = 'New', Origin = 'Phone', RecordTypeID = r.Id);
        insert cas1;
        
        }
        }