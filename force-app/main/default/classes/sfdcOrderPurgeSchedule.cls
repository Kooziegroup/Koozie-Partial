///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Schedule Batch Process to purge eBS orders
global class sfdcOrderPurgeSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        sfdcOrderPurge s = new sfdcOrderPurge();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(s,200);
    }   
}