///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public without sharing class sendNotificationEmail{

    //Get the object type and record ID 
   @InvocableMethod(label='Notification Email Module' description='Send emails for notifications.' category='Clarification_Question__c')
   public static void sendNotificationEmail(List<String> caseRecordString){
        sendClariEmail.sendEmail(caseRecordString, 'Notification');
   }    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////