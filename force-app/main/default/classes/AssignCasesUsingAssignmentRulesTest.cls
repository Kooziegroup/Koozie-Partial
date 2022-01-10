@isTest
public class AssignCasesUsingAssignmentRulesTest {
    
    public static testmethod void test1(){
        List<Id> caseIdList = new List<Id>();
        Case csRec = TestData.createCase(false,'Clarification');
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt11', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',  UserName='standarduser11@testorg.com');
	
        system.runAs(u){
            insert csRec;
            system.debug('csRec->'+csRec.createdById);
        }
        caseIdList.add(csRec.Id);
        test.startTest();
        AssignCasesUsingAssignmentRules.CaseAssign(caseIdList);
        test.stopTest();
        
    }
}