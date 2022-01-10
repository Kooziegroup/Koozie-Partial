@isTest
public class modifyCaseAssignmentTest {
    
    public static testmethod void test1(){
        Case csRec1 = TestData.createCase(false,'Case');
        csRec1.Status = 'Awaiting Clarification';
        insert csRec1;
        
        Case csRec2 = TestData.createCase(false,'Case');
        csRec2.Status = 'Working';
        insert csRec2;
        
        Set<ID> lstCaseID = new Set<ID>();
        lstCaseID.add(csRec1.Id);
        lstCaseID.add(csRec2.Id);
        
        Map<ID, String> oldStatus = new Map<ID, String>();
        oldStatus.put(csRec2.Id,csRec2.Status);
        
        Map<ID, String> oldAccount = new Map<ID, String>();
        oldAccount.put(csRec2.Id,csRec2.AccountId);
        Test.startTest();
        Id caseDORecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Delayed Order').getRecordTypeId();
        Case csRec3 = TestData.createCase(false,'Case');
        csRec3.Status = 'Day 3 Call';
        insert csRec3;
        Set<ID> lst1CaseID = new Set<ID>();
        lst1CaseID.add(csRec3.Id);
        csRec3.Status = 'Day 1 Call (24 Hour)';
        csRec3.Clarification_Hold__c = true;
        csRec3.hasBeenAssigned__c = false;
        csRec3.RecordTypeId = caseDORecTypeId;
        update csRec3;
        Case csRec4 = TestData.createCase(false,'Case');
        csRec4.Status = 'Day 3 Call';
        insert csRec4;
        Map<ID, String> oldStatus1 = new Map<ID, String>();
        oldStatus1.put(csRec4.Id,csRec4.Status);
        Map<ID, String> oldAccount1 = new Map<ID, String>();
        oldAccount1.put(csRec4.Id,csRec4.AccountId);
        
        lst1CaseID.add(csRec3.Id);
        //lst1CaseID.add(csRec4.Id);
        
        modifyCaseAssignment.caseOwnerAssignment(lstCaseID, oldStatus, oldAccount, 'Insert');
        modifyCaseAssignment.caseOwnerAssignment(lstCaseID, oldStatus, oldAccount, 'Update');
        modifyCaseAssignment.caseOwnerAssignment(lst1CaseID, oldStatus1, oldAccount1, 'Update');
        Test.stopTest();
    }

}