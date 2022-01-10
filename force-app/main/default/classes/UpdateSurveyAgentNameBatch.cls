global class UpdateSurveyAgentNameBatch Implements Database.Batchable<sObject> {
    global UpdateSurveyAgentNameBatch(){
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query ='';
        if(test.isRunningTest()){
             query = 'Select id ,Agent_ID__c,Agent_Name__c from Custom_Survey__c';
        }
        else{
             query = 'Select id ,Agent_ID__c,Agent_Name__c from Custom_Survey__c where Agent_ID__c !=null  and createddate = today';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Custom_Survey__c> surveyList) {
        System.debug('UpdateSurveyAgentName Batch Executed@@@@');
        System.debug('surveyList@@@@'+surveyList.size());
       list<Custom_Survey__c> updateSurveyList = new list<Custom_Survey__c>();
        set<String> agentIdSet = new Set<String>();
         for(Custom_Survey__c survey:surveyList){
             agentIdSet.add(survey.Agent_ID__c);
             
         }
        system.debug('agentIdSet@@@@'+agentIdSet);
        List<User> UserList = new List<User>();
        UserList = [select id,Agent_ID__c from user where Agent_ID__c IN :agentIdSet];
        system.debug('UserList@@@@@'+UserList.size());
        Map<string,user> UseragentIdMap = new Map<string,user>();
        if(!UserList.isEmpty()){
            for(user usr:UserList){
                UseragentIdMap.put(usr.Agent_ID__c,usr);
            }
        }
        system.debug('UseragentIdMap@@@@'+UseragentIdMap);
        for(Custom_Survey__c survey:surveyList){
            Custom_Survey__c srv = new Custom_Survey__c();
            srv.id = survey.id;
            system.debug('survey.Agent_ID__c@@@@'+survey.Agent_ID__c);
            if(UseragentIdMap !=null){
                srv.Agent_Name__c = UseragentIdMap.get(survey.Agent_ID__c).id;
            }
            updateSurveyList.add(srv);
        }
        
        if(!updateSurveyList.isEmpty()){
            system.debug('updateSurveyList@@@@'+updateSurveyList);
            update updateSurveyList;
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}