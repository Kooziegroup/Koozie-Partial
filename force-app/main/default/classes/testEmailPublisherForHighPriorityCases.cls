///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Test class for updating from address on quicksend actions
@isTest(seealldata = true)
private class testEmailPublisherForHighPriorityCases{

    static testMethod void testemailPublisherForHighPriorityCases() {    
    
        //setup test data
        Account a = new Account(Name = 'AccountTest', Customer_Account_Number__c='123456789');
        insert a;
        
        OrgWideEmailAddress[] addresses = [SELECT Id, Address FROM OrgWideEmailAddress LIMIT 1];
        
        Elite_Email_Mapping__c eem = new Elite_Email_Mapping__c(Account_Number__c='123456789', Email_Address__c = addresses[0].Address);
        insert eem;
                
        Contact cont = new Contact(firstname = 'John', lastname = 'Smith', AccountID =a.Id, email='Hello@goodbye.com');
        insert cont;
         
        Case cas = new Case(ContactID = cont.id, Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
        Clarification_to_email__c ='hello@goodbye.com');
        insert cas;
        
        List<String> c = new List<String>();
        c.add(cas.ID);
        
        AssignCasesUsingAssignmentRulesPB.CaseAssign(c);

        list<QuickAction.QuickActionDefaults> defaults = new list<QuickAction.QuickActionDefaults>();
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = Test.newSendEmailQuickActionDefaults(cas.Id, null);
        defaults.add(sendEmailDefaults);
        Test.startTest();
        EmailPublisherForHighPriorityCases cntl = new EmailPublisherForHighPriorityCases();
        cntl.onInitDefaults(defaults);
        Test.stopTest();
        EmailMessage emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
        System.assertNotEquals(null, emailMessage);   
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////