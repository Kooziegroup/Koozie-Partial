@isTest
public class UpdateEmailOnCase_TestClass {
       @isTest
       public static void accountCustomerCategoryEqualsHotel() {
           Account acc = new Account();
           acc.Name = 'test';
           acc.Customer_Account_Number__c = '12345';
           acc.Customer_Category__c = 'Hotel';
           
           
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           insert acc;
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Hotel';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

       @isTest
       public static void accountLogoEqualsCalendarCoop() {
           Account acc = new Account();
           acc.Name = 'test';
           acc.Customer_Account_Number__c = '12345';
           acc.Logo__c = 'Calendar Coop';
           
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           insert acc; 
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 804 Facilis Brand Addition';
           act.From_Email__c = 'csinfo@calndercs.com';
           act.EBS_Num__c = '12345';
           act.Logo__c = 'Calendar Coop';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.Customer_To_Email__c = act.From_Email__c;
           css.Case_Reason_Type__c = 'Email'; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

    @isTest
    public static void accountCustomerAccountNumberEquals33381() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.Customer_Account_Number__c = '33381';
        
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert acc;
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'proformabcsteam@kooziegroup.com';
        act.EBS_Num__c = '33381';
        insert act;
        
        
        Case css = new Case();
       /* css.AccountId = acc.Id;
       css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
       css.Customer_To_Email__c = act.From_Email__c;
       css.Case_Reason_Type__c = 'Email'; */
       css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
       css.EBS_Account_Number__c = '33381';
       css.Status = 'New';
       css.Origin = 'ASI Rating';
       insert css;
    }

    @isTest
    public static void accountCustomerCategoryEqualsBookstore() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.Customer_Account_Number__c = '12345';
        acc.Customer_Category__c = 'Bookstore';
        
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert acc;
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.EBS_Num__c = '12345';
        act.From_Email__c = 'anchorwallace@anchorwallace.com';
        act.Customer_Category__c = 'Bookstore';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.Customer_To_Email__c = act.From_Email__c;
        css.Case_Reason_Type__c = 'Email' */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c = '12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }

    @isTest
    public static void accountRoutingOverrideEqualsCalendarDedicated() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.Customer_Account_Number__c = '12345';
        acc.Routing_Override__c = 'Calendar Dedicated';
        
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert acc;
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.EBS_Num__c = '12345';
        act.From_Email__c = 'coopspecialtyteam@kooziegroup.com';
        act.Account_Queue__c = 'Calendar Dedicated';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.Customer_To_Email__c = act.From_Email__c;
        css.Case_Reason_Type__c = 'Email'; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }

    @isTest
    public static void accountCustomerAccountNumberEqualsActEbsNumberAndCaseEbsAccountNumber() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.Customer_Account_Number__c = '12345';
        
        
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert acc;
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'test@test.com';
        act.EBS_Num__c = '12345';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.Customer_To_Email__c = act.From_Email__c;
        css.Case_Reason_Type__c = 'Email'; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }
    @isTest
    public static void caseEbsAccountNumberDoesNotExistsInActAndAccount() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Customer_Account_Number__c = ' ';
        insert acc;

        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'HG Custom';
        act.From_Email__c = 'customerservice@kooziegroup.com';
        act.EBS_Num__c = '';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.Customer_To_Email__c = act.From_Email__c;
        css.Case_Reason_Type__c = 'Email'; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c = '12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }
    @isTest
       public static void accountCustomerCategoryEqualsChurch() {
           Account acc = new Account();
           acc.Name = 'test';
           acc.Customer_Account_Number__c = '12345';
           acc.Customer_Category__c = 'Church';
           
           
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           insert acc;
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Church';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }
    @isTest
       public static void accountCustomerCategoryEqualsCasino() {
           Account acc = new Account();
           acc.Name = 'test';
           acc.Customer_Account_Number__c = '12345';
           acc.Customer_Category__c = 'Casino';
           
           
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           insert acc;
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Casino';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

    @isTest
       public static void parentAccountCustomerCategoryEqualsCasino() {

            Account parentRecord = new Account();
            parentRecord.Name = 'test';
            parentRecord.Customer_Account_Number__c = '54321';
            parentRecord.Customer_Category__c = 'Casino';
            insert parentRecord;

           Account childRecord = new Account();
           childRecord.Name = 'test';
           childRecord.Customer_Account_Number__c = '12345';
           childRecord.EBS_Parent_ID__c = '54321';
           childRecord.ParentId = parentRecord.Id;
           insert childRecord;
           

           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Casino';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

    @isTest
       public static void parentAccountCustomerCategoryEqualsHotel() {

            Account parentRecord = new Account();
            parentRecord.Name = 'test';
            parentRecord.Customer_Account_Number__c = '54321';
            parentRecord.Customer_Category__c = 'Hotel';
            insert parentRecord;

           Account childRecord = new Account();
           childRecord.Name = 'test';
           childRecord.Customer_Account_Number__c = '12345';
           childRecord.EBS_Parent_ID__c = '54321';
           childRecord.ParentId = parentRecord.Id;
           insert childRecord;
           

           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Casino';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

    @isTest
       public static void parentAccountCustomerCategoryEqualsBookstore() {

            Account parentRecord = new Account();
            parentRecord.Name = 'test';
            parentRecord.Customer_Account_Number__c = '54321';
            parentRecord.Customer_Category__c = 'Bookstore';
            insert parentRecord;

           Account childRecord = new Account();
           childRecord.Name = 'test';
           childRecord.Customer_Account_Number__c = '12345';
           childRecord.EBS_Parent_ID__c = '54321';
           childRecord.ParentId = parentRecord.Id;
           insert childRecord;
           

           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Casino';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

    @isTest
       public static void parentAccountCustomerCategoryEqualsChurch() {

            Account parentRecord = new Account();
            parentRecord.Name = 'test';
            parentRecord.Customer_Account_Number__c = '54321';
            parentRecord.Customer_Category__c = 'Church';
            insert parentRecord;

           Account childRecord = new Account();
           childRecord.Name = 'test';
           childRecord.Customer_Account_Number__c = '12345';
           childRecord.EBS_Parent_ID__c = '54321';
           childRecord.ParentId = parentRecord.Id;
           insert childRecord;
           

           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
           
           
           Account_Clarification_Team__c act = new Account_Clarification_Team__c();
           act.Name = 'Elite 801 Proforma';
           act.From_Email__c = 'cshotel@kooziegroup.com';
           act.EBS_Num__c = '12345';
           act.Customer_Category__c = 'Casino';
           insert act;
           
           
           Case css = new Case();
           /* css.AccountId = acc.Id;
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
           css.Case_Reason_Type__c = 'Email';
           css.Customer_To_Email__c = act.From_Email__c; */
           css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
           css.EBS_Account_Number__c ='12345';
           css.Status = 'New';
           css.Origin = 'ASI Rating';
           insert css;
    }

    @isTest
    public static void parentLogoEqualsCalendarCoop() {

         Account parentRecord = new Account();
         parentRecord.Name = 'test';
         parentRecord.Customer_Account_Number__c = '54321';
         parentRecord.Logo__c = 'Calendar Coop';
         insert parentRecord;

        Account childRecord = new Account();
        childRecord.Name = 'test';
        childRecord.Customer_Account_Number__c = '12345';
        childRecord.EBS_Parent_ID__c = '54321';
        childRecord.ParentId = parentRecord.Id;
        insert childRecord;
        

        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '12345';
        act.Customer_Category__c = 'Casino';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        css.Case_Reason_Type__c = 'Email';
        css.Customer_To_Email__c = act.From_Email__c; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }

    @isTest
    public static void parentRoutingOverrideEqualsCalendarDedicated() {

         Account parentRecord = new Account();
         parentRecord.Name = 'test';
         parentRecord.Customer_Account_Number__c = '54321';
         parentRecord.Routing_Override__c = 'Calendar Dedicated';
         insert parentRecord;

        Account childRecord = new Account();
        childRecord.Name = 'test';
        childRecord.Customer_Account_Number__c = '12345';
        childRecord.EBS_Parent_ID__c = '54321';
        childRecord.ParentId = parentRecord.Id;
        insert childRecord;
        

        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '12345';
        act.Customer_Category__c = 'Casino';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        css.Case_Reason_Type__c = 'Email';
        css.Customer_To_Email__c = act.From_Email__c; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'Email';
        insert css;
    }
    
    @isTest
    public static void parentAccountCustomerAccountNumberEquals33381() {

         Account parentRecord = new Account();
         parentRecord.Name = 'test';
         parentRecord.Customer_Account_Number__c = '33381';
         insert parentRecord;

        Account childRecord = new Account();
        childRecord.Name = 'test';
        childRecord.Customer_Account_Number__c = '12345';
        childRecord.EBS_Parent_ID__c = '33381';
        childRecord.ParentId = parentRecord.Id;
        insert childRecord;
        

        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '12345';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        css.Case_Reason_Type__c = 'Email';
        css.Customer_To_Email__c = act.From_Email__c; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }

    @isTest
    public static void parentAccountCustomerAccountNumberEqualsActEbsNumber() {

         Account parentRecord = new Account();
         parentRecord.Name = 'test';
         parentRecord.Customer_Account_Number__c = '54321';
         insert parentRecord;

        Account childRecord = new Account();
        childRecord.Name = 'test';
        childRecord.Customer_Account_Number__c = '12345';
        childRecord.EBS_Parent_ID__c = '54321';
        childRecord.ParentId = parentRecord.Id;
        insert childRecord;
        

        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '54321';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        css.Case_Reason_Type__c = 'Email';
        css.Customer_To_Email__c = act.From_Email__c; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Clarification').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }
    @isTest
    public static void parentAccountCustomerAccountNumberEqualsActEbsNumberWhenRecordTypeIsDelayedOrder() {

         Account parentRecord = new Account();
         parentRecord.Name = 'test';
         parentRecord.Customer_Account_Number__c = '54321';
         insert parentRecord;

        Account childRecord = new Account();
        childRecord.Name = 'test';
        childRecord.Customer_Account_Number__c = '12345';
        childRecord.EBS_Parent_ID__c = '54321';
        childRecord.ParentId = parentRecord.Id;
        insert childRecord;
        

        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        
        Account_Clarification_Team__c act = new Account_Clarification_Team__c();
        act.Name = 'Elite 801 Proforma';
        act.From_Email__c = 'cshotel@kooziegroup.com';
        act.EBS_Num__c = '54321';
        insert act;
        
        
        Case css = new Case();
        /* css.AccountId = acc.Id;
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        css.Case_Reason_Type__c = 'Email';
        css.Customer_To_Email__c = act.From_Email__c; */
        css.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Delayed Order').getRecordTypeId();
        css.EBS_Account_Number__c ='12345';
        css.Status = 'New';
        css.Origin = 'ASI Rating';
        insert css;
    }
}