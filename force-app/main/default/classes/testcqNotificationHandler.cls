///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@isTest(seealldata = true)
private class testcqNotificationHandler {

    static testMethod void cqQuestionHandler() {        
  
        
        test.starttest();
        List<string> CaseId = new List<string>();
        
        List<User> runUser = new List<User>
            ([Select ID 
              From User
              Where isActive = True 
              And Profile.Name like '%BIC%'
              And (Not Profile.Name like '%claim%')
              And (Not Profile.Name like '%customer service%')
              And (Not Profile.Name like '%Administrator%')
              And (Not Profile.Name like '%read only%')]);

        system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('NotificationQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'NotificationQuestion') ? rtLoop : r1;
            }
            
            Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Clarification_Pending'];
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountID = a.ID;
            insert cont;
             

            Case notificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Notification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert notificationCase;     
            
            Clarification_Question__c cqNotif = new Clarification_Question__c(Case__c = notificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Notification');
            insert cqNotif;
            

            List<ID> lstnotificationCase = new List<ID>();
            lstnotificationCase.add(notificationCase.ID);
            
            notificationCase.Status = 'Day 3 Call';
            notificationCase.OwnerID = g.ID;    
            notificationCase.Cadence_Owner_Change__c = true;
            update notificationCase;

            System.schedule('testQueHander03', '0 55 * * * ?', new scheduledNotificationHandler()); 

        }
        
        test.stopTest();
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////