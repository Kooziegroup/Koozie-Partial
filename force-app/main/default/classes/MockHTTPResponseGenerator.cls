@isTest
global class MockHTTPResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{  "EventResponse" : {    "EnterpriseEventID" : "185323667",    "EventBusinessID" : "1234567890",    "EventStatus" : "SUCCESS",    "EventErrorCode" : null,    "EventStatusMessage" : "SUCCESS",    "MustRetryFlag" : false,    "CustomerContacts" : {      "CustomerAccountNumber" : "3456",      "CustomerContact" : [ {        "ContactID" : "1656751",        "ContactFirstName" : "Roger",        "ContactLastName" : "Daltry",        "ContactStatus" : "A",        "JobTitle" : " ",        "ContactCreateDate" : "2020-06-26T18:29:16.000-05:00",        "ContactLastUpdateDate" : "2020-06-26T18:29:16.000-05:00",        "ResponsibilityType" : "SALES_SERVICE",        "ContactAddress" : {          "ContactAddresses" : [ {            "AddressID" : "5065333",            "AddressLine1" : "PO BOX 96042,,,",            "AddressLine2" : " ",            "AddressLine3" : " ",            "AddressLine4" : " ",            "County" : " ",            "City" : "PITTSBURGH",            "State" : "PA",            "Country" : "US",            "PostalCode" : "15226-0042",            "Status" : " "          } ]        },        "Communications" : {          "CommunicationArray" : [ {            "CommunicationID" : "23456789",            "CommunicationMethod" : "EMAIL",            "CommunicationInfo" : "jljsl@jkalf.com",            "QueueRouteNumber" : " ",            "ActiveFlag" : "A",            "PrimaryFlag" : "true"          }, {            "CommunicationID" : "1379945",            "CommunicationMethod" : "PHONE",            "CommunicationInfo" : "5465465",            "QueueRouteNumber" : " ",            "ActiveFlag" : "A",            "PrimaryFlag" : "false"          }, {            "CommunicationID" : "8797987987",            "CommunicationMethod" : "PHONE",            "CommunicationInfo" : "54564654",            "QueueRouteNumber" : " ",            "ActiveFlag" : "A",            "PrimaryFlag" : "false"          }, {            "CommunicationID" : "1379960",            "CommunicationMethod" : "FAX",            "CommunicationInfo" : "546465465",            "QueueRouteNumber" : " ",            "ActiveFlag" : "A",            "PrimaryFlag" : "false"          } ]        }      } ]    }  }}');
        res.setStatusCode(200);
        return res;
    }
}