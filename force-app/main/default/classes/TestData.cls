@isTest
public class TestData {

    /**Method to create test Account record**/
    public static Account createAccount(Boolean doInsert){
        Account accRec = new Account();
        accRec.Name = 'Test Account';
        if(doInsert){
            insert accRec;
        }
        return accRec;
    }
    
    /**Method to create test Multiple Account records**/
    public static List<Account> createMultipleAccounts(Boolean doInsert,Integer totRecords){
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<=totRecords;i++){
            Account acc = new Account();
            acc.Name = 'Test Account '+i;
            accList.add(acc);
        }
        if(doInsert){
            insert accList;
        }
        return accList;
    }
    
    /**Method to create test Contact record**/
    public static Contact createContact(Boolean doInsert, Id accId){
        Contact conRec = new Contact();
        conRec.AccountId = accId;
        conRec.FirstName = 'FirstName';
        conRec.LastName = 'LastName';
        conRec.Email = 'FirstName@test.com';
        if(doInsert){
            insert conRec;
        }
        return conRec;
    }
    
    /**Method to create test Contact record along with Account record**/
    public static Contact createAccContact(Boolean doInsert){
        Account acc = createAccount(true);
        Contact conRec = new Contact();
        conRec.AccountId = acc.Id;
        conRec.FirstName = 'FirstName';
        conRec.LastName = 'LastName';
        conRec.Email = 'FirstName@test.com';
        if(doInsert){
            insert conRec;
        }
        return conRec;
    }
    
    /**Method to create multiple test Contact record along with Account record**/
    public static List<Contact> createMultipleContacts(Boolean doInsert,Integer totRecords){
        List<Contact> conList = new List<Contact>();
        Account acc = createAccount(true);
        for(Integer i=0;i<=totRecords;i++){
            Contact conRec = new Contact();
            conRec.AccountId = acc.Id;
            conRec.FirstName = 'FirstName'+i;
            conRec.LastName = 'LastName'+i;
            conRec.Email = 'FirstName@test.com'+i;
            conList.add(conRec);
        }
        if(doInsert){
            insert conList;
        }
        return conList;
    }
    
    /**Method to create test Opportunity record**/
    public static Opportunity createOpportunity(Boolean doInsert, Id accId){
        Opportunity oppty = new Opportunity(Name ='Test Opp1',
                            AccountID = accId,
                            StageName = 'Customer Won',
                            Amount = 300,
                            CloseDate = System.today()
                            );
        if(doInsert){
            insert oppty;
        }
        return oppty;
    }
    
        /**Method to create test Opportunity record along with Account**/
    public static Opportunity createAccOpportunity(Boolean doInsert){
        Account acc = createAccount(true);
        Opportunity oppty = new Opportunity(Name ='Test Opp1',
                            AccountID = acc.Id,
                            StageName = 'Customer Won',
                            Amount = 300,
                            CloseDate = System.today()
                            );
        if(doInsert){
            insert oppty;
        }
        return oppty;
    }
    
    /**Method to create test multiple Opportunity records along with Account**/
    public static List<Opportunity> createMultipleOpportunities(Boolean doInsert,Integer totRecords){
        Account acc = createAccount(true);
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0;i<=totRecords;i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp'+i;
            opp.AccountId = acc.Id;
            opp.StageName = 'Closed Won';
            opp.Amount = 300;
            opp.CloseDate = System.today();
            oppList.add(opp);
        }
        if(doInsert){
            insert oppList;
        }
        return oppList;
    }
    
     /**Method to create test Case record**/
    public static Case createCase(Boolean doInsert,String rTypeName){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(rTypeName).getRecordTypeId();
        Case csRec = new Case(Status ='New', Priority = 'Medium', Origin = 'Email',RecordTypeId=recordTypeId);
        if(doInsert){
            insert csRec ;
        }
        return csRec ;
    }      
    
    /**Method to create test Order Record **/
    public static Order createOrder(Boolean doInsert){
        Account acc = createAccount(true);
        Order ordRec = new Order();
        ordRec.Name = 'Test Order';
        ordRec.AccountId = acc.Id;
        ordRec.EffectiveDate = Date.Today();
        ordRec.Status = 'Draft';
        if(doInsert){
            insert ordRec;
        }
        return ordRec;
    }
    
    /**Method to create test EBS_Order__c Record **/
    public static EBS_Order__c createEBSOrder(Boolean doInsert){
        EBS_Order__c ebsRec = new EBS_Order__c();
        ebsRec.order_type__c = 'Sample Fullfillment';
        ebsRec.City__c ='Happy Town';
        if(doInsert){
            insert ebsRec;
        }
        return ebsRec;
    }
    
    /**Method to create test EBS_Order_Line__c Record **/
    public static EBS_Order_Line__c createEBSOrderLine(Boolean doInsert){
        EBS_Order__c ebsOrderRec = createEBSOrder(true);
        EBS_Order_Line__c ebsRec = new EBS_Order_Line__c();
        ebsRec.PRODUCT_ID__c = '123456';
        ebsRec.line_type__c = 'Standard (Line Invoicing)';
        ebsRec.Order__c = ebsOrderRec.Id;
        if(doInsert){
            insert ebsRec;
        }
        return ebsRec;
    }
}