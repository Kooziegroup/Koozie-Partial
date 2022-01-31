///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public without sharing class sendClariEmail{

    public static void sendEmail(List<String> caseRecordString, String emailType){
        system.debug('sendemail method @@@@@@');
        String setCustomerToEmail;
        String host = URL.getSalesforceBaseUrl().getHost();
        String server = host.substring(0,host.indexOf('.'));
        String sentEmail = 'customerService@KoozieGroup.com';
        List<OrgWideEmailAddress> defOWE = new List<OrgWideEmailAddress>();
        List<Case> lstCase = [SELECT id, Customer_To_Email__c FROM Case WHERE Customer_To_Email__c != NULL];
        if(lstCase.size() > 0) {
            setCustomerToEmail = lstCase[0].Customer_To_Email__c;
        }
        //Get Org Wide Email List for parsing
        List<OrgWideEmailAddress> allOWE = 
            [SELECT Id, Address, DisplayName 
            FROM OrgWideEmailAddress ];
        Map<String, OrgWideEmailAddress> mpOWEToEmail = new Map<String, OrgWideEmailAddress>();
        
        //Loop and add to OWE Map
       // system.debug(mpOWEToEmail+'@@@servicecld');
        system.debug(allOWE+'@@@servicecld OWE');
        
        For(OrgWideEmailAddress owe : allOWE){
                mpOWEToEmail.put(owe.Address, owe);
        }
        system.debug(mpOWEToEmail+'@@@servicecld MpOWE');
        system.debug('====server====== ' +server);
        if(server.contains('--')){  
            system.debug('inside if @@@@@@@@@@@@@@@'+mpOWEToEmail.get('servicecloudexceptions@outlook.com'));
            //defOWE.add(mpOWEToEmail.get('servicecloudexceptions@outlook.com'));
            defOWE.add(mpOWEToEmail.get('customerservice@kooziegroup.com')); 
            //sentEmail = 'servicecloudexception@outlook.com';     
            sentEmail = 'customerservice@kooziegroup.com';     
      
        } else {
            system.debug('inside if @@@@@@@@@@@@@@@'+mpOWEToEmail.get('customerservice@kooziegroup.com'));
            defOWE.add(mpOWEToEmail.get('customerservice@kooziegroup.com')); 
            sentEmail = 'customerservice@kooziegroup.com';                    
        }           
        
        
       // system.debug(mpOWEToEmail.get('customerservice@kooziegroup.com'));

        
        //Remove duplicates from caseRecordString 
        Set<String> setRec = new Set<String>();
        
        For(String cRS : caseRecordString){
            if(!setRec.contains(cRS)){
                setRec.add(cRS);
            }         
        }       
        
        if(setRec.size() > 0){
            caseRecordString.clear();
            caseRecordString.addAll(setRec);
        }
        system.debug('@@defaultemailPrerak'+defOWE);
        String defaultEmailID = defOWE[0].Address;
        system.debug('======= '+defaultEmailID);
        //ID defaultEmailID = '0D23p000000k9q3';
        String defaultEmailID_CCC = defOWE[0].Address; 
        system.debug('======= '+defaultEmailID_CCC);
        String defaultEmailID_AW = defOWE[0].Address;
        system.debug('======= '+defaultEmailID_AW);
        String defaultEmailID_4i = defOWE[0].Address;
        system.debug('======= '+defaultEmailID_4i);
        List<String> lstContEmail = new List<String>();
        List<Clarification_Question__c> cqUpdate = new List<Clarification_Question__c>();

        //Get clarification record type
       /*  RecordType rtClar = new RecordType();
        rtClar = [Select ID From RecordType Where sObjectType ='Contact' and Name = 'Clarification Contact']; */
        Id rtClar =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Clarification Contact').getRecordTypeId();


        //Variables for mapping cases and creating contacts 
        List<Apex_Errors__c> aeInsert = new List<Apex_Errors__c>();
        List<Case> updCase = new List<Case>();
        List<Contact> createContact = new List<Contact>();
        Map<String, Contact> mpCont = new Map<String, Contact>();   
        Map<String, List<Clarification_Question__c>> mpQuestions = new Map<String, List<Clarification_Question__c>>();    
        List<Clarification_Question__c> lstClariQues = new List<Clarification_Question__c>();
        
        //Create case map 
        Map<ID, Case> mpCases = new Map<ID, Case>([Select ID, Contact.email, ContactID, 
                Proof_Team_Link__c, Proof_Team_Link__r.From_Email__c, Proof_To_Email__c, 
                Clarification_Team_Link__c, Clarification_Team_Link__r.From_Email__c, Clarification_To_Email__c, 
                AccountId, SuppliedEmail, SuppliedName, SuppliedPhone, Current_Process__c, CaseNumber, 
                EBS_PO_Number__c, EBS_Order_Number__c, ThreadID_FK__c, Clarification_CC_Email__c, 
                Proof_CC_Email__c, Account.Customer_Category__c, Account.Logo__c, Email_Bounced__c,
                Account.Corporate_Route__c, Customer_To_Email__c
                From Case where Id =: caseRecordString]);

        //Loop through and create new contact if necessary
        Set<string> contactEmail = new Set<string>();
        List<Contact> contLst = new List<Contact>();
        Map<String, ID> mpContId = new Map<String, ID>();

        For(Case c : mpCases.values()){
            if(c.Proof_To_Email__c != null){
                contactEmail.add(c.Proof_To_Email__c);
                System.debug('===Entered into IF==== '+contactEmail);
            }

            if(c.Clarification_To_Email__c != null){
                contactEmail.add(c.Clarification_To_Email__c);
                System.debug('===Entered into IF==== '+contactEmail);
            }    
        }

        if(contactEmail.size() > 0){
            System.debug('===Entered into IF====');
            contLst = [Select Id, Email From Contact Where email =: contactEmail LIMIT 1];

            if(contLst.size()>0){
                For(Contact con : contLst){
                    if(!(mpContId.containsKey(con.Email))){
                        mpContId.put(con.Email, con.Id);
                    }
                    contactEmail.remove(con.Email);
                }
            }
        }

        //Loop through case string and populate list to create new contacts
        For(string caseID : caseRecordString){
        
            //Populate variable to create contact
            if((mpCases.get(caseID) != null && mpCases.get(caseID).ContactID == null) || contactEmail.size()> 0){
                Contact newCont = new Contact();
                newCont.FirstName = mpCases.get(caseID).SuppliedName;
                newCont.LastName = (emailType == 'Clarification') ? mpCases.get(caseID).Clarification_To_Email__c : mpCases.get(caseID).Proof_To_Email__c;
                newCont.Email =    (emailType == 'Clarification') ? mpCases.get(caseID).Clarification_To_Email__c : mpCases.get(caseID).Proof_To_Email__c;
                newCont.AccountId = (mpCases.get(caseID).AccountID != null) ? mpCases.get(caseID).AccountID : null;
                newCont.RecordTypeId = (rtClar == null) ? null : rtClar;
                newCont.Responsibility_Type__c = 'CLARIFICATIONS';
                createContact.add(newCont);       
            }    
        }
        
        //Get list of emails from case
        For(Case emailCase : mpCases.values()){
            
            if(emailCase.Clarification_To_Email__c != null) lstContEmail.add(emailCase.Clarification_To_Email__c);
            System.debug('========Clar to Email==== '+lstContEmail);
            if(emailCase.Proof_To_Email__c != null) lstContEmail.add(emailCase.Proof_To_Email__c);
        }

        //Query for contact and add to contact map
        if(lstContEmail.size() > 0){
            List<Contact> lstCurrentContact = new List<Contact>([Select ID, Email From Contact Where email=: lstContEmail]);
            System.debug('========Contact==== '+lstCurrentContact);
            if(lstCurrentContact.size() > 0){
                For(Contact con : lstCurrentContact){
                    mpCont.put(con.Email, con);
                }
            }
        }
        
        //Create list of clarification questions
        /* List<Clarification_Question__c> lstCaseQues = new List<Clarification_Question__c>(
                [Select ID, Case__c, Question_Type__c
                From Clarification_Question__c 
                where Case__c =: caseRecordString
                and Status__c != 'Closed' and Status__c != 'EBS Closed' 
                and Question_Type__c =: emailType]); */

        List<Clarification_Question__c> lstCaseQues = new List<Clarification_Question__c>(
                [Select ID, Case__c, Question_Type__c,RecordType.Name
                From Clarification_Question__c 
                where Case__c =: caseRecordString 
                AND Status__c != 'Closed' AND Status__c != 'EBS Closed' AND(RecordType.Name = 'ClarificationQuestion' OR RecordType.Name = 'ProofQuestion' OR RecordType.Name = 'NotificationQuestion')]);
                //System.debug('===== '+ emailType);
                //System.debug('===== '+ lstCaseQues[0].Question_Type__c);
                //System.debug('===== '+caseRecordString);
        
        system.debug('lstCaseQues size@@@@'+lstCaseQues.size());
        //Make sure there are open questions before proceeding 
        if(lstCaseQues.size() > 0)
        {
            //Loop through questions to create map for later use
            For(Clarification_Question__c cQues : lstCaseQues){
                lstClariQues.add(cQues);
                String mpID = string.valueOf(cQues.Question_Type__c) + cQues.Question_Type__c;
                mpQuestions.put(mpID, lstClariQues);
                System.debug('====xyxy===== '+mpID);

                //Need to close notification once email sent
                if(cQues.Question_Type__c == 'Notification'){
                    cQues.status__c = 'Closed';
                    cQues.notification_sent__c = True;
                    cqUpdate.add(cQues);
                } else {
                    cQues.notification_sent__c = True;
                    cqUpdate.add(cQues);                    
                }
            }
            
            //Create Contact if list is not null and add to map
            If(createContact.size() > 0){
            
                try{
                    insert createContact;
                } 
                catch(DmlException e){
                    Apex_Errors__c ae = new Apex_Errors__c();
                    ae.Error_Date_Time__c = dateTime.now();
                    ae.Error_Message__c = e.getMessage();
                    aeInsert.add(ae);
                    insert aeInsert;
                }
                
                //Add contact to map with email as unique ID. 
                For(Contact contMp : createContact){
                    mpCont.put(contMp.email, contMp);
                }
            }
            
            Messaging.Email[] arrayMessage = new Messaging.Email[0];
            
         //   Try{

                //Loop through case list to create email string
                For(Case caseList : mpCases.values()){
                    
                    //Set up variable for contactId;
                    ID contID = null;                
                    String proofTemplate = 'Proof Template';
                    String clarificationTemplateTemplate = 'Clarification Template';
                    string notificationTemplate = 'Notification Template';
                    String PONum = (caseList.EBS_PO_Number__c != null) ? caseList.EBS_PO_Number__c : 'N/A';            
                    String OrdNum = (caseList.EBS_Order_Number__c!= null) ? caseList.EBS_Order_Number__c: 'N/A';
                    List<string> lstProofEmail = new List<string>();
                    List<string> lstClariEmail = new List<string>();
                    
                    if(caseList.Current_Process__c == 'Initial Email'){
                        if(caseList.Account.Customer_Category__c == 'NON-VERIFIED' || caseList.Account.LOGO__C == 'CALENDAR COOP'){
                            clarificationTemplateTemplate  = 'CCC - Clarification Template';
                            proofTemplate  = 'CCC - Proof Template';
                            notificationTemplate = 'Notification Template';
                        } else if(caseList.Account.Customer_Category__c == 'CHURCH' || caseList.Account.Customer_Category__c == 'BOOKSTORE'){
                            clarificationTemplateTemplate  = 'AW- Clarification Template';
                            proofTemplate  = 'AW- Proof Template';              
                            notificationTemplate = 'Notification Template';
                        } else if(caseList.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                                    (caseList.Customer_To_Email__c != null && caseList.Customer_To_Email__c.contains('4Imprint'))){
                            clarificationTemplateTemplate  = '4Imprint - Clarification Template';
                            proofTemplate  = '4Imprint - Proof Template';            
                            notificationTemplate = '4Imprint Notification Template';                    
                        } else {
                            clarificationTemplateTemplate  = 'Clarification Template';
                            proofTemplate  = 'Proof Template';    
                            notificationTemplate = 'Notification Template';
                        }
                    } else if(caseList.Current_Process__c == 'Customer Contact Call' || caseList.Current_Process__c == 'Confirmation/Reminder Call'
                            || caseList.Current_Process__c == 'Confirmation/Reminder Call - 24 Hr'){
                        if(caseList.Account.Customer_Category__c == 'NON-VERIFIED' || caseList.Account.LOGO__C == 'CALENDAR COOP'){
                            clarificationTemplateTemplate = 'CCC - Clarification - Customer Contact';
                            proofTemplate  = 'CCC - Proof - Customer Contact';
                            notificationTemplate = 'Notification Template';
                        }
                        else if(caseList.Account.Customer_Category__c == 'CHURCH' || caseList.Account.Customer_Category__c == 'BOOKSTORE'){
                            clarificationTemplateTemplate = 'AW - Clarification - Customer Contact';
                            proofTemplate  = 'AW - Proof - Customer Contact';  
                            notificationTemplate = 'Notification Template';                 
                        } else if(caseList.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                                    (caseList.Customer_To_Email__c != null && caseList.Customer_To_Email__c.contains('4Imprint'))){
                            clarificationTemplateTemplate  = '4Imprint - Clarification - Customer Contact';
                            proofTemplate  = '4Imprint - Proof - Customer Contact';            
                            notificationTemplate = '4Imprint Notification Template';
                        } else {
                            clarificationTemplateTemplate = 'Clarification - Customer Contact';
                            proofTemplate  = 'Proof - Customer Contact';
                            notificationTemplate = 'Notification Template' ;                
                        }               
                    } else if(caseList.Current_Process__c ==  'Cancellation Notice'){
                    //} else if(caseList.Current_Process__c ==  'Day 11 Final Notice'){
                        if(caseList.Account.Customer_Category__c == 'NON-VERIFIED' || caseList.Account.LOGO__C == 'CALENDAR COOP'){          
                            clarificationTemplateTemplate = 'CCC - Clarification - Cancellation Notice';
                            proofTemplate  = 'CCC - Proof - Cancellation Notice';
                            notificationTemplate = 'Notification Template';
                        } else if(caseList.Account.Customer_Category__c == 'CHURCH' || caseList.Account.Customer_Category__c == 'BOOKSTORE'){
                            clarificationTemplateTemplate = 'AW - Clarification - Cancellation Notice';
                            proofTemplate  = 'AW - Proof - Cancellation Notice';  
                            notificationTemplate = 'Notification Template';
                        } else if(caseList.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                                    (caseList.Customer_To_Email__c != null && caseList.Customer_To_Email__c.contains('4Imprint'))){
                            clarificationTemplateTemplate  = '4Imprint - Clarification - Cancellation Notice';
                            proofTemplate  = '4Imprint - Proof - Cancellation Notice';   
                            notificationTemplate = '4Imprint Notification Template';
                        } else {
                            clarificationTemplateTemplate = 'CCC - Clarification - Cancellation Notice';
                            proofTemplate  = 'Proof - Cancellation Notice';     
                            notificationTemplate = 'Notification Template';        
                        }               
                    } else if(caseList.Current_Process__c == 'Cancellation'){
                        if(caseList.Account.Customer_Category__c == 'NON-VERIFIED' || caseList.Account.LOGO__C == 'CALENDAR COOP'){          
                            clarificationTemplateTemplate = 'CCC - Clarification Template - Cancellation';
                            proofTemplate  = 'CCC - Proof Template - Cancellation';
                            notificationTemplate = 'Notification Template';
                        } else if(caseList.Account.Customer_Category__c == 'CHURCH' || caseList.Account.Customer_Category__c == 'BOOKSTORE'){
                            clarificationTemplateTemplate = 'AW - Clarification Template - Cancellation';
                            proofTemplate  = 'AW - Proof Template - Cancellation';        
                            notificationTemplate = 'Notification Template';
                        } else if(caseList.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                                    (caseList.Customer_To_Email__c != null && caseList.Customer_To_Email__c.contains('4Imprint'))){
                            clarificationTemplateTemplate  = '4Imprint - Clarification Template - Cancellation';
                            proofTemplate  = '4Imprint - Proof Template - Cancel';   
                            notificationTemplate = '4Imprint Notification Template';
                        } else {
                            clarificationTemplateTemplate = 'Clarification Template - Cancellation';
                            proofTemplate  = 'Proof Template - Cancellation';  
                            notificationTemplate = 'Notification Template';             
                        }
                        
                        caseList.status = 'Closed';
                        updCase.add(caseList);               
                    }         
                    
                    system.debug(mpOWEToEmail.get('customerservice@kooziegroup.com'));
                    
                    //Add CC email address to the list.  
                    if(emailType == 'Clarification' || emailType == 'Notification'){
                        IF(caseList.Clarification_Team_Link__c != null){
                            sentEmail = caseList.Clarification_Team_Link__r.From_Email__c;
                            System.debug('===== '+sentEmail);
                        }
                        
                        IF(caseList.Clarification_CC_Email__c != NULL){
                            lstClariEmail.add(caseList.Clarification_CC_Email__c);
                        }
                        
                        IF(caseList.Clarification_To_Email__c != NULL){
                            lstClariEmail.add(caseList.Clarification_To_Email__c);
                        }               

                    } else If(emailType == 'Proof'){
                        IF(caseList.Proof_Team_Link__c != null){
                            sentEmail = caseList.Proof_Team_Link__r.From_Email__c;
                        }
                        
                        IF(caseList.Proof_CC_Email__c != NULL){
                            lstClariEmail.add(caseList.Proof_CC_Email__c);
                        }
                        
                        IF(caseList.Proof_To_Email__c != NULL){
                            lstClariEmail.add(caseList.Proof_To_Email__c);
                            System.debug('==== '+lstClariEmail);
                        }               
                    }                            
                    
                    //Get information from email
                    if((emailType == 'Clarification' || emailType == 'Notification') && 
                        mpCont.get(caseList.Clarification_To_Email__c) != null){
                        contID = mpCont.get(caseList.Clarification_To_Email__c).ID;
                    } else If(emailType == 'Proof'  && mpCont.get(caseList.Proof_To_Email__c) != null){
                        contID = mpCont.get(caseList.Proof_To_Email__c).ID;
                    } 
                    
                    system.debug(mpOWEToEmail.get('customerservice@kooziegroup.com'));
                    
                    //OWD Email List
                    List<OrgWideEmailAddress> lstOWEA = new List<OrgWideEmailAddress>();
                    if(sentEmail != null && sentEmail != ''){
                        lstOWEA.add(mpOWEToEmail.get(sentEmail));
                        system.debug(mpOWEToEmail.get(sentEmail));
                        system.debug(sentEmail);
                    }
                
                    //Create message particulars
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    
                    
                    //Update contactID 
                    if(contID == null){
                        message.setTargetObjectId(caseList.ContactID); 
                        message.toAddresses = new String[] {caseList.Contact.email};
                        message.setToAddresses(lstClariEmail);
                    } else {
                        message.setTargetObjectId(contID);
                        message.toAddresses = new String[] {contID};
                        message.setToAddresses(lstClariEmail);
                        System.debug('=======  '+message);
                        if(caseList.Current_Process__c != 'Cancellation'){
                            Case caseToUpdate = caseList;
                            caseToUpdate.ContactID = contID;
                            updCase.add(caseToUpdate);
                        }
                    }
                    
                    message.setUseSignature(false); 
                    message.setBccSender(false); 
                    message.setSaveAsActivity(true); 
                    
                    //Update email address if OWD Email is populated
                    if(lstOWEA.size()>0){
                        //Set FROM address to OrgWide Email address
                        OrgWideEmailAddress owea = lstOWEA[0]; 
                        message.setOrgWideEmailAddressId(owea.Id);   
                        System.debug('=======  '+message);
                    } else {
                        if(caseList.Account.Customer_Category__c == 'NON-VERIFIED' || caseList.Account.LOGO__C == 'CALENDAR COOP'){          
                            message.setOrgWideEmailAddressId(defaultEmailID_CCC); 
                        } else if(caseList.Account.Customer_Category__c == 'CHURCH' || caseList.Account.Customer_Category__c == 'BOOKSTORE'){
                            message.setOrgWideEmailAddressId(defaultEmailID_AW); 
                        } else if(caseList.Account.Corporate_Route__c == 'Elite 802 4Imprint' || (caseList.Customer_To_Email__c != null && caseList.Customer_To_Email__c.contains('4Imprint'))){
                            message.setOrgWideEmailAddressId(defaultEmailID_4I); 
                        } else{
                            message.setOrgWideEmailAddressId(defaultEmailID);                 
                        }   
                    }
                    
                    EmailTemplate emailTemplate;
                    
                    //Get template information
                    //if(emailType == 'Proof'){
                        if(lstCaseQues[0].RecordType.Name == 'ProofQuestion'){
                        System.debug('======Proof Template======= ');
                        emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body,TemplateType,FolderId  
                            from EmailTemplate 
                            where Name =: proofTemplate];
                    }// else if(emailType == 'Clarification'){
                        else if(lstCaseQues[0].RecordType.Name == 'ClarificationQuestion'){
                        System.debug('======Clarification Template======= ');
                        emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body,TemplateType,FolderId 
                            from EmailTemplate 
                            where Name =:  clarificationTemplateTemplate];
                    } else if(emailType == 'Notification'){
                        emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body,TemplateType,FolderId 
                            from EmailTemplate 
                            where Name =:  notificationTemplate];
                    }
                    
                    //Continue setting up the email
                    message.setTemplateID(emailTemplate.Id); 
                    message.setWhatId(caseList.ID); 
                    
                    //Add message to message array for mass sending
                    arrayMessage.add(message);
                    System.debug('======= '+arrayMessage);

                }
          //  } catch(Exception e){               
                 //   aeInsert.clear();
                 //   Apex_Errors__c aeEmailHandler = new Apex_Errors__c();
                 //   aeEmailHandler.Error_Date_Time__c = dateTime.now();
                 //   aeEmailHandler.Error_Message__c = e.getMessage();
                //    aeInsert.add(aeEmailHandler);   
               //     insert aeInsert;                    
         //   }
            
            system.debug('arrayMessage size @@@@@@'+arrayMessage.size());

            if(arrayMessage.size() > 0){
            System.debug('=======  '+arrayMessage);
                Try{
                    system.debug('before sending email@@@@@@');
                    List<Messaging.SendEmailResult> emResults = Messaging.sendEmail(arrayMessage);

                    if(cqUpdate.size() >0){
                        update cqUpdate;
                    }

                    system.debug('############');
                    system.debug(emResults);
                    system.debug(arrayMessage[0]);
                    system.debug('############');
                }
                catch(EmailException e){
                    system.debug('####BOUNCED####');
                    system.debug(e);
                    system.debug('####BOUNCED####');

                    For(Case c : updCase){
                        c.Email_Bounced__c = True;
                    }
                    
                    aeInsert.clear();
                    Apex_Errors__c aeEmail = new Apex_Errors__c();
                    aeEmail.Error_Date_Time__c = dateTime.now();
                    aeEmail.Error_Message__c = e.getMessage();
                    aeInsert.add(aeEmail); 
                    System.debug('======= '+aeInsert);  
                    insert aeInsert;                 
                }           
            }
            
            if(updCase.size()>0){
                update updCase;
            }
        }
    }
    
    public static void sendVoidEmail(ID caseRecordString, Clarification_Question__c clarQues){
        //List of email addresses to add to email
        List<String> lstToEmail = new List<String>();        
        
        String strVoidTemplate = 'Void Template';
        
        //Create case map 
        Case caseList = new Case();
        caseList = [Select ID, Contact.email, ContactID, 
                Proof_Team_Link__c, Proof_Team_Link__r.From_Email__c, Proof_To_Email__c, 
                Clarification_Team_Link__c, Clarification_Team_Link__r.From_Email__c, Clarification_To_Email__c, 
                AccountId, SuppliedEmail, SuppliedName, SuppliedPhone, Current_Process__c, CaseNumber, 
                EBS_PO_Number__c, EBS_Order_Number__c, ThreadID_FK__c, Clarification_CC_Email__c, 
                Proof_CC_Email__c, Account.Customer_Category__c, Account.Logo__c, Email_Bounced__c,
                Account.Corporate_Route__c, Customer_To_Email__c
                From Case where Id =: caseRecordString];                      
        
        //Populuate list if fields not null
        If(clarQues.Question_Type__c == 'Proof'){
        
            if(clarQues.Case__r.Proof_CC_Email__c != null){
                lstToEmail.add(clarQues.Case__r.Proof_CC_Email__c);
            }
            
            if(clarQues.Case__r.Proof_To_Email__c != null){
                lstToEmail.add(clarQues.Case__r.Proof_To_Email__c);
            }           
        } else {
            if(clarQues.Case__r.Clarification_CC_Email__c != null){
                lstToEmail.add(clarQues.Case__r.Clarification_CC_Email__c);
            }

            if(clarQues.Case__r.Clarification_To_Email__c != null){
                lstToEmail.add(clarQues.Case__r.Clarification_To_Email__c);
            }       
        }
        
        if(clarQues.Case__r.Account.Customer_Category__c == 'NON-VERIFIED' || clarQues.Case__r.Account.LOGO__C == 'CALENDAR COOP'){
            strVoidTemplate  = 'CCC - Voided Question';
        } else if(clarQues.Case__r.Account.Customer_Category__c == 'CHURCH' || clarQues.Case__r.Account.Customer_Category__c == 'BOOKSTORE'){
            strVoidTemplate  = 'AW - Voided Question';
        } else if(clarQues.Case__r.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
            (clarQues.Case__r.Customer_To_Email__c != null && clarQues.Case__r.Customer_To_Email__c.contains('4Imprint'))){
            strVoidTemplate  = '4Imprint - Voided Question';                
        } else {
            strVoidTemplate  = 'Voided Question';
        }  
        
        
        ID fromEmailID = null;
        fromEmailID = getFromEmail(caseList, clarQues.Question_Type__c);     
            
        //Create message particulars
        Messaging.Email[] arrayMessage = new Messaging.Email[0];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         message.setOrgWideEmailAddressId(fromEmailID);
        message.setTargetObjectId(clarQues.Case__r.ContactID);
        message.toAddresses = new String[] {clarQues.Case__r.ContactID};
            
        if(lstToEmail.size() >0){
            message.setToAddresses(lstToEmail);
        }
             
        message.setUseSignature(false); 
        message.setBccSender(false); 
        message.setSaveAsActivity(true); 
        //message.setOrgWideEmailAddressId(fromEmailID);
        
        
        EmailTemplate emailTemplate;
                
        //Get template information
        emailTemplate = 
            [Select Id,Subject,Description,HtmlValue,DeveloperName,Body 
                from EmailTemplate 
                where name =: strVoidTemplate];
                System.debug('========= '+emailTemplate);
                System.debug('========= '+strVoidTemplate);
        //Continue setting up the email
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(clarQues.Case__c);         
            
        //Add message to message array for mass sending
        arrayMessage.add(message);  

        if(arrayMessage.size() > 0){
            if(!test.isRunningTest())
            List<Messaging.SendEmailResult> emResults = Messaging.sendEmail(arrayMessage);                 
        }
    }    
        
    public static ID getFromEmail(Case caseList, String emailType){
        String host = URL.getSalesforceBaseUrl().getHost();
        String server = host.substring(0,host.indexOf('.'));    
        String sentEmail = 'customerService@KoozieGroup.com';
        List<OrgWideEmailAddress> defOWE = new List<OrgWideEmailAddress>();
        List<string> lstProofEmail = new List<string>();
        List<string> lstClariEmail = new List<string>();        
        Map<String, Contact> mpCont = new Map<String, Contact>(); 
        Map<String, ID> mpContId = new Map<String, ID>(); 
        ID contID = null;              
        
        //Get Org Wide Email List for parsing
        List<OrgWideEmailAddress> allOWE = [SELECT Id, Address, DisplayName 
        FROM OrgWideEmailAddress];
        Map<String, OrgWideEmailAddress> mpOWEToEmail = new Map<String, OrgWideEmailAddress>();
        
        //Loop and add to OWE Map
        For(OrgWideEmailAddress owe : allOWE){
            mpOWEToEmail.put(owe.Address, owe);
        }
        
        if(server.contains('--')){                
            defOWE.add(mpOWEToEmail.get('servicecloudexception@outlook.com')); 
            sentEmail = 'servicecloudexception@outlook.com';         
      
        } else {
            defOWE.add(mpOWEToEmail.get('customerservice@kooziegroup.com')); 
            sentEmail = 'customerservice@kooziegroup.com';                    
        }         
        
        if(server.contains('--')){            
            defOWE.add(mpOWEToEmail.get('servicecloudexception@outlook.com')); 
            sentEmail = 'servicecloudexception@outlook.com';         
      
        } else {
            defOWE.add(mpOWEToEmail.get('customerservice@kooziegroup.com')); 
            sentEmail = 'customerservice@kooziegroup.com';         
        }  

        //Add CC email address to the list.  
         if(emailType == 'Clarification' || emailType == 'Notification'){
             IF(caseList.Clarification_Team_Link__c != null){
                 sentEmail = caseList.Clarification_Team_Link__r.From_Email__c;
             }
             
             IF(caseList.Clarification_CC_Email__c != NULL){
                 lstClariEmail.add(caseList.Clarification_CC_Email__c);
             }
             
             IF(caseList.Clarification_To_Email__c != NULL){
                 lstClariEmail.add(caseList.Clarification_To_Email__c);
             }           

         } else If(emailType == 'Proof'){
             IF(caseList.Proof_Team_Link__c != null){
                 sentEmail = caseList.Proof_Team_Link__r.From_Email__c;
             }
             
             IF(caseList.Proof_CC_Email__c != NULL){
                 lstClariEmail.add(caseList.Proof_CC_Email__c);
             }
             
             IF(caseList.Proof_To_Email__c != NULL){
                 lstClariEmail.add(caseList.Proof_To_Email__c);
             }           
         }                 
         
         //OWD Email List
         List<OrgWideEmailAddress> lstOWEA = new List<OrgWideEmailAddress>();
         if(sentEmail != null && sentEmail != ''){
             lstOWEA.add(mpOWEToEmail.get(sentEmail));
             system.debug(mpOWEToEmail.get(sentEmail));
             system.debug(sentEmail);
         } 
         
         return mpOWEToEmail.get(sentEmail).ID;
    }    
}