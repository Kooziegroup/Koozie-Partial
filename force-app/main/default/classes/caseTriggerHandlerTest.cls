@isTest 
public class caseTriggerHandlerTest {
    Private static testMethod void caseDmlTest(){
    
        //Recordtype rt = new Recordtype([Select ID From RecordType Where Name = 'Clarification' and SObjectType = 'Case' Limit 1]);
        
        ID clarCaseID = Schema.Sobjecttype.Case.getRecordTypeInfosByDeveloperName().get('Clarification').getRecordTypeId();
        ID clarQuesID = Schema.Sobjecttype.Clarification_Question__c.getRecordTypeInfosByDeveloperName().get('ClarificationQuestion').getRecordTypeId();
        
        Test.startTest();
        case CaseVar = new case();
        CaseVar.Status ='Open';
        CaseVar.RecordTypeId = clarCaseID;
        CaseVar.Origin ='Email';
        insert CaseVar;
        
        Clarification_Question__c CQvar = new Clarification_Question__c();
        CQvar.Case__c = CaseVar.id;
        CQvar.Question_Type__c ='Clarification';
        CQvar.RecordTypeId = clarQuesID;
        CQvar.Void_Question__c= True;
        CQvar.Response__c ='Hi';
        insert CQvar;
        Test.stopTest();
    }
}