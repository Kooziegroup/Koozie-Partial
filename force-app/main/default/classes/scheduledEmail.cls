global class scheduledEmail implements Schedulable{
global void execute(SchedulableContext SC) {
    String emailType = 'Clarification';
    List<String> caseRecordString = new List<String>();
        for(Case objCase : [SELECT Id, Status FROM Case WHERE RecordType.Name='Clarification' AND Send_Email_Flag__c =: TRUE]){
            caseRecordString.add(objCase.Id);
        }
//Non static method cannot be referenced from a static context
//List<String> caseRecordString = [Select Id FROM Case WHERE RecordType.Name='Clarification'];
      //  sendClariEmail abc = new sendClariEmail();
        sendClariEmail.sendEmail(caseRecordString,emailType);
    }
}