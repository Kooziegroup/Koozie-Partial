@isTest(seeAllData=True)
private class testEmailToCase {
    @isTest static void
     EmailToCaseTest() {

        Account a = new Account(Name='Acme', Customer_Account_Number__c= '123456789');
        insert a;
        
        Contact con = new Contact(firstname='Joe', lastname='Smith', AccountId=a.Id,email='john@smith.com');
        insert con;

        Account_Clarification_Team__c act = new Account_Clarification_Team__c(Name='4Imprint',Account_Team__c='4Imprint',
                From_Email__c='hello1@goodbye.com');
        insert act; 

        Case c = new Case();
        c.suppliedEmail = 'john@smith.com';
        c.ContactId = con.ID;
        c.subject = 'Email Test';
        c.Status = 'New';
        c.Origin = 'Email';
        c.AccountID = a.Id;
        c.Proof_Team__c = '4Imprint';
        c.Clarification_Team__c = '4Imprint';
        c.EBS_Account_Number__c = '123456789';
        insert c;
    }
}