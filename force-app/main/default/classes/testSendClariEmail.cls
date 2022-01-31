///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@isTest(seeallData=true)
private class testSendClariEmail {

     @istest
    public static  void sendClariEmailTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Clarification_Template', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Clarification_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ClarificationQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ClarificationQuestion') ? rtLoop : r1;
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
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Clarification');       
        }
    }

    @istest
    public static  void sendClariNotificationEmailTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Notification_Template', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Notification_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('NotificationQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'NotificationQuestion') ? rtLoop : r1;
            }
            
            //Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Notification');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Notification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Notification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Notification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Notification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Notification');       
        }
    }

    @istest
    public static  void sendClariProofEmailTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Proof_Template', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Proof_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Proof'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Proof');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailAccountLogoEqualsCalendarCoopTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Templatee', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', LOGO__C = 'CALENDAR COOP');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Proof'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Proof');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailAccountCorporateRouteEquals4ImprintTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Templatee', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Routing_Override__c = 'Elite 802 4Imprint');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Proof'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Proof');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCustomerContactCallLogoEqualsCalendarCoop(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'AW_Clarification_Customer_Contact', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'AW_Clarification_Customer_Contact',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', LOGO__C = 'CALENDAR COOP');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Customer Contact Call', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            //css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Proof'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            //sendClariEmail.sendEmail(CaseId, 'Proof');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCustomerContactCallCustomerCategoryEqualsChurch(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'AW_Clarification_Customer_Contact', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'AW_Clarification_Customer_Contact',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Customer_Category__c = 'CHURCH');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Customer Contact Call', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            //css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Proof'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            //sendClariEmail.sendEmail(CaseId, 'Proof');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCustomerContactCallRoutingEqualsElite8024Imprint(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'X4Imprint_Clarification_Customer_Contact', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'X4Imprint_Clarification_Customer_Contact',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Routing_Override__c = 'Elite 802 4Imprint');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Customer Contact Call', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCustomerContactCallWhenNoConditionMet(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Proof_Customer_Contact', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Proof_Customer_Contact',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Customer Contact Call', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
           //  Account acc = new Account();
            //acc.Id = a.Id;
           //update acc; 
            Case css = new Case();
            css.Id = ClarificationCase.Id;
            css.Customer_To_Email__c = 'test@test.com';                          
            //css.Current_Process__c = 'Initial Email';     
            //css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            /// acc.Customer_Category__c = 'CHURCH';
            //update acc;                       
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            // acc.Routing_Override__c = 'Elite 802 4Imprint';
            //update acc;                       
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
           // acc.Customer_Category__c = 'CHURCH';
           // update acc;                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClariCancellationNoticeClarificationEmailTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Clarification_Template', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Clarification_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ClarificationQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ClarificationQuestion') ? rtLoop : r1;
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
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation Notice', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Clarification');       
        }
    }

    @istest
    public static  void sendClariCancellationNoticeNotificationEmailTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Notification_Template', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Notification_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('NotificationQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'NotificationQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation Notice', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Notification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Notification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Notification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Notification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Notification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Notification');       
        }
    }

    @istest
    public static  void sendClariCancellationNoticeProofEmailTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'Proof_Template', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'Proof_Template',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation Notice', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';   
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Proof'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Proof');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Proof');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationNoticeCalendarCoopTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Cancellation_Notice', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Cancellation_Notice',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', LOGO__C = 'CALENDAR COOP');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation Notice', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationNoticeCustomerCategoryTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'AW_Clarification_Cancellation_Notice', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'AW_Clarification_Cancellation_Notice',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Customer_Category__c = 'CHURCH');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation Notice', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationNoticeRoutingElite8024Imprint(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'X4Imprint_Clarification_Cancel_Notice', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'X4Imprint_Clarification_Cancel_Notice',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Routing_Override__c = 'Elite 802 4Imprint');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation Notice', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationNoticeWhenNoConditionMet(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Cancellation_Notice', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Cancellation_Notice',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationLogoEqualsCalendarCoop(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Template_Cancellation', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Template_Cancellation',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', LOGO__C = 'CALENDAR COOP');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationCustomerCategoryEqualsChurch(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'AW_Clarification_Template_Cancellation', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'AW_Clarification_Template_Cancellation',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending'];
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Customer_Category__c = 'CHURCH');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationRoutingEqualsElite8024Imprint(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Template_Cancellation', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Template_Cancellation',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Routing_Override__c = 'Elite 802 4Imprint');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailCancellationWhenNoConditionMet(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Clarification_Template_Cancellation', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'CCC_Clarification_Template_Cancellation',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending'];
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            Contact cont = new Contact();
            cont.firstname = 'Jack';
            cont.lastname = 'Frost';  
            cont.Email = 'hello@goodbye.com';
            cont.AccountId = a.Id;
            insert cont;
             

            Case ClarificationCase = new Case(ContactID = cont.id, 
            Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Cancellation', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 

            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            //sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');       
        }
    }

    @istest
    public static  void sendClarEmailWithoutContactTest(){   
        
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
              
            Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

            User usr = new User(
                Alias                 = 'usralias',
                Email                 = 'theuser@email.com',
                Emailencodingkey      = 'UTF-8',
                Lastname              = 'user_lastname',
                Languagelocalekey     = 'en_US',
                Localesidkey          = 'en_US',
                Profileid             =  pf.Id,
                Timezonesidkey        = 'America/Los_Angeles',
                Username              =  Math.random() + 'test@testuser.com',
                CompanyName           = 'the company'
            );
            insert usr;
            string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
            EmailTemplate template = new EmailTemplate(DeveloperName = 'AW_Clarification_Cancellation_Notice', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
            Name = 'AW_Clarification_Cancellation_Notice',
            IsActive = true);
        
            template.Markup=templateText;
        
            System.runAs(usr){
            insert template;
            }

            system.runas(runUser[0]){
        
            List<RecordType> rtList = 
                [Select ID, Name 
                From RecordType 
                Where Name in('ProofQuestion')];
                
            RecordType r1 = new RecordType();
            
            For(RecordType rtLoop : rtList ){
                r1 = (rtLoop.Name == 'ProofQuestion') ? rtLoop : r1;
            }
            
            // Group g = [select Id from Group where Type = 'Queue' and DeveloperName = 'Notification_Pending']; 
            
            DateTime dtNow = system.Now().addMinutes(-5);
            
            Account a = new Account(Name = 'AccountTest', Customer_Category__c = 'CHURCH');
            insert a;  
            
            RecordType rt = [Select ID from RecordType Where Name = 'Clarification' and sObjectType = 'Case'];  
            
            // Contact cont = new Contact();
           // cont.firstname = 'Jack';
           // cont.lastname = 'Frost';  
           // cont.Email = 'hello@goodbye.com';
           // cont.AccountId = a.Id;
           // insert cont; 
             

            Case ClarificationCase = new Case(Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', 
            Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
            Proof_to_email__c ='hello@goodbye.com', 
            Current_Process__c = 'Initial Email', Last_Clarification_Created_Date__c = dtNow,
            clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com', RecordTypeID = rt.ID);
            insert ClarificationCase;     
            
            CaseId.add(ClarificationCase.ID);
            
            Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = ClarificationCase.Id, RecordTypeId=r1.ID, 
            Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
            Proof_Disposition__c = 'Proof_Approved');
            insert cqClari; 
            
            //sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            //Initial Email
            Account acc = new Account();
            acc.Id = a.Id;
            update acc;
            Case css = new Case();
            css.Id = ClarificationCase.Id;                          
            css.Current_Process__c = 'Initial Email';     
            css.AccountId = acc.ID;
            Update css;  
            //sendClariEmail.sendEmail(css.Id, 'Clarification'); 
                    
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);   
            sendClariEmail.sendEmail(CaseId, 'Clarification');   
            
            acc.Routing_Override__c = 'Elite 802 4Imprint';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID);
            sendClariEmail.sendEmail(CaseId, 'Clarification');                         
            
            //Customer Contact Call
            ClarificationCase.Current_Process__c = 'Customer Contact Call';
            Update ClarificationCase;            
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');  
            
            acc.Customer_Category__c = 'CHURCH';
            update acc;                      
            CaseId.clear();
            CaseId.add(ClarificationCase.ID); 
            //sendClariEmail.sendEmail(CaseId, 'Proof');     
            
        }
    }

    @istest
    public static  void sendVoidEmailClarificationType(){
        
        OrgWideEmailAddress[] addresses = [SELECT Id, DisplayName FROM OrgWideEmailAddress];

        Account a = new Account(Name = 'AccountTest', LOGO__C = 'CALENDAR COOP');
        insert a;

        Contact cont = new Contact();
        cont.firstname = 'Jack';
        cont.lastname = 'Frost';  
        cont.Email = 'hello@goodbye.com';
        cont.AccountId = a.Id;
        cont.Phone = '12345';
        cont.Responsibility_Type__c = 'SALES_SERVICE';
        cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Clarification Contact').getRecordTypeId();
        insert cont;
        System.debug('====Test class Contact=====' +cont);
        
        Case cs =new Case();
        cs.AccountId = a.Id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        cs.ContactId = cont.Id;
        cs.Clarification_To_Email__c = 'hello@goodbye.com';
        cs.Proof_To_Email__c = 'hello@goodbye.com';
        cs.Clarification_CC_Email__c = 'Test@test.com';
        cs.Proof_CC_Email__c = 'Test@test.com';
        cs.EBS_Account_Number__c = '54321';
        insert cs;
        
        Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = cs.Id,  
        Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Clarification',
        Proof_Disposition__c = 'Proof_Approved');
        insert cqClari;

        Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User usr = new User(
            Alias                 = 'usralias',
            Email                 = 'theuser@email.com',
            Emailencodingkey      = 'UTF-8',
            Lastname              = 'user_lastname',
            Languagelocalekey     = 'en_US',
            Localesidkey          = 'en_US',
            Profileid             =  pf.Id,
            Timezonesidkey        = 'America/Los_Angeles',
            Username              =  Math.random() + 'test@testuser.com',
            CompanyName           = 'the company'
        );
        insert usr;
        string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
        EmailTemplate template = new EmailTemplate(DeveloperName = 'CCC_Voided_Question', TemplateType = 'Visualforce', FolderId = UserInfo.getUserId(),
        Name = 'CCC_Voided_Question', Markup=templateText, 
        IsActive = true);
    
       // template.Markup=templateText;
        //template.TargetObjectId=cont.Id;
    
        System.runAs(usr){
        insert template;
        }

        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '54321';
        insert act;

        Case c = new Case();
        c.Id =cs.Id;
        c.Clarification_Team_Link__c = act.Id;
        update c;
        sendClariEmail.sendVoidEmail(c.Id, cqClari);
    }      

    @istest
    public static  void sendVoidEmailProofType(){
        
        OrgWideEmailAddress[] addresses = [SELECT Id, DisplayName FROM OrgWideEmailAddress];

        Account a = new Account(Name = 'AccountTest', Customer_Category__c = 'BOOKSTORE');
        insert a;

        Contact cont = new Contact();
        cont.firstname = 'Jack';
        cont.lastname = 'Frost';  
        cont.Email = 'hello@goodbye.com';
        cont.AccountId = a.Id;
        cont.Phone = '12345';
        cont.Responsibility_Type__c = 'SALES_SERVICE';
        cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Clarification Contact').getRecordTypeId();
        insert cont;

        Case cs =new Case();
        cs.AccountId = a.Id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        cs.ContactId = cont.Id;
        cs.Clarification_To_Email__c = 'hello@goodbye.com';
        cs.Proof_To_Email__c = 'hello@goodbye.com';
        cs.Clarification_CC_Email__c = 'Test@test.com';
        cs.Proof_CC_Email__c = 'Test@test.com';
        cs.EBS_Account_Number__c = '54321';
        insert cs;
        
        Clarification_Question__c cqClari= new Clarification_Question__c(Case__c = cs.Id,  
        Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof');
        insert cqClari;

        Profile pf = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User usr = new User(
            Alias                 = 'usralias',
            Email                 = 'theuser@email.com',
            Emailencodingkey      = 'UTF-8',
            Lastname              = 'user_lastname',
            Languagelocalekey     = 'en_US',
            Localesidkey          = 'en_US',
            Profileid             =  pf.Id,
            Timezonesidkey        = 'America/Los_Angeles',
            Username              =  Math.random() + 'test@testuser.com',
            CompanyName           = 'the company'
        );
        insert usr;
        string templateText = '<messaging:emailTemplate subject="Test" recipientType="User" relatedToType="Case"><messaging:htmlEmailBody ><ul><li>test content</li></ul></messaging:htmlEmailBody></messaging:emailTemplate>';
        EmailTemplate template = new EmailTemplate(DeveloperName = 'AW_Voided_Question', TemplateType= 'Visualforce', FolderId = UserInfo.getUserId(),
        Name = 'AW_Voided_Question',
        IsActive = true);
    
        template.Markup=templateText;
    
        System.runAs(usr){
        insert template;
        }

        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '54321';
        insert act;

        Case c = new Case();
        c.Id =cs.Id;
        c.Proof_Team_Link__c = act.Id;
        update c;
        sendClariEmail.sendVoidEmail(c.Id, cqClari);
    }    
}