@isTest
public class OpportunityUpdateBatch_test {
    static testMethod void updateSurveyAgentTest() {
        Test.StartTest();
        date d = date.today().addDays(-1);
        opportunity opp = new opportunity();
        opp.name='testoppp';
        opp.CloseDate =d;
        opp.StageName ='Proposal';
        insert opp;
        
        
        OpportunityUpdateBatchScheduler obj =  new OpportunityUpdateBatchScheduler();
        
        String cronExp = '0 0 0,4,8,12,16,20 ? * *';
        
        system.schedule('OpportunityUpdateBatchScheduler', cronExp, obj); 
        test.Stoptest();
        
    }
}