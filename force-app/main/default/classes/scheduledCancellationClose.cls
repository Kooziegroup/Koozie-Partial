//Script to closed cases that have move to cancellation
global class scheduledCancellationClose implements Schedulable {

    public void execute(SchedulableContext SC) {
        pullPreCancellation();
        //pullCancellation();
        
    }

    public static void pullCancellation(){
    /*
        List<String> lstCaseUnique = new List<String>();   
        List<ID> lstProofCaseID = new List<ID>();
        List<ID> lstClariCaseID = new List<ID>();
        List<Case> lstCaseUpdate = new List<Case>();
        List<CLARIFICATION_QUESTION__C> lstCQUpdate = new List<CLARIFICATION_QUESTION__C>();
        
        List<CLARIFICATION_QUESTION__C> caseExtract = new List<CLARIFICATION_QUESTION__C>
            ([Select ID, CASE__C, RECORDTYPE.NAME, CASE__r.OWNER.NAME, STATUS__c, 
                QUESTION_TYPE__C, PROOF_DISPOSITION__C, RESPONSE__C, 
                CLARIFICATION_CANCELLATION__C
                FROM CLARIFICATION_QUESTION__C
                WHERE CASE__r.RECORDTYPE.NAME = 'Clarification'
                AND CASE__r.STATUS != 'Closed' 
                AND CASE__r.STATUS != 'Merged - Duplicate'
                AND STATUS__C != 'CLOSED' 
                AND STATUS__C != 'EBS CLOSED'                
                AND CASE__r.CURRENT_PROCESS__C = 'Cancellation'
                LIMIT 20]);         
        
            
        If(caseExtract.size() > 0){
        
            For(CLARIFICATION_QUESTION__C clarQID : caseExtract){
            
                IF(clarQID.Question_Type__c == 'Proof' && (!lstProofCaseID.contains(clarQID.Case__c))){
                    lstProofCaseID.add(clarQID.Case__c);
                } else If(clarQID.Question_Type__c == 'Clarification' && (!lstClariCaseID.contains(clarQID.Case__c))){
                    lstClariCaseID.add(clarQID.Case__c);
                }
                
                //To Update Case Status to Closed
                if(!lstCaseUnique.contains(clarQID.Case__c)){   
                    Case caseUpdate = new Case(ID=clarQID.Case__c);
                    caseUpdate.Status = 'Closed';
                    lstCaseUpdate.add(caseUpdate); 
                    lstCaseUnique.add(clarQID.Case__c);
                }
            }
        
            //Send emails
            if(lstProofCaseID.size() > 0){sendClariEmail.sendEmail(lstProofCaseID, 'Proof');}
            if(lstClariCaseID.size() > 0){sendClariEmail.sendEmail(lstClariCaseID, 'Clarification');}
            
            For(CLARIFICATION_QUESTION__C caseLoop : caseExtract){  

                if(caseLoop.QUESTION_TYPE__C == 'Proof'){
                    caseLoop.PROOF_DISPOSITION__C = 'Proof_Not_Approved';
                }
                
                caseLoop.STATUS__c = 'Closed';
                caseLoop.RESPONSE__C = 'Cancel = Lack of response to Clar_Proof';
                caseLoop.CLARIFICATION_CANCELLATION__C = true;
                lstCQUpdate.add(caseLoop);
            }
        }    
    
        if(lstCQUpdate.size() >0){
            try{
                Update lstCQUpdate;
                Update lstCaseUpdate;
            } catch (DMLException e){
                system.debug(e.getMessage());
            }            
        }    
    */
    }
    
    public static void pullPreCancellation(){
    
        List<String> lstCaseUnique = new List<String>();   
        List<ID> lstProofCaseID = new List<ID>();
        List<ID> lstClariCaseID = new List<ID>();
        List<Case> lstCaseUpdate = new List<Case>();
        
        List<CLARIFICATION_QUESTION__C> caseExtract = new List<CLARIFICATION_QUESTION__C>
            ([Select ID, CASE__C, RECORDTYPE.NAME, CASE__r.OWNER.NAME, STATUS__c, 
                QUESTION_TYPE__C, PROOF_DISPOSITION__C, RESPONSE__C, 
                CLARIFICATION_CANCELLATION__C
                FROM CLARIFICATION_QUESTION__C
                WHERE CASE__r.RECORDTYPE.NAME = 'Clarification'
                AND CASE__r.STATUS != 'Closed' 
                AND CASE__r.STATUS != 'Merged - Duplicate'
                AND STATUS__C != 'CLOSED' 
                AND STATUS__C != 'EBS CLOSED'                
                AND CASE__r.CURRENT_PROCESS__C = 'Cancellation Notice'
                AND CASE__r.CANCELLATION_SENT__C = False
                LIMIT 20]);         
        
            
        If(caseExtract.size() > 0){
        
            For(CLARIFICATION_QUESTION__C clarQID : caseExtract){
            
                IF(clarQID.Question_Type__c == 'Proof' && (!lstProofCaseID.contains(clarQID.Case__c))){
                    lstProofCaseID.add(clarQID.Case__c);
                } else If(clarQID.Question_Type__c == 'Clarification' && (!lstClariCaseID.contains(clarQID.Case__c))){
                    lstClariCaseID.add(clarQID.Case__c);
                }
                
                //To Update Case Status to Closed
                if(!lstCaseUnique.contains(clarQID.Case__c)){   
                    Case caseUpdate = new Case(ID=clarQID.Case__c);
                    caseUpdate.Cancellation_Sent__c = True;
                    caseUpdate.In_Cadence__c = True;
                    lstCaseUpdate.add(caseUpdate); 
                    lstCaseUnique.add(clarQID.Case__c);
                }
            }
            
            Update lstCaseUpdate;
        
            //Send emails
            if(lstProofCaseID.size() > 0){sendClariEmail.sendEmail(lstProofCaseID, 'Proof');}
            if(lstClariCaseID.size() > 0){sendClariEmail.sendEmail(lstClariCaseID, 'Clarification');}
            
        }    
    
        if(lstCaseUpdate.size() >0){
            try{
                Update lstCaseUpdate;
            } catch (DMLException e){
                system.debug(e.getMessage());
            }            
        }     
    }    
}