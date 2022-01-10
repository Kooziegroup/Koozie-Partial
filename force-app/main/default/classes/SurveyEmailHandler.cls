global class SurveyEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail( Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
    {
        //String body = email.plainTextBody;    
        String htmlBody = email.HTMLBody;
        
        String body = email.HTMLBody;
        body = body.stripHtmlTags();
        
        List<String> questionOne = new List<String>();
        List<String> questionTwo = new List<String>();
        
        String SurveyResponse = body.substringBetween('Input Value', 'Context Information');
        String SurveyANI = body.substringBetween('ANI', 'SESSION_ID');
        String Status = body.substringBetween('Status', 'Date');
        String DateCompleted = body.substringBetween('Date', 'Integration');
        String UCID = body.substringBetween('UCID', 'Answers');
        String SessionID = body.substringBetween('SESSION_ID', 'UUI_PLAIN');        
        String AgentID = body.substringBetween('Agent ID', 'UCID'); 
        
        List<String> strRespose = new List<String>();
        
        List<String> strResponse = SurveyResponse.split(' ');
        system.debug(strResponse );
        strResponse.remove(0);
        system.debug(strResponse );        
        
        List<String> strPhone = SurveyANI.split('\n');    
        List<String> strStatus = Status.split('\n');    
        List<String> strDateCompleted = DateCompleted.split('\n');    
        List<String> strUCID = UCID.split('\n');    
        List<String> strSessionID = SessionID.split('\n');
        
        //List<String> strAgentID = AgentID.split('\n');
        //strAgentID.remove(0);    
        
        Custom_Survey__c survey = new Custom_Survey__c(
            status__c=strStatus[0], 
            ANI__c=strphone[0], 
            Survey_Email_Body__c=body,
            Completed_Date__c=strDateCompleted[0],
            UCID__c=strUCID[0],
            Session_ID__c=strSessionID[0],
            Agent_ID__c = AgentID,
            html_body__c=htmlBody);
            
        insert survey;    
        
        system.debug('Response: ' + SurveyResponse);
        system.debug('Phone: ' + strPhone);
        system.debug('First: ' + strResponse[0].split(' '));
        system.debug('Second: ' + strResponse[0].split(' '));                   
        system.debug(strResponse);
        
        For(String strLst : strResponse[1].split(' ')){
            if(strLst!= '' && strLst != null){
                questionOne.add(strLst);
                system.debug(questionOne);                
            }    
        }       
        
        For(String strLst : strResponse[2].split(' ')){
            if(strLst!= '' && strLst != null){
                questionTwo.add(strLst);
                system.debug(questionTwo);
            }        
        }  
        
        List<Survey_Response__c> lstSVInsert = new List<Survey_Response__c>();
        
        if(strResponse.size() >= 4){
            Survey_Response__c sr1 = new Survey_Response__c(
                Question_Name__c=strResponse[0],
                Result__c=strResponse[1],
                Return_Value__c=strResponse[2],
                Input_Value__c=strResponse[3],
            Survey__c=survey.ID);
            
            lstSVInsert.add(sr1);
        }
        
        if(strResponse.size() >= 8){
            Survey_Response__c sr2 = new Survey_Response__c(
                Question_Name__c=strResponse[4],
                Result__c=strResponse[5],
               Return_Value__c=strResponse[6],
               Input_Value__c=strResponse[7],
               Survey__c=survey.ID);
               
               lstSVInsert.add(sr2);               
       }
        
        if(lstSVInsert.size() > 0){
            insert lstSVInsert;    
        }
        
        Messaging.InboundEmailresult result = new Messaging.InboundEmailResult();
        result.message = 'Account Name is now ' + account.Name;
        return result;
    }
}