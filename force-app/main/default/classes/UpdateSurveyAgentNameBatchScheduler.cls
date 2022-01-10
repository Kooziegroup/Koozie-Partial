global class UpdateSurveyAgentNameBatchScheduler  implements Schedulable {
 global void execute(SchedulableContext SC) {
      UpdateSurveyAgentNameBatch b = new UpdateSurveyAgentNameBatch(); //ur batch class
      database.executebatch(b,10);
   }
}