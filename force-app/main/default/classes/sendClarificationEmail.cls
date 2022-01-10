///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public without sharing class sendClarificationEmail{

     //Get the object type and record ID 
    @InvocableMethod(label='Clarification Email Module' description='Send emails for clarifications.' category='Case')
    public static void sendEmailNotification(List<String> caseRecordString){
        sendClariEmail.sendEmail(caseRecordString, 'Clarification');
    }    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////