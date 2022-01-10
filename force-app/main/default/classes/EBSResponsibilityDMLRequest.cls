public with sharing class EBSResponsibilityDMLRequest {

    public class EBSCallout {
        public EventRequest EventRequest = new EventRequest();
    }   
    
    public class EventRequest {
        public String EventObject;
        public String EventType;
        public DateTime EventDateTime;
        public String EventSourceSystem;
        public String EventRecordSystem;
        public String EventBusinessID;
        
        public CustomerContacts CustomerContacts = new CustomerContacts();
    }
    
    public class CustomerContacts {
        public string CustomerAccountNumber;
        public CustomerContact[] CustomerContact = new CustomerContact[] {};        
    }
    
    public class CustomerContact {
        public string ContactID;
        public string CustomerAccountNumber;
        public String ContactFirstName;
        public String ContactLastName;
        public DateTime ContactCreateDate;
        public DateTime ContactLastUpdateDate;
        public String ResponsibilityType;
        public String PrimaryResponsibilityFlag;
        public String ContactStatus;
        public String ActiveFlag;
        public String PrimaryFlag;
        
        public ContactAddress ContactAddress = new ContactAddress();
        public Communications Communications = new Communications();        
    }
    
    public class ContactAddress {       
        public ContactAddresses[] ContactAddresses = new ContactAddresses[] {};
        
    }
    
    public class ContactAddresses {
        public string AddressID;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String County;
        public String Province;
        public String City;
        public String State;
        public String Country;
        public String PostalCode;       
    }   
    
    public class Communications {
        public CommunicationsArray[] CommunicationArray = new CommunicationsArray[]{};
        
    }       
    
    public class CommunicationsArray {
        public String CommunicationID;
        public String CommunicationMethod;
        public String CommunicationInfo;        
        public String ActiveFlag;
        public String PrimaryFlag;
    }   

    public static HTTPResponse EBSResponsibilityDMLRequest(Responsibility_Type__c con, String DMLType) {

        //Setting up Json string outer section
        EBSCallout EBSCallout = new EBSCallout();
        
        //Get Environment Variables
        String host = URL.getSalesforceBaseUrl().getHost();
        String server = host.substring(0,host.indexOf('.'));         
        
        //Setting up Json EventRequest
        EventRequest EventRequest = new EventRequest();
        EventRequest.EventObject = 'CUSTOMER_CONTACT';
        EventRequest.EventType = DMLType;
        EventRequest.EventDateTime = system.now();
        EventRequest.EventSourceSystem = 'Salesforce';
        EventRequest.EventRecordSystem = 'EBS';
        EventRequest.EventBusinessID = '1234567890';
            
        //Setting up Json contact section
        CustomerContacts CustomerContacts = new CustomerContacts();     
        CustomerContact cc = new CustomerContact();
            
        //Setting up Json contact details
        cc.ContactID = (DMLType == 'CREATE') ? null : con.Contact_ID__c;
        cc.CustomerAccountNumber = con.Customer_Account_Number__c;
        cc.ContactFirstName = con.contact__r.FirstName;
        cc.ContactLastName = con.contact__r.LastName;
        cc.ContactCreateDate = system.Now();
        cc.ContactLastUpdateDate = system.Now();
        cc.ResponsibilityType = con.Responsibility_Type__c; 
        cc.PrimaryResponsibilityFlag= con.Primary_Responsibility_Flag__c;
        cc.ContactStatus = (con.Contact_Status__c == 'Active') ? 'A' : 'I';
        cc.ActiveFlag = 'A';
            
        //Setting up Json address details
        ContactAddress ca = new ContactAddress();       
        ContactAddresses caa = new ContactAddresses();  
        caa.AddressID = (DMLType == 'CREATE') ? null : con.Address1_ID__c;
        caa.AddressLine1 = (con.contact__r.MailingStreet == null && con.Contact__r.Address1_ID__c == null) ? 'EMPTY' : con.contact__r.MailingStreet;
        caa.AddressLine2 = '';
        caa.AddressLine3 = '';
        caa.AddressLine4 = '';
        caa.County = con.County__c;
        caa.Province = con.contact__r.MailingState;
        caa.City = con.contact__r.MailingCity;
        caa.State = con.contact__r.MailingState;
        caa.Country = (con.contact__r.MailingCountry == NULL && con.Contact__r.Address1_ID__c == null) ? 'NA' : con.contact__r.MailingCountry;
        caa.PostalCode = con.contact__r.MailingPostalCode; 
            
        ca.ContactAddresses.add(caa);
            
        //Setting up Json communications details
        //If values are null then send over as inactive
        //Also, other phone is never primary
        Communications c = new Communications();
        if(DMLType == 'CREATE'){
            c = commTypeCreate(Con, DMLType);
        } else {
            c = commTypeUpdate(Con, DMLType);
        }
            
        cc.ContactAddress = ca;   
        cc.Communications = c;
            
        //Putting Json together
        CustomerContacts.CustomerAccountNumber = con.Customer_Account_Number__c; 
        CustomerContacts.CustomerContact.add(cc);       
        EventRequest.CustomerContacts = CustomerContacts;
        EBSCallout.EventRequest = EventRequest;
            
        //Creating Json string
        string jsonSrting = JSON.serializePretty(EBSCallout);

        //Rest Request
        Http http=new Http();
        HttpRequest request=new HttpRequest();          

        //Get environment details from custom settings
        AppInfo__c app = AppInfo__c.getValues('WebClient');       
        
        //Get user details from custom settings
        string username = app.user__c;
        string password = app.password__c;
        string endpoint = app.endpoint__c;                  

        request.setEndpoint(endpoint);
        request.setMethod('POST');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonSrting);
        request.setTimeout(60000);
        
        HttpResponse response = new HttpResponse();
            
        //Get response
        if(!Test.isRunningTest()){
            response = calloutContact.calloutContact(request);   //response=http.send(request);
        } else {
            MockHTTPResponseGenerator mhc = new MockHTTPResponseGenerator();
            response = mhc.respond(request);
        }        

        //Add Json request text to SF
        Apex_Errors__c att = new Apex_Errors__c();  
        att.string__c = jsonSrting;     
        att.Type__c = 'Request'; 
        att.Responsibility_Type__c = con.Id;
        insert att;         

        return response;
    }

    public static Communications commTypeCreate(Responsibility_Type__c con, string DMLType){

        //Setting up Json communications details
        //If values are null then send over as inactive
        //Also, other phone is never primary
        Communications c = new Communications();        
        CommunicationsArray caEmail = new CommunicationsArray();
        CommunicationsArray caOEmail = new CommunicationsArray();
        CommunicationsArray caPhone = new CommunicationsArray();
        CommunicationsArray caOtherPhone = new CommunicationsArray();
        CommunicationsArray caFax = new CommunicationsArray();

        if(con.Email__c != null){
            caEmail.CommunicationID = (DMLType == 'CREATE' || con.EmailID__c == null) ? null : con.EmailID__c;
            caEmail.CommunicationInfo = con.Email__c;
            caEmail.ActiveFlag =  'A';
            caEmail.PrimaryFlag = (con.PrimaryEmailFlag__c == True || con.PrimaryOtherEmailFlag__c == null) ? 'true' : 'false';         
            caEmail.CommunicationMethod = 'EMAIL';
            c.CommunicationArray.add(caEmail); 
        }
            
        if(con.Other_Email__c != null){
            caOEmail.CommunicationID = (DMLType == 'CREATE') ? null : con.Other_Email_ID__c;
            caOEmail.CommunicationInfo =  con.Other_Email__c;
            caOEmail.ActiveFlag = 'A';
            caOEmail.PrimaryFlag = (con.PrimaryOtherEmailFlag__c == True || con.PrimaryEmailFlag__c == null) ? 'true' : 'false';            
            caOEmail.CommunicationMethod = 'EMAIL';
            c.CommunicationArray.add(caOEmail);
        }
            
        if(con.Phone__c != null){
            caPhone.CommunicationID = (DMLType == 'CREATE') ? null : con.PhoneID__c;
            caPhone.CommunicationInfo = con.Phone__c;
            caPhone.ActiveFlag = 'A';
            caPhone.PrimaryFlag = (con.PrimaryPhoneFlag__c == True) ? 'true' : 'false';                     
            caPhone.CommunicationMethod = 'PHONE';
            c.CommunicationArray.add(caPhone);
        }
            
        if(con.Other_Phone__c != null){
            caOtherPhone.CommunicationID = (DMLType == 'CREATE') ? null : con.Other_Phone__c;
            caOtherPhone.CommunicationInfo = con.Other_Phone__c;
            caOtherPhone.ActiveFlag = 'A';
            caOtherPhone.PrimaryFlag = (con.PrimaryOtherPhoneFlag__c == True) ? 'true' : 'false';               
            caOtherPhone.CommunicationMethod = 'PHONE';     
            c.CommunicationArray.add(caOtherPhone); 
        }       
            
        if(con.Fax__c != null){
            caFax.CommunicationID = (DMLType == 'CREATE') ? null : con.FaxID__c;
            caFax.CommunicationInfo = con.Fax__c;
            caFax.ActiveFlag = 'A';
            caFax.PrimaryFlag = (con.PrimaryFaxFlag__c == True) ? 'true' : 'false';                 
            caFax.CommunicationMethod = 'FAX';      
            c.CommunicationArray.add(caFax);
        }
        
        return c;
    }       

    public static Communications commTypeUpdate(Responsibility_Type__c con, string DMLType){

        //Setting up Json communications details
        //If values are null then send over as inactive
        //Also, other phone is never primary
        Communications c = new Communications();        
        CommunicationsArray caEmail = new CommunicationsArray();
        CommunicationsArray caOEmail = new CommunicationsArray();
        CommunicationsArray caPhone = new CommunicationsArray();
        CommunicationsArray caOtherPhone = new CommunicationsArray();
        CommunicationsArray caFax = new CommunicationsArray();

        system.debug('#########Debug');

        if(con.Email__c != null || con.EmailID__c != null){
            caEmail.CommunicationID = (con.EmailID__c == null) ? null : con.EmailID__c;
            caEmail.CommunicationInfo = con.Email__c;
            caEmail.ActiveFlag =  (con.Email__c != null) ? 'A' : 'I';
            if(con.Email__c != null){
                caEmail.PrimaryFlag = (con.PrimaryEmailFlag__c == True || con.PrimaryOtherEmailFlag__c == null) ? 'true' : 'false';     
            } else {
                caEmail.PrimaryFlag = 'false';
            }
            caEmail.CommunicationMethod = 'EMAIL';
            c.CommunicationArray.add(caEmail); 
        }
            
        if(con.Other_Email__c != null || con.Other_Email_ID__c != null){
            caOEmail.CommunicationID = (con.Other_Email_ID__c == null) ? null : con.Other_Email_ID__c;
            caOEmail.CommunicationInfo =  con.Other_Email__c;
            caOEmail.ActiveFlag = (con.Other_Email__c != null) ? 'A' : 'I';         
            if(con.Other_Email__c != null){
                caOEmail.PrimaryFlag = (con.PrimaryOtherEmailFlag__c == True || con.PrimaryEmailFlag__c == null) ? 'true' : 'false';        
            } else {
                caOEmail.PrimaryFlag = 'false';
            }                   
            caOEmail.CommunicationMethod = 'EMAIL';
            c.CommunicationArray.add(caOEmail);
        }
        
        if(con.Phone__c != null || con.PhoneID__c != null){
            caPhone.CommunicationID = (con.PhoneID__c == null) ? null : con.PhoneID__c;
            caPhone.CommunicationInfo =  con.Phone__c ;
            caPhone.ActiveFlag = (con.Phone__c != null) ? 'A' : 'I';           
            if(con.Phone__c != null){
                caPhone.PrimaryFlag = (con.PrimaryPhoneFlag__c == True) ? 'true' : 'false';     
            } else {
                caPhone.PrimaryFlag = 'false';
            }                   
            caPhone.CommunicationMethod = 'PHONE';
            c.CommunicationArray.add(caPhone);
        }       
            
        if(con.Other_Phone__c != null || con.OtherPhoneID__c != null){
            caOtherPhone.CommunicationID = (con.OtherPhoneID__c == null) ? null : con.OtherPhoneID__c;
            caOtherPhone.CommunicationInfo =  con.Other_Phone__c;
            caOtherPhone.ActiveFlag = (con.Other_Phone__c != null) ? 'A' : 'I';         
            if(con.Other_Phone__c != null){
                caOtherPhone.PrimaryFlag = (con.PrimaryOtherPhoneFlag__c == True) ? 'true' : 'false';       
            } else {
                caOtherPhone.PrimaryFlag = 'false';
            }                   
            caOtherPhone.CommunicationMethod = 'PHONE';
            c.CommunicationArray.add(caOtherPhone);
        }                   
            
        if(con.Fax__c != null || con.FaxID__c != null){
            caFax.CommunicationID = (con.FaxID__c == null) ? null : con.FaxID__c;
            caFax.CommunicationInfo =  con.Fax__c;
            caFax.ActiveFlag = (con.Fax__c != null) ? 'A' : 'I';           
            if(con.Fax__c != null){
                caFax.PrimaryFlag = (con.PrimaryFaxFlag__c == True) ? 'true' : 'false';     
            } else {
                caFax.PrimaryFlag = 'false';
            }                   
            caFax.CommunicationMethod = 'FAX';
            c.CommunicationArray.add(caFax);
        }       
        
        return c;
    }       
}