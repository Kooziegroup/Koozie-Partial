global class scheduledCaseHistory implements Schedulable {
    public void execute(SchedulableContext SC) {
        pullCaseHistory();
    }

    public void pullCaseHistory(){

        List<Case_History_Extract__c> lstCHE = new List<Case_History_Extract__c>();
        DateTime dtLastThirty = system.now();
        system.debug(dtLastThirty);
        dtLastThirty = dtLastThirty.addMinutes(-60);
        system.debug(dtLastThirty);

        List<CaseHistory> chExtract = new List<CaseHistory>
            ([Select CASEID, CREATEDBYID, CREATEDDATE, DATATYPE, 
            FIELD, ID, ISDELETED, NEWVALUE, OLDVALUE, Case.OwnerID, 
            Case.Owner.Name
            FROM CaseHistory
            WHERE CREATEDDATE >= : dtLastThirty
            AND FIELD = 'Status']);

        If(chExtract.size() > 0){
            For(CaseHistory cheLoop : chExtract){
                string ownerID = '';
                
                if(string.valueOf(cheLoop.CREATEDBYID).left(3) == '005'){
                    ownerID = cheLoop.CREATEDBYID;
                }
                
                Case_History_Extract__c CHE = new Case_History_Extract__c();
                CHE.Case__c = cheLoop.CASEID;
                CHE.Case_History_ID__c = cheLoop.ID;
                CHE.CreatedBy__c = cheLoop.CREATEDBYID;
                CHE.Created_Date__c = cheLoop.CREATEDDATE;
                CHE.Field__c = cheLoop.FIELD;
                CHE.OwnerID__c = ownerID;
                CHE.Owner_Name__c = cheLoop.Case.Owner.Name;
                CHE.New_Value__c = string.valueOf(cheLoop.NEWVALUE);
                CHE.Old_Value__c = string.valueOf(cheLoop.OLDVALUE);
    
                lstCHE.add(CHE);
            }
        }

        if(lstCHE.size() >0){
            try{
                upsert lstCHE Case_History_ID__c;
            } catch (DMLException e){
                system.debug(e.getMessage());
            }            
        }
        
    }
}