///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@isTest(seealldata = true)
private class testcqQuestionHandler {

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
                Where Name in('ClarificationQuestion','NotificationQuestion','ProofQuestion')];
                
            RecordType r1 = new RecordType();
            RecordType r2 = new RecordType();
            RecordType r3 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ClarificationQuestion') ? rtLoop : r1;
                r2 = (rtLoop.Name == 'NotificationQuestion') ? rtLoop : r2;
                r3 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r3;
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
            cont.Other_Email__c = 'goodbye123@hello.com';
            cont.Phone = '407-555-1212';
            cont.OtherPhone = '407-555-1212';
            cont.Fax = '407-555-1212';
            insert cont;        
            
            Responsibility_Type__c ret = new Responsibility_Type__c();
            ret.first_name__c = 'Jack';
            ret.last_name__c = 'Frost';  
            ret.Email__c = null;        
            ret.Contact__c = cont.ID;
            ret.Account__c = a.ID;
            insert ret;          
            
            ret.Contact_ID__c = '123456789';
            ret.Email__c = 'goodbye@hello.com';
            ret.Other_Email__c = 'goodbye123@hello.com';
            ret.Phone__c = '407-555-1212';
            ret.Other_Phone__c = '407-555-1212';
            ret.Fax__c = '407-555-1212';
            ret.Primary_Responsibility_Flag__c = 'true';
            update ret;     
            
            ret.Contact_ID__c = '123456789';
            ret.Email__c = 'goodbye@hello.com';
            ret.Phone__c = '407-555-1212';
            ret.Primary_Responsibility_Flag__c = 'true';
            update ret;               
             
            Case clariCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Notification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert clariCase;
                    
            Clarification_Question__c cqClari = new Clarification_Question__c(Case__c = clariCase.Id, RecordTypeId=r1.Id, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification');
            insert cqClari;                  
            
            List<ID> lstClariCase = new List<ID>();
            lstClariCase.add(clariCase.ID);
            
            clariCase.Status = 'Follow-up Needed';
            clariCase.OwnerID = g.ID;    
            clariCase.Cadence_Owner_Change__c = true;
            update clariCase;   
            
            System.schedule('testQueHander01', '0 55 * * * ?', new scheduledClarificationHandler()); 
            System.schedule('testQueHander02', '0 55 * * * ?', new scheduledNotificationHandler()); 
            System.schedule('testQueHander03', '0 55 * * * ?', new scheduledProofHandler());
            cqQuestionHandler.handleQuestions(lstClariCase);

        }
        
        test.stopTest();
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////