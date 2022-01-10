Global class ResendBounceEmailBatchScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      ResendBounceEmailBatch b = new ResendBounceEmailBatch(); //ur batch class
      database.executebatch(b,10);
   }
}