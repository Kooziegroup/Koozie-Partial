@isTest(seealldata = true)
private class testProofNotify {

    static testMethod void proofNotifyTest() {        
  
        
        test.starttest();
        List<string> CaseId = new List<string>();
        
        RecordType r1 = [Select ID From RecordType where Name = 'ProofQuestion'];
        
        Account a = new Account(Name = 'AccountTest', Customer_Account_Number__c= '123456789');
        insert a;
        
        Entitlement ent = new Entitlement(Name='Testing', AccountId=a.Id, 
        StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        insert ent;        
        
        Contact cont = new Contact();
        cont.firstname = 'Jack';
        cont.lastname = 'Frost';  
        cont.Email = 'hello@goodbye.com';
        cont.AccountId = a.Id;            
        insert cont;
         
        Case cas = new Case(ContactID = cont.id, 
        Status = 'New', Origin = 'Phone', Clarification_Description__c ='Hello Dolly', EBS_Account_Number__c = '123456789',
        Clarification_to_email__c ='hello@goodbye.com', Proof_Description__c ='Hello Dolly', 
        Proof_to_email__c ='hello@goodbye.com', Current_Process__c = 'Initial Email',
        suppliedEmail = 'hello@goodbye.com', clarification_cc_email__c = 'to@me.com', proof_CC_email__c= 'tom@me.com');
        insert cas;
        
                
        Clarification_Question__c cqProof1= new Clarification_Question__c(Case__c = cas.Id, RecordTypeId=r1.Id, Proof_Disposition__c = 'Proof_Approved', 
        Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '1', Question_Type__c='Proof', case_Contact__c = cont.Id);
        insert cqProof1;        
        
        Clarification_Question__c cqProof2 = new Clarification_Question__c(Case__c = cas.Id, RecordTypeId=r1.ID, Proof_Disposition__c = 'Proof_Approved_W_Changes',
        Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '2', Question_Type__c='Proof', case_Contact__c = cont.Id);
        insert cqProof2 ;
        
        Clarification_Question__c cqProof3 = new Clarification_Question__c(Case__c = cas.Id, RecordTypeId=r1.ID, Proof_Disposition__c = 'Proof_Not_Approved',
        Status__c = 'Open', Message_Text__c = 'Welcome to the party',Line_number__c = '3', Question_Type__c='Proof', case_Contact__c = cont.Id);
        insert cqProof3;    
        
        List<Clarification_Question__c> cq = new List<Clarification_Question__c>(); 
        List<String> cqId = new list<String>{cqProof1.Id, cqProof2.Id, cqProof3.Id};   
        
        cqProof1.Status__c = 'EBS Closed';
        cqProof1.Response__c = 'Response'; 
        cq.add(cqProof1);
        
        cqProof2.Status__c = 'EBS Closed';
        cqProof2.Response__c = 'Response';
        cq.add(cqProof2);
        
        cqProof3.Status__c = 'EBS Closed';
        cqProof3.Response__c = 'Response';  
        cq.add(cqProof3);    
        
        update cq; 
        
        sendGeneralEmail.sendGeneralEmail(cqId);

        test.stopTest();
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////