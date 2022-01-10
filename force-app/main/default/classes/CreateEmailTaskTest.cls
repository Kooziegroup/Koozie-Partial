@isTest(seealldata = true)
public class CreateEmailTaskTest
{
    static testMethod void testInsertAccount()
    {
        //RecordType rt = [Select ID from RecordType Where Sobjecttype = 'Account' and Name = 'Customers'];
        
        Account acct = new Account(name='Acme Testing123');
        insert acct;
        
        Contact cont = new Contact(firstname='John',lastname='Smith',email='john@smith.com',AccountId=acct.id);
        insert cont;
        
        Task t = new Task(subject='Email: testing');
        insert t;
    }
      
    public static void sendEmail(ID recipient, ID candidate) {
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(recipient);
        mail.setPlainTextBody('');
        mail.setWhatId(candidate);   
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setReplyTo('tintu@qburst.com');
        mail.setSenderDisplayName('HR Recruiting');
        mail.setSaveAsActivity(false); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }   
}