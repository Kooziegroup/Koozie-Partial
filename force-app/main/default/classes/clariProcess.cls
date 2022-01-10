@RestResource(urlMapping='/ClarificationProcess/*')
global class clariProcess{
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();      
    
        //OrderDetails rw = (OrderDetails)System.JSON.deserialize(requestString,OrderDetails.class);
        //webOrderCreate.orderCreate(rw, requestString);

    }
}