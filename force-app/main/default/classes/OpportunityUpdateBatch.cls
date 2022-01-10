global class OpportunityUpdateBatch Implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'Select id ,StageName,Reason__c,CloseDate from opportunity where CloseDate < today and StageName !=\'Closed Lost\' And StageName !=\'Closed Won\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<opportunity> oppList) {
        list<opportunity> updateopp = new list<opportunity>();
        for(opportunity opp:oppList){
                opp.StageName ='Closed Lost';
                opp.Reason__c='Abandoned';
                updateopp.add(opp);
        }
        if(!updateopp.isEmpty()){
            update updateopp;
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}