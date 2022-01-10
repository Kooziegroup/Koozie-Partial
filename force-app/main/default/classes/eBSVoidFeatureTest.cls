@istest(SeeAllData=true)
public class eBSVoidFeatureTest {
    public static testmethod void ebsTestmethod(){
        string rTypeName ='Clarification';
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(rTypeName).getRecordTypeId();
        
        Contact cont = new Contact();
        cont.firstname = 'Jack';
        cont.lastname = 'Frost';  
        cont.Email = 'hello@goodbye.com';
        cont.Other_Email__c = 'goodbye123@hello.com';
        cont.Phone = '407-555-1212';
        cont.OtherPhone = '407-555-1212';
        cont.Fax = '407-555-1212';
        insert cont;  
        
        Case csRec = new Case(Status ='New', Priority = 'Medium', Origin = 'Email',RecordTypeId=recordTypeId, contactID = cont.Id);
        Insert csRec;
        
        Case csRec1 = new Case(Status ='Old', Priority = 'Medium', Origin = 'Email',RecordTypeId=recordTypeId, contactID = cont.Id);
        Insert csRec1;
        
        list<case> newCaseList =new list<case>();
        list<case> oldCaseList =new list<case>();
        
        set<Id> idset =new set<Id>();
        idset.add(csRec.Id);
        newCaseList.add(csRec);
        oldCaseList.add(csRec1);
        
        string recTypeName ='ClarificationQuestion';
        Id clrQstRecordTypeId =Schema.SObjectType.Clarification_Question__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        
        Clarification_Question__c CQvar = new Clarification_Question__c();
        CQvar.Case__c = csRec.id;
        CQvar.Question_Type__c ='Clarification';
        CQvar.RecordTypeId =clrQstRecordTypeId;
        CQvar.Void_Question__c= True;
        CQvar.Response__c ='Hi';
        CQvar.Void_Question__c=True;
        CQvar.Status__c='Open';
        insert CQvar;
        
        eBSVoidFeature.updateQuestion(newCaseList,oldCaseList,idset);
        
        Clarification_Question__c CQvar1 = new Clarification_Question__c();
        CQvar1.Case__c = csRec1.id;
        CQvar1.Question_Type__c ='Clarification';
        CQvar1.RecordTypeId =clrQstRecordTypeId;
        CQvar1.Void_Question__c= True;
        CQvar1.Response__c ='Hi';
        CQvar1.Void_Question__c=True;
        CQvar1.Status__c='Open';
        insert CQvar1;
        
        list<Id>cqIdList =new list<Id>();
        cqIdList.add(CQvar1.Id);
        
        List<ID> lstCaseId = new List<ID>{csRec.ID, csRec1.ID};
        
        eBSVoidFeature.updateCQQuestion(cqIdList, lstCaseID);
        
    }
}