@RestResource(urlMapping='/CreateContactService/*')
global with sharing class CreateContactService{
    @HttpPost
    global static CreateContactResponse doPost() {
//    global static String doPost() {
    
        CreateContactResponse response = new CreateContactResponse();
        String body = RestContext.request.requestBody.toString();
        
         if(body != null) {
            try {
                CreateContactRequest conReq = (CreateContactRequest)JSON.deserialize(body, CreateContactRequest.class);
                if(conReq != null) {
                system.debug('######In the Create Process');
                    List<CaseCreateRequest.Audience> audiences = new List<CaseCreateRequest.Audience>();
                    CaseCreateRequest.Audience audience = new CaseCreateRequest.Audience();
                    audience.FirstName = conReq.firstName;
                    audience.LastName = conReq.lastName;
                    audience.Email = conReq.email;
                    audience.EBSID = (conReq.ebsid != null && conReq.ebsid != '') ? conReq.ebsid : '';
                    audience.EBSACCTID = conReq.EBSACCID;
                    audiences.add(audience);
                    List<Contact> contacts = CreateConUtil.createContacts(audiences, '');
                    system.debug('######After contact Create');
                    
                    if(contacts != null && contacts.size() > 0) {
                        CreateContactResponse.success_response = TRUE;
                        CreateContactResponse.message_response = 'A contact was successfully created.';
                    } else {
                        CreateContactResponse.success_response = TRUE;
                        CreateContactResponse.message_response = 'A contact and responsibility type already exists.';                      
                    }
                }
            } catch(Exception ex) {
                CreateContactResponse.success_response = FALSE;
                CreateContactResponse.message_response = 'An error has occured while processing this request: ' + ex.getMessage();
            }
        }
        
        //CreateContactResponse response = new CreateContactResponse()
        response.success = CreateContactResponse.success_response ;
        response.message = CreateContactResponse.message_response ;
        
        //string response = string.valueOf(CreateContactResponse.success) + ':' + string.valueOf(CreateContactResponse.message);
        system.debug(JSON.serialize(response));
        
        return response;
        //return null;
    }
    
}