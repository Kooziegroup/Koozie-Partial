@isTest
private class unlockApprovalTest{
 
    static testMethod void validateApprovalLock() {
     
        RecordType rt = [Select ID, Name From RecordType Where SobjectType = 'Account' and name = 'Customers' Limit 1];
         
        Account a = new Account(name='Acme', YTD_Sales_Revenue_Total__c = 200.00, recordtypeID =  rt.Id); 
        insert a;
        
        /* 
        Marketing_Projects__c mp = new Marketing_Projects__c(Name ='TestProject', Status__c ='Submitted/Locked', Account__c = a.id, Team_Request__c = 'Sales', Due_Date_Project_Submission__c = system.today());
        */
         
        Test.startTest();
        /*
        // Insert records
        insert mp;
        
        List<Marketing_Projects__c> lstMP = new List<Marketing_Projects__c>{mp};
        
        UnlockApproval.unlockInvocable(lstMP);
        */
         
        Test.stopTest();
        
    }
}