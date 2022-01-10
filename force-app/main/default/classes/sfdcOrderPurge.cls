///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Batch class used to grab orders older than 27 months
global class sfdcOrderPurge implements Database.Batchable<sObject>{

    //Method used to get querylocator
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        //Variables used to create dynamic SOQL
        Date todDate = system.today();
        Date purgeDate = todDate.addMonths(-27);  
        String sOQLQuery = 'select Id FROM EBS_Order__c WHERE Effective_Date__c <= :purgeDate';
        
        //Return queryLocator
        return Database.getQueryLocator(sOQLQuery);        
    }
    
    //Execute the batch
    global void execute(Database.Batchablecontext BC, List<sObject> scope){

        //Delete list of orders if not null 
        if(scope.size()>0){
            delete scope;
        }    
    }

   //Needed in class but does nothing
   global void finish(Database.BatchableContext BC){
   }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////