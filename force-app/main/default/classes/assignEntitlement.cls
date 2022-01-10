public class assignEntitlement {

    public static void defineEntitlement(List<Case> lstCase){       
        List<Case> cUpd = new List<Case>();

        Set<Id> acctIds = new Set<Id>();
        
        for (Case c : lstCase) {
            acctIds.add(c.AccountId);
            
            system.debug('AccountID is: ' + c.AccountId);
        }
        
        if(acctIds.size() > 0){ 
            List <Entitlement> entls = [Select StartDate, Id, EndDate, 
            AccountId, AssetId
            From Entitlement
            Where AccountId =: acctIds And EndDate > Today];
            
            system.debug('List size: ' + entls);

            if(entls.isEmpty()==false){
                for(Case c : lstCase){
                    Case cNew = new Case(id=c.id);
                    //Check Recursive
                    If(!checkRecursive.SetOfIDs.contains(c.Id)){             
                        if(c.EntitlementId == null && c.AccountId != null){
                            for(Entitlement e:entls){
                                if(e.AccountId==c.AccountId){                            

                                    cNew.EntitlementId = e.Id;
                                }
                            } 
                        }
                        
                        cUpd.add(cNew);
                    }                
                } 
            }

            if(cUpd.size() > 0){
                
                //Try to update case with entitlement
                try{
                    update cUpd;
                } catch (DmlException e){
                    
                    //Add DML Error Text to SF
                    Apex_Errors__c att = new Apex_Errors__c(Error_Message__c  = e.getMessage(), String__c = 'Error in DefaultEntitlement Trigger. Case is: ' + cUpd, 
                    Type__c = 'Error ');  
                    
                    insert att; 

                }
            }
        }       
        
    }
}