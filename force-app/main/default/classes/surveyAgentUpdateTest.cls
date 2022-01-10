@istest
public class surveyAgentUpdateTest {
    static testMethod void surveyUpdateContactTest() {
        Test.StartTest();
        
        // create custom settings
        AppInfo__c appinfo = new AppInfo__c();
        appinfo.Name = 'WebClient';
        appinfo.user__c='test User';
        appinfo.password__c='12345';
        appinfo.endpoint__c='www.test.com';
        insert appinfo;
        
        Account acct = new Account(name='Test',Phone='4194181444');
        insert acct;
        
        Contact con = new Contact(lastname='Johnson', email='jj@jj.com',Other_Email__c = 'j@j.com', phone = '4194181444',  
                                  otherPhone = '407-444-1212', FAX = '407-777-4848', AccountID=acct.ID);
        //insert con;
        
      //  insert survey
        Custom_Survey__c Survey = new Custom_Survey__c();
        Survey.ANI__c = '4194181444';
        insert Survey;
        Test.StopTest();
    }
}