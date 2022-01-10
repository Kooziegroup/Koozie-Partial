@isTest
public class ResendBounceEmailBatch_Test {
    
     static testMethod void scheduleResendEmailBatchTest() {
         Test.StartTest();
         Id clarificationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();

         EBS_Order__c order = new EBS_Order__c();
         order.Order_Header_Status__c = 'New';
         insert order;
         
         case cse = new case();
         cse.status ='Awaiting Clarification Response';
         cse.EBS_Order__c = order.id;
         cse.RecordTypeId =clarificationRecordTypeId;
         insert cse;
         
         Clarification_Question__c question = new Clarification_Question__c();
         question.case__c =cse.id;
         question.status__c = 'Open';
         question.question_Type__c='Notification';
         question.Notification_Sent__c = false;
         
         insert question;
         
         ResendBounceEmailBatchScheduler obj = new ResendBounceEmailBatchScheduler();
         
         String cronExp = '0 0 0,4,8,12,16,20 ? * *';
         
         system.schedule('ResendBounceEmailBatchScheduler', cronExp, obj); 
         
         Test.stopTest(); 
    
}

}