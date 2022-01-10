global class BatchCloseOpps implements Database.Batchable<Opportunity> {
    global Integer queryLimit;
    global BatchCloseOpps(boolean isTest) {
        if(isTest) {
            queryLimit = 200;
        }
        else {
            queryLimit = 5000000;
        }
    }
    global Iterable<Opportunity> start(Database.batchableContext bc) {
        return [select id from opportunity where closedate <= last_n_days:1 and IsClosed != TRUE limit 5000000 for update];
    }
    
    global void execute(Database.batchableContext bc, list<opportunity> records) {
        for(opportunity o:records) {
            o.stagename='Closed';
            o.Reason__c='Abandoned';
        }
        update records;
    }
    
    global void finish(database.batchablecontext bc) {
        // You could send an email or store result info, etc.
    }
}