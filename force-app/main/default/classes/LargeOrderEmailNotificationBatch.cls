global class LargeOrderEmailNotificationBatch {
    global LargeOrderEmailNotificationBatch(){
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'Select id ,case__c,createddate,case__r.EBS_Order__c,case__r.status,status__c,case__r.recordtypeid,question_Type__c from Clarification_Question__c where (case__r.status !=\'Merged-Duplicate\' OR case__r.status !=\'Closed\') And (status__c != \'Closed\' OR status__c !=\'EBS Closed\' ) and (case__r.recordtypeid =:clarificationRecordTypeId) and (question_Type__c = \'Notification\') and (case__r.contact_email_bounced__c = false) and (Notification_Sent__c =false) and (case__r.Order_Header_Status__c !=\'cancelled\' OR case__r.Order_Header_Status__c !=\'closed\' ) and createddate = today';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Clarification_Question__c> questionList) {
        
        
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}