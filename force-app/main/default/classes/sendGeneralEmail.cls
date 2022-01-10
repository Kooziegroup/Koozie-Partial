public with sharing class sendGeneralEmail {
    public static void sendGeneralEmail(List<String> clarRecString) {        
        //Get default OWD Email ID
        String host = URL.getSalesforceBaseUrl().getHost();
        String server = host.substring(0,host.indexOf('.'));
        List<Case> lstUpdCase = new List<Case>();
        List<ID> updCase = new List<ID>();
        List<OrgWideEmailAddress> lstDefaultOWEA = new List<OrgWideEmailAddress>();
        List<OrgWideEmailAddress> lstDefaultOWEA_CCC = new List<OrgWideEmailAddress>();
        List<OrgWideEmailAddress> lstDefaultOWEA_AW = new List<OrgWideEmailAddress>();
        List<OrgWideEmailAddress> lstDefaultOWEA_4I = new List<OrgWideEmailAddress>();
        
        if(server.contains('--')){    
        
            List<OrgWideEmailAddress> defTestOWE = [SELECT Id, Address, DisplayName 
            FROM OrgWideEmailAddress where Address = 'servicecloudexceptions@outlook.com'];
    
            //Get default OWD Email ID
            lstDefaultOWEA.addAll(defTestOWE);
            
            lstDefaultOWEA_CCC.addAll(defTestOWE);
            
            lstDefaultOWEA_AW.addAll(defTestOWE);  
            
            lstDefaultOWEA_4I.addAll(defTestOWE);            
        } else {
        
            List<OrgWideEmailAddress> defOWE = [SELECT Id, Address, DisplayName 
            FROM OrgWideEmailAddress where Address = 'Customerservice@kooziegroup.com'];
                  
            //Get default OWD Email ID
            lstDefaultOWEA.addAll(defOWE);
            
            lstDefaultOWEA_CCC.addAll(defOWE);
            
            lstDefaultOWEA_AW.addAll(defOWE);      
            
            lstDefaultOWEA_4I.addAll(defOWE);
        }                 
        
        
        ID defaultEmailID = lstDefaultOWEA[0].ID;
        ID defaultEmailID_CCC = lstDefaultOWEA_CCC[0].ID;
        ID defaultEmailID_AW = lstDefaultOWEA_AW[0].ID;
        ID defaultEmailID_4i = lstDefaultOWEA_4I[0].ID;

        String templateName = '';

        //Variables for mapping cases and creating contacts 
        List<Apex_Errors__c> aeInsert = new List<Apex_Errors__c>();
        List<Clarification_Question__c> updCQ = new List<Clarification_Question__c>();    
        
        //Create clarification question map 
        Map<ID, Clarification_Question__c> mpClarQuest = new Map<ID, Clarification_Question__c>(
            [SELECT Id, Authorization_Name__c, Authorization_Organization__c, Case_Contact__c, 
            PO_Number__c, SO_Number__c, Case__r.CaseNumber, Status__c, Case_Contact__r.AccountID, 
            Case__r.Proof_Team_Link__c, Case__r.Proof_Team_Link__r.From_Email__c, Case__r.Proof_To_Email__c, 
            Case__r.Clarification_Team_Link__c, Case__r.Clarification_Team_Link__r.From_Email__c, Case__r.Clarification_To_Email__c,             
            Proof_Disposition__c, EBS_Order_Number__c, Case__c, Case__r.ContactID, Case__r.Account.Customer_Category__c,
            Case__r.Account.LOGO__c, Case__r.Account.Corporate_Route__c, Case__r.Customer_To_Email__c
            FROM Clarification_Question__c  
            WHERE Id =: clarRecString
            AND Clarification_Cancellation__c = False]);

        Messaging.Email[] arrayMessage = new Messaging.Email[0];

        //Loop through clarification question list to create email string
        For(Clarification_Question__c clarQList : mpClarQuest.values()){
         
            updCase.add(clarQList.Case__c);
            
            List<Elite_Email_Mapping__c> lstEEM = new List<Elite_Email_Mapping__c>(
                [select ID, EMAIL_ADDRESS__C 
                FROM Elite_Email_Mapping__c 
                WHERE ACCOUNT_NUMBER__c =: clarQList.Case_Contact__r.AccountID]);   
                
            if(clarQList.Proof_Disposition__c == 'Proof_Approved'){
                if(clarQList.Case__r.Account.Customer_Category__c == 'NON-VERIFIED' || clarQList.Case__r.Account.LOGO__C == 'CALENDAR COOP'){
                    templateName  = 'CCC - Proof Approved';
                } else if(clarQList.Case__r.Account.Customer_Category__c == 'CHURCH' || clarQList.Case__r.Account.Customer_Category__c == 'BOOKSTORE'){
                    templateName  = 'AW - Proof Approved';
                } else if(clarQList.Case__r.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                (clarQList.Case__r.Customer_To_Email__c != null && clarQList.Case__r.Customer_To_Email__c.contains('4Imprint'))){
                    templateName  = '4Imprint - Proof Approved';  
                } else {
                    templateName  = 'Proof Approved';
                }
            } else if(clarQList.Proof_Disposition__c == 'Proof_Approved_W_Changes'){
                if(clarQList.Case__r.Account.Customer_Category__c == 'NON-VERIFIED' || clarQList.Case__r.Account.LOGO__C == 'CALENDAR COOP'){
                    templateName = 'CCC - Change, No Additional Proof Needed';
                }
                else if(clarQList.Case__r.Account.Customer_Category__c == 'CHURCH' || clarQList.Case__r.Account.Customer_Category__c == 'BOOKSTORE'){
                    templateName = 'AW - Change, No Additional Proof Needed';   
                } else if(clarQList.Case__r.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                (clarQList.Case__r.Customer_To_Email__c != null && clarQList.Case__r.Customer_To_Email__c.contains('4Imprint'))){
                    templateName  = '4Imprint - Change, No Additional Proof Needed';
                } else {
                    templateName = 'Change, No Additional Proof Needed';
                }   
            } else {
                if(clarQList.Case__r.Account.Customer_Category__c == 'NON-VERIFIED' || clarQList.Case__r.Account.LOGO__C == 'CALENDAR COOP'){  
                    templateName = 'CCC - Proof Not Approved';
                } else if(clarQList.Case__r.Account.Customer_Category__c == 'CHURCH' || clarQList.Case__r.Account.Customer_Category__c == 'BOOKSTORE'){
                    templateName = 'AW- Proof Not Approved'; 
                } else if(clarQList.Case__r.Account.Corporate_Route__c == 'Elite 802 4Imprint' || 
                (clarQList.Case__r.Customer_To_Email__c != null && clarQList.Case__r.Customer_To_Email__c.contains('4Imprint'))){
                    templateName  = '4Imprint - Proof Not Approved';
                } else {
                    templateName = 'Proof Not Approved';
                }   
            } 
            
            If(clarQList.Case_Contact__c != null || clarQList.Case__r.ContactID != null){

                //Set up internal variables
                String PONum = (clarQList.PO_Number__c != null) ? clarQList.PO_Number__c : 'N/A';            
                String OrdNum = (clarQList.EBS_Order_Number__c!= null) ? clarQList.EBS_Order_Number__c: 'N/A';              
                //String sentEmail = (lstEEM.size() >0) ? lstEEM[0].Email_Address__c : 'Customerservice@kooziegroup.com';
                String sentEmail = (lstEEM.size() >0) ? lstEEM[0].Email_Address__c : lstDefaultOWEA[0].Address;
                    
                 //OWD Email List
                 List<OrgWideEmailAddress> lstOWEA = new List<OrgWideEmailAddress>([SELECT Id, Address, DisplayName 
                     FROM OrgWideEmailAddress where Address =: sentEmail]);                          
            
                //Create message particulars
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();   
                
                String caseContID;   
                
                caseContId = (clarQList.Case_Contact__c != null) ? clarQList.Case_Contact__c : clarQList.Case__r.ContactID;

                message.setTargetObjectId(caseContId);               
                //message.setTargetObjectId('0031900000gZRXZAA4'); 
                message.setUseSignature(false); 
                message.setBccSender(false); 
                message.setSaveAsActivity(true); 
                
                //Update email address if OWD Email is populated
                if(lstOWEA.size()>0){
                    //Set FROM address to OrgWide Email address
                    OrgWideEmailAddress owea = lstOWEA[0]; 
                    message.setOrgWideEmailAddressId(owea.Id);   
                } else {
                    message.setOrgWideEmailAddressId(defaultEmailID); 
                }
                
                EmailTemplate emailTemplate;
                
                emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body 
                from EmailTemplate 
                where name =: templateName];                
                
                //Continue setting up the email
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(clarQList.ID);                
                
                //Send the email
                //Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

                arrayMessage.add(message);

            }
        }

        if(arrayMessage.size() > 0){
        
            Try{
                List<Messaging.SendEmailResult> emResults = Messaging.sendEmail(arrayMessage);

                system.debug('############');
                system.debug(emResults);
                system.debug(arrayMessage[0]);
                system.debug('############');
            }
            catch(EmailException e){
                system.debug('####BOUNCED####');
                system.debug(e);
                system.debug('####BOUNCED####');

                For(Case c : [Select ID, Email_Bounced__c From Case where Id =: updCase]){

                    c.Email_Bounced__c = True;
                    lstUpdCase.add(c);
                }
            }           
        }
        
        if(lstUpdCase.size()>0){
            update lstUpdCase;
        }           
    }
}