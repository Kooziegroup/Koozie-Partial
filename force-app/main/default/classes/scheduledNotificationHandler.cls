/*******************************************************************************************

Class queries for clarification questions that haven't been sent

*******************************************************************************************/

public class scheduledNotificationHandler implements Schedulable
{

    public void execute(SchedulableContext SC) {
        notificationHandler();    
    }
    
    public static void notificationHandler(){
    
        DateTime dtNow = system.Now() + 10/1440;
        
        //Query unsent notification questions
        List<Clarification_Question__c> cqLoad = new List<Clarification_Question__c>([
            Select Case__c From Clarification_Question__c 
            Where Question_Type__c = 'Notification' 
            AND Case__r.Last_Notification_Created_Date__c <=: dtNow
            AND Case__r.Last_Notification_Created_Date__c != null
            AND Notification_Sent__c = FALSE 
            AND Case__r.Clarification_Hold__c = FALSE
            AND Case__r.Status Not IN ('Closed', 'Merged - Duplicate')
            AND Status__c Not IN ('Closed', 'EBS Closed')
            AND Case__r.Email_Bounced__c = false
            Limit 25]);
        
        //Add list of Case IDs    
        IF(cqLoad.size() > 0){
            List<string> caseId = new List<String>();
            
            For(Clarification_Question__c c : cqLoad){
                if(!caseID.contains(c.Case__c)){
                    caseId.add(c.Case__c);
                }
            }
            
            //Send notification emails out
            sendNotificationEmail.sendNotificationEmail(caseId);
        }
    }
}