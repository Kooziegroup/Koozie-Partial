@isTest
public class UpdateSurveyAgentNameBatchTest {

     static testMethod void updateSurveyAgentTest() {
         Test.StartTest();
         Custom_Survey__c survey = new Custom_Survey__c();
     //    survey.Agent_ID__c ='test';
         insert survey;
         
        
         UpdateSurveyAgentNameBatchScheduler obj =  new UpdateSurveyAgentNameBatchScheduler();
         
         String cronExp = '0 0 0,4,8,12,16,20 ? * *';
         
         system.schedule('UpdateSurveyAgentNameBatch', cronExp, obj); 
         test.Stoptest();
         
     }
}