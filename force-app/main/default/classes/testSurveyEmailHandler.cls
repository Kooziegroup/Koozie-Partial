@isTest
private class testSurveyEmailHandler{
       
    static testMethod void testSurveyEmailHandler() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
       // Create email body
       email.subject = 'Survey Response';
        string htmlBody = 'Survey Information </br>';
        htmlBody += 'Survey Name    Primary Survey </br>';
        htmlBody += 'Company - Tenant   BIC Graphic - BIC Business Unit 1 </br>';
        htmlBody += 'Channel    VOICE </br>';
        htmlBody += 'Language   US English </br>';
        htmlBody += 'Status COMPLETED </br>';
        htmlBody += 'Date   October 7, 2020 6:17:17 PM GMT </br>';
        htmlBody += 'Integration    CM </br>';
        htmlBody += 'Integration Trigger    27272 </br>';
        htmlBody += 'Agent ID </br>';
        htmlBody += 'UCID   00001110681602094629 </br>';       
        htmlBody += 'Answers </br>';
        htmlBody += 'Question Name  Result  Return Value    Input Value </br>';
        htmlBody += 'Ease   SUCCESS 4   4 </br>';
        htmlBody += 'Satisfied  SUCCESS 1   1 </br>';
        htmlBody += 'Context Information </br>';
        htmlBody += 'AGENT_VDN </br>';  
        htmlBody += 'AGENT_ID </br>';   
        htmlBody += 'ALL_AGENT_VDN </br>';  
        htmlBody += 'INTEGRATION_TYPE   STANDALONE </br>';
        htmlBody += 'UCID   00001110681602094629 </br>';
        htmlBody += 'AGENT_STATION </br>';  
        htmlBody += 'DNIS   27272 </br>';
        htmlBody += 'ALL_AGENT_STATIONS </br>'; 
        htmlBody += 'ALL_AGENT_IDS </br>';  
        htmlBody += 'INTEGRATION_KEY 27272 </br>';
        htmlBody += 'ANI    4074621450 </br>';
        htmlBody += 'SESSION_ID clwslaepmpp01-2020281181717-5 </br>';
        htmlBody += 'UUI_PLAIN  PD,00;F7,0008;F8,042724;F5,45787465726E616C204469616C2042;F4,828E9191;FA,00012B3C5F7E0625 </br>';
        htmlBody += 'A customer has left a new Survey </br>';     
             
       email.htmlBody = htmlBody;
       
       email.plainTextBody = 'Survey Information  Survey Name Primary Survey Company - Tenant    BIC Graphic - BIC Business Unit 1 Channel VOICE Language    US English        Status  COMPLETED     Date    October 4, 2020 6:55:13 PM GMT        Integration CM        Integration Trigger 27272        Agent ID            UCID    00001069151601837735        \nAnswers        \nQuestion Name   \nResult  \nReturn Value    \nInput Value        \nEase    \nSUCCESS \n4   \n4        \nSatisfied   \nSUCCESS \n1   \n1        \nContext Information        \nAGENT_VDN           AGENT_ID            ALL_AGENT_VDN          INTEGRATION_TYPE    STANDALONE        UCID    00001069151601837735        AGENT_STATION           DNIS    27272        ALL_AGENT_STATIONS          ALL_AGENT_IDS           INTEGRATION_KEY 27272        ANI 4074621450        SESSION_ID  clwslaepmpp01-2020278185541-8    UUI_PLAIN   PD,00;F7,0006;F8,042724;F5,45787465726E616C204469616C2042;F4,828EB7A9;FA,00011B035F7A1AA7        A customer has left a new Survey';

       env.fromAddress = 'user@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       SurveyEmailHandler seh = new SurveyEmailHandler ();
       seh.handleInboundEmail(email, env );                            
    } 
}