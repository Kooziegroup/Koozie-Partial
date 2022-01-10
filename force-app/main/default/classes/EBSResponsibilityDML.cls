global class EBSResponsibilityDML {
    
    @future(callout=true)
    public static void getJsonString(string contID, string DMLType) {
        
        //Get Contact Information
        Responsibility_Type__c con = [Select ID, First_Name__c, Last_Name__c, Mailing_Street__c, Mailing_City__c, Mailing_State__c, 
            Mailing_Postal_Code__c, Mailing_Country__c, County__c, Email__c, Phone__c, Other_Phone__c, Fax__c, 
            Responsibility_Type__c, Customer_Account_Number__c, PhoneID__c, 
            FaxID__c, OtherPhoneID__c, EmailID__c, Contact_ID__c, Address1_ID__c,
            Account_Record_Type__c, Contact_Status__c, PrimaryEmailFlag__c, PrimaryFaxFlag__c, 
            PrimaryOtherPhoneFlag__c, PrimaryPhoneFlag__c, Other_Email_ID__c, Other_Email__c, 
            PrimaryOtherEmailFlag__c, Primary_Responsibility_Flag__c, contact__r.firstname, contact__r.lastname, contact__r.mailingstreet, 
            contact__r.mailingcity, contact__r.mailingstate, contact__r.mailingPostalCode, contact__r.mailingCountry, Contact__r.Address1_ID__c
            From Responsibility_Type__c
            Where ID =: contID] ;
        
            system.debug('######' + con.Account_Record_Type__c);
            
        if(con.Account_Record_Type__c == 'Customers' || Test.isRunningTest()){
            //Update email primary flag
            if(con.Email__c != null || con.Other_Email__c != null){
                Responsibility_Type__c conToUpdatePrimary = respPrimaryStatus(con);
                con.PrimaryEmailFlag__c = conToUpdatePrimary.PrimaryEmailFlag__c;
                con.PrimaryOtherEmailFlag__c = conToUpdatePrimary.PrimaryOtherEmailFlag__c;
            } else {
                con.PrimaryEmailFlag__c = false;
                con.PrimaryOtherEmailFlag__c = false;               
            }
            
            if(con.First_Name__c == null){
                con.First_Name__c = 'Clarification';
            }

            //Handle request in another class
            HttpResponse response = new HttpResponse();
            response = EBSResponsibilityDMLRequest.EBSResponsibilityDMLRequest(con, DMLType);
            
            //Handle response in another class
            EBSResponsibilityDMLResponse.EBSResponsibilityDMLResponse(response, con, DMLType);
            
        }   
    }
    /*
    public static void getJsonStringNotFuture(string contID, string DMLType) {
        
        //Get Contact Information
        Responsibility_Type__c con = [Select ID, First_Name__c, Last_Name__c, Mailing_Street__c, Mailing_City__c, Mailing_State__c, 
            Mailing_Postal_Code__c, Mailing_Country__c, County__c, Email__c, Phone__c, Other_Phone__c, Fax__c, 
            Responsibility_Type__c, Customer_Account_Number__c, PhoneID__c, 
            FaxID__c, OtherPhoneID__c, EmailID__c, Contact_ID__c, Address1_ID__c,
            Account_Record_Type__c, Contact_Status__c, PrimaryEmailFlag__c, PrimaryFaxFlag__c, 
            PrimaryOtherPhoneFlag__c, PrimaryPhoneFlag__c, Other_Email_ID__c, Other_Email__c, 
            PrimaryOtherEmailFlag__c, Primary_Responsibility_Flag__c, contact__r.firstname, contact__r.lastname, contact__r.mailingstreet, 
            contact__r.mailingcity, contact__r.mailingstate, contact__r.mailingPostalCode, contact__r.mailingCountry, Contact__r.Address1_ID__c            
            From Responsibility_Type__c
            Where ID =: contID] ;
        
            system.debug('######' + con.Account_Record_Type__c);
            
        if(con.Account_Record_Type__c == 'Customers' || Test.isRunningTest()){
            //Update email primary flag
            if(con.Email__c != null || con.Other_Email__c != null){
                Responsibility_Type__c conToUpdatePrimary = respPrimaryStatus(con);
                con.PrimaryEmailFlag__c = conToUpdatePrimary.PrimaryEmailFlag__c;
                con.PrimaryOtherEmailFlag__c = conToUpdatePrimary.PrimaryOtherEmailFlag__c;
            } else {
                con.PrimaryEmailFlag__c = false;
                con.PrimaryOtherEmailFlag__c = false;               
            }
            
            if(con.First_Name__c == null){
                con.First_Name__c = 'Clarification';
            }            

            //Handle request in another class
            HttpResponse response = new HttpResponse();
            response = EBSResponsibilityDMLRequest.EBSResponsibilityDMLRequest(con, DMLType);
            
            //Handle response in another class
            EBSResponsibilityDMLResponse.EBSResponsibilityDMLResponse(response, con, DMLType);
            
        }   
    }    */

    //Setting the primary email flag 
    public static Responsibility_Type__c respPrimaryStatus(Responsibility_Type__c con){
    
        If((con.PrimaryEmailFlag__c != true || con.Email__c == null) && (con.PrimaryOtherEmailFlag__c != true || con.Other_Email__c == null)){
            If(con.Email__c == null && con.Other_Email__c != null){
                con.PrimaryOtherEmailFlag__c = true;
                con.PrimaryEmailFlag__c = false;
            } else if (con.Email__c != null && con.Other_Email__c == null){
                con.PrimaryOtherEmailFlag__c = false;
                con.PrimaryEmailFlag__c = true;
            }
        }
        
        return con;
    }   


}