///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public without sharing class sendProofApprovalEmail {

    //Get the object type and record ID 
    @InvocableMethod(label='Send Proof Approval' description='Send emails for general proof approval.' category='Clarification_Question__c')    
    public static void sendGeneralEmail(List<String> clarRecordString) {
        sendGeneralEmail.sendGeneralEmail(clarRecordString);
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////