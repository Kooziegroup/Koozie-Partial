global class EBSContactDML {
    
    @future(callout=true)
    public static void getJsonString(string contID, string DMLType) {
    
        system.debug(contID);
        contact conn = new contact(id=contID);
        system.debug(conn);
        
        List<contact> conSel = new List<Contact>([Select id, name, email from contact where id =: contID]);
        system.debug(conSel);
        
        List<Contact> lstCon = new List<Contact>
            ([Select ID, FirstName, LastName, MailingStreet, MailingCity, MailingState, 
            MailingPostalCode, MailingCountry, County__c, Email, Phone, OtherPhone, Fax, 
            Responsibility_Type__c, Account.Customer_Account_Number__c, PhoneID__c, 
            FaxID__c, OtherPhoneID__c, EmailID__c, Contact_ID__c, Address1_ID__c,
            Account.RecordType.Name, Contact_Status__c, PrimaryEmailFlag__c, PrimaryFaxFlag__c, 
            PrimaryOtherPhoneFlag__c, PrimaryPhoneFlag__c, Other_Email_ID__c, Other_Email__c, 
            PrimaryOtherEmailFlag__c, Primary_Responsibility_Flag__c
            From Contact
            Where ID =: contID]);
        
        if(lstCon.size() > 0){
            
            //Get Contact Information
            Contact con = lstCon[0];
            
            /*
            con = [Select ID, FirstName, LastName, MailingStreet, MailingCity, MailingState, 
                MailingPostalCode, MailingCountry, County__c, Email, Phone, OtherPhone, Fax, 
                Responsibility_Type__c, Account.Customer_Account_Number__c, PhoneID__c, 
                FaxID__c, OtherPhoneID__c, EmailID__c, Contact_ID__c, Address1_ID__c,
                Account.RecordType.Name, Contact_Status__c, PrimaryEmailFlag__c, PrimaryFaxFlag__c, 
                PrimaryOtherPhoneFlag__c, PrimaryPhoneFlag__c, Other_Email_ID__c, Other_Email__c, 
                PrimaryOtherEmailFlag__c, Primary_Responsibility_Flag__c
                From Contact
                Where ID =: contID
                ] ;
            */
                system.debug('######' + con.Account.RecordType.Name);
                
            if(con.Account.RecordType.Name == 'Customers' || Test.isRunningTest()){
                //Update email primary flag
                if(con.Email != null || con.Other_Email__c != null){
                    Contact conToUpdatePrimary = conPrimaryStatus(con);
                    con.PrimaryEmailFlag__c = conToUpdatePrimary.PrimaryEmailFlag__c;
                    con.PrimaryOtherEmailFlag__c = conToUpdatePrimary.PrimaryOtherEmailFlag__c;
                } else {
                    con.PrimaryEmailFlag__c = false;
                    con.PrimaryOtherEmailFlag__c = false;               
            }
    
                //Handle request in another class
                HttpResponse response = new HttpResponse();
                response = EBSContactDMLRequest.EBSContactDMLRequest(con, DMLType);
                
                //Handle response in another class
                EBSContactDMLResponse.EBSContactDMLResponse(response, con, DMLType);
                
            }
        } 
    }
    
    public static void getJsonStringNotFuture(string contID, string DMLType) {
        /*
        //Get Contact Information
        Contact con = [Select ID, FirstName, LastName, MailingStreet, MailingCity, MailingState, 
            MailingPostalCode, MailingCountry, County__c, Email, Phone, OtherPhone, Fax, 
            Responsibility_Type__c, Account.Customer_Account_Number__c, PhoneID__c, 
            FaxID__c, OtherPhoneID__c, EmailID__c, Contact_ID__c, Address1_ID__c,
            Account.RecordType.Name, Contact_Status__c, PrimaryEmailFlag__c, PrimaryFaxFlag__c, 
            PrimaryOtherPhoneFlag__c, PrimaryPhoneFlag__c, Other_Email_ID__c, Other_Email__c, 
            PrimaryOtherEmailFlag__c, Primary_Responsibility_Flag__c
            From Contact
            Where ID =: contID] ;
        
            system.debug('######' + con.Account.RecordType.Name);
            
        if(con.Account.RecordType.Name == 'Customers' || Test.isRunningTest()){
            //Update email primary flag
            if(con.Email != null || con.Other_Email__c != null){
                Contact conToUpdatePrimary = conPrimaryStatus(con);
                con.PrimaryEmailFlag__c = conToUpdatePrimary.PrimaryEmailFlag__c;
                con.PrimaryOtherEmailFlag__c = conToUpdatePrimary.PrimaryOtherEmailFlag__c;
            } else {
                con.PrimaryEmailFlag__c = false;
                con.PrimaryOtherEmailFlag__c = false;               
        }

            //Handle request in another class
            HttpResponse response = new HttpResponse();
            response = EBSContactDMLRequest.EBSContactDMLRequest(con, DMLType);
            
            //Handle response in another class
            EBSContactDMLResponse.EBSContactDMLResponse(response, con, DMLType);
            
        }   */
    }    

    //Setting the primary email flag 
    public static contact conPrimaryStatus(Contact con){
    
        If((con.PrimaryEmailFlag__c != true || con.Email == null) && (con.PrimaryOtherEmailFlag__c != true || con.Other_Email__c == null)){
            If(con.Email == null && con.Other_Email__c != null){
                con.PrimaryOtherEmailFlag__c = true;
                con.PrimaryEmailFlag__c = false;
            } else if (con.Email != null && con.Other_Email__c == null){
                con.PrimaryOtherEmailFlag__c = false;
                con.PrimaryEmailFlag__c = true;
            }
        }
        
        return con;
    }   


}