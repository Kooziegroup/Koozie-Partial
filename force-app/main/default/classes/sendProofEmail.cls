///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public without sharing class sendProofEmail{

     //Get the object type and record ID 
    @InvocableMethod(label='Proof Email Module' description='Send emails for proofs.' category='Case')
    public static void sendProofNotification(List<String> caseRecordString){
        system.debug('inside sendproff email@@@@@@@@@@@@@');
        sendClariEmail.sendEmail(caseRecordString, 'Proof');
    }    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////