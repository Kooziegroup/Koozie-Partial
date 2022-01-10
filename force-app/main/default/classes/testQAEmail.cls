///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@isTest(seealldata = true)
private class testQAEmail {

    static testMethod void testQAEmail() {          
        
    Account a = new Account(Name = 'AccountTest');
    insert a;       
        
    Contact cont = new Contact(firstname = 'John', lastname = 'Smith2524', AccountID =a.Id, email='Hello123@goodbye.com');
    insert cont;
         
    Case cas = new Case(ContactID = cont.id, 
    Status = 'New', Origin = 'Phone');
    insert cas;
    
    EmailMessage[] newEmail = new EmailMessage[0]; 

    newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, 
        ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', 
        Subject = 'Test email', TextBody = '23456 ', ParentId = cas.Id)); 

    insert newEmail;    
    
    List<String> lstEM = new List<String>();
    string EMID = newEmail[0].ID;
    
    lstEM.add(EMID);    
    clarificationEmailHandler.closeClariHandler(lstEM);
    
    ID caseID = cas.ID;
    
    Test.startTest();       
    QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = test.newSendEmailQuickActionDefaults(caseId, null);
    
    support.EmailTemplateSelector cntl;
    List<QuickAction.QuickActionDefaults> defaults = new List<QuickAction.QuickActionDefaults>();
    EmailPublisherForHighPriorityCases e = new emailpublisherforhighprioritycases();
    //e.onInitDefaults(defaults);
    //mailmsg.onInitDefaults(defaults );
    //cntl.onInitDefaults(defaults);
    Test.stopTest();
    //EmailMessage emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
    //System.assertNotEquals(null, emailMessage);
        
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////