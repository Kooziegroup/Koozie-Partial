///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Test class for order purge batch class and schedulable interface
@isTest
private class testSFDCOrderCPurge {

    static testMethod void SFDCOrderPurgeTest() {        

        Date todDate = system.today();
        Date purgeDate = todDate.addMonths(-29);     
        
        test.starttest();
         
        EBS_Order__c eOrder = new EBS_Order__c(Effective_Date__c=purgeDate);
        insert eOrder;
         
        sfdcOrderPurgeSchedule myClass = new sfdcOrderPurgeSchedule ();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, myClass);
        test.stopTest();
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////