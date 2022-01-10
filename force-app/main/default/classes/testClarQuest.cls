///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Test class for class used to grab orders modified in last 2 hours
@isTest(seeallData=true)
public class testClarQuest{
    public static testmethod void test(){
        Test.startTest();
        
        Product2 p = new Product2(Name='Testing123',Product_ID__c = '12345');
        insert p;
        
        EBS_Order__c eo = new EBS_Order__c(order_type__c = 'Sample Fullfillment',City__c ='Happy Town');
        insert eo;
        
        EBS_Order_Line__c eol = new EBS_Order_Line__c(PRODUCT_ID__c = '12345',  
            line_type__c = 'Standard (Line Invoicing)',  Order__c=eo.ID, Order_Line_ID__c='159753');
        insert eol;

        RecordType rt = [Select Id, Name From recordtype where name = 'clarificationQuestion' limit 1];
        
        Case c = new Case(status= 'Awaiting Clarification', Origin = 'Phone', subject = 'Testing');
        insert c;
        
        Clarification_Question__c cq = new Clarification_Question__c();
        cq.Recordtypeid = rt.Id;
        cq.Line_Number__c = '1';
        cq.SEQ__c = 1;
        cq.Status__c = 'Open';
        cq.EBS_Order_Line_ID__c = '159753';
        cq.Message_text__c = 'Hello';
        cq.EBS_ID__c = '999999999';
        cq.Question_Type__c = 'Clarification';
        cq.Case__c = c.Id;
        
        insert cq;
    }
}