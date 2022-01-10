Global class OpportunityUpdateBatchScheduler implements Schedulable {
  global void execute(SchedulableContext SC) {
      OpportunityUpdateBatch b = new OpportunityUpdateBatch(); //ur batch class
      database.executebatch(b,10);
   }
}