///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
global without sharing class EmailPublisherForHighPriorityCases implements QuickAction.QuickActionDefaultsHandler {

    // Empty constructor
    global EmailPublisherForHighPriorityCases() {
    }
    
    // The main interface method
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) 
    {
        //Get the object type and record ID 
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(0);
        EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject(); 
        
        //Get case details and email mapping record if it exists
        Case c = [SELECT CaseNumber, Priority, Account.Routing_Override__c, Account.EBS_Num__c, Account.Name, RecordType.Name FROM Case WHERE Id=:sendEmailDefaults.getContextId()];    
        List<Elite_Email_Mapping__c> lstEEM = new List<Elite_Email_Mapping__c>();
        List<String> ccAddressString =  new List<String>();
        
        If(c.RecordType.Name == 'Claims'){
            lstEEM = [
                select ID, EMAIL_ADDRESS__C, CC_Email__c 
                from Elite_Email_Mapping__c 
                WHERE Case_Record_Type_Name__c =: c.Recordtype.Name];            

        } else {
            lstEEM = [
                select ID, EMAIL_ADDRESS__C, CC_Email__c 
                from Elite_Email_Mapping__c 
                WHERE ACCOUNT_NUMBER__c =: c.ACCOUNT.EBS_Num__c];
        }

        
        //If email mapping list is populated then move to update the email address on the quick action
        if(lstEEM.size() > 0){
        
            //Get first record from email mapping list and assign email address to a string. 
            Elite_Email_Mapping__c emm = lstEEM[0];            
            STRING emailString = emm.EMAIL_ADDRESS__C;
            STRING emailStringCC = emm.CC_Email__c;
            
            //OWD Email variable
            List<OrgWideEmailAddress> lstOWEA = new List<OrgWideEmailAddress>([SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where Address =: emailString]);
            List<OrgWideEmailAddress> lstOWEACC = new List<OrgWideEmailAddress>();
            
            if(emm.CC_Email__c != null){
                lstOWEACC = new List<OrgWideEmailAddress>([
                    SELECT Id, Address, DisplayName 
                    FROM OrgWideEmailAddress 
                    where Address =: emailStringCC]);
            }
            
            //Update email address if OWD Email is populated
            if(lstOWEA.size()>0){
                //Search Org Wide email address for mapped email
                OrgWideEmailAddress owea = lstOWEA[0]; 
                
                //Update from address on quick action
                emailMessage.FromAddress = owea.Address;  
                
                if(lstOWEACC.size()>0){
                    //emailMessage.CcAddress = lstOWEACC[0].Address;
                    ccAddressString.add(lstOWEACC[0].Address);  
                }
                
                if(c.Account.Name == 'DELUXE US CALENDAR COOP EDI'){
                    ccAddressString.add('dropship@deluxe.com');
                }
                
                if(ccAddressString.size() > 0){
                    emailMessage.ccAddress = ccAddressString.toString();
                }
                 
                emailMessage.FromName = owea.DisplayName; 
                emailMessage.ValidatedFromAddress  = owea.Address;   
            }          
        } else if (c.Account.Name == 'DELUXE US CALENDAR COOP EDI'){
            emailMessage.ccAddress = 'dropship@deluxe.com;';
        }
              
    } 
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////