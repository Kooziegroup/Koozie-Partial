///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Test class for class used to grab orders modified in last 2 hours
@isTest(seeallData=true)
public class testSchOrderProd{
    public static testmethod void test(){
        Test.startTest();
        
        Product2 p = new Product2(Name='Testing123',Product_ID__c = '12345');
        insert p;
        
        EBS_Order__c eo = new EBS_Order__c(order_type__c = 'Sample Fullfillment',City__c ='Happy Town');
        insert eo;
        
        EBS_Order_Line__c eol = new EBS_Order_Line__c(PRODUCT_ID__c = '12345',  
            line_type__c = 'Standard (Line Invoicing)',  Order__c=eo.ID);
        insert eol;

        // Runs the job On July 4th 2030
        String CRON_EXP = '0 0 0 4 7 ? 2030';
        
        // Schedule the test job
        String jobId = System.schedule('OLTestSchedule', CRON_EXP, new scheduleOrderlineProduct());
        
        // Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        
        // Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression); 
        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run 
        System.assertEquals('2030-07-04 00:00:00', String.valueOf(ct.NextFireTime));   
        Test.stopTest();        
    }
}