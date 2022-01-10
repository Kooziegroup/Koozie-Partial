@RestResource(urlMapping='/POContact/*')
global with sharing class poContactProcess {
    @HttpPost
    global static string doPost() {

        String body = RestContext.request.requestBody.toString();
        POContact caseReq = (POContact)JSON.deserialize(body, POContact.class);
        system.debug(caseReq);
        
        serviceResponse srr = new serviceResponse();
        srr.Status = 'SUCCESS';
        SRR.Message = '';
        
        return string.valueOf(srr);
    }
    
    public class POContact
    {
        public String Email;
        public String FirstName;
        public String LastName;
        public String AccountNumber;
        public String AccountName;
    }    
    
    public class serviceResponse
    {
        public String status;
        public String message;
    }     
}