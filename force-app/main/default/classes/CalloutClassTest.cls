@isTest
private class CalloutClassTest {
    @isTest(seealldata = true) static void testCallout() {

        Map<String, Map<String, String>> mpCommEmail = new Map<String, Map<String, String>>();        
        Map<String, Map<String, String>> mpCommPhone = new Map<String, Map<String, String>>();
        Map<String, String> mpTempCommEmail = new Map<String, String>();
        Map<String, String> mpTempCommPhone = new Map<String, String>();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://example.com/example/test');
        req.setMethod('GET');        
        //HttpResponse res = calloutContact.calloutContact(req);

        RecordType rt = new RecordType();
        rt = [Select ID From RecordType Where Name = 'Customers' and sObjectType = 'Account'];
        
        Account acct = new Account(name='Test', recordtypeID = rt.ID);
        insert acct;
        
        Contact con = new Contact(lastname='Johnson', email='jj@jj.com',Other_Email__c = 'j@j.com', phone = '4075551212',  
            otherPhone = '407-444-1212', FAX = '407-777-4848', AccountID=acct.ID);
        insert con;

        Contact conPS = EBSContactDML.conPrimaryStatus(con); 

        mpTempCommEmail.put(con.email, '1234');
        mpTempCommEmail.put(con.Other_Email__c, '5678');
        mpCommEmail.put('EMAIL',mpTempCommEmail);

        mpTempCommPhone.put(con.Phone, '1234');
        mpTempCommPhone.put(con.OtherPhone, '5678');
        mpCommPhone.put('PHONE',mpTempCommPhone);        

        EBSContactDML.getJsonString(con.id, 'CREATE');
        EBSContactDMLResponse.conEmailParse(mpCommEmail,con);
        EBSContactDMLResponse.conPhoneParse(mpCommPhone,con);

        EBSContactDMLRequest.EventRequest er = new EBSContactDMLRequest.EventRequest();
        EBSContactDMLRequest.CustomerContact cc = new EBSContactDMLRequest.CustomerContact();

        EBSContactDMLRequest.Communications com = new EBSContactDMLRequest.Communications();
        com = EBSContactDMLRequest.commTypeCreate(con, 'CREATE');
        com = EBSContactDMLRequest.commTypeUpdate(con, 'UPDATE');
        

        con.Phone = '407-555-1212';
        con.Other_Email__c = 'no@email.com';
        con.OtherPhone = '407-555-1212';
        con.Fax = '407-555-1212';   
        update con;       
               

        con.Other_Email__c = null;
        con.email = 'jj@jj.com';
        update con;            
        EBSContactDML.getJsonString(con.id, 'CREATE');
        conPS = EBSContactDML.conPrimaryStatus(con);
        
        Responsibility_type__c rst = new Responsibility_Type__c();
        rst.Contact__c = con.Id;
        rst.Account__c = acct.Id;
        rst.email__c = con.email;
        rst.First_Name__c = con.FirstName;
        rst.Last_Name__c = con.LastName;
        rst.Responsibility_Type__c = 'Clarifications';
        insert rst;
        
        rst.Phone__c = '407-555-1212';
        rst.Other_Email__c = 'no@email.com';
        rst.Other_Phone__c = '407-555-1212';
        rst.Fax__c = '407-555-1212';        
        update rst;
 
        EBSResponsibilityDMLRequest.EBSResponsibilityDMLRequest(rst, 'Update');
     
    }
}