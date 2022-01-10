//Global Contact Trigger
trigger EBSResponsibilityCreate on Responsibility_Type__c (after Insert, after update) { 

    //List for contacts to create in EBS
    List<Contact> contEBSInsert = new List<Contact>();
    List<ID> lstInsertId = new List<ID>(); 

    //Trigger if after insert
    if(trigger.isAfter && trigger.isInsert){ 
        
        //Loop through list of contacts
        For(Responsibility_Type__c insCont : trigger.new){

            Contact con = [Select lastname from contact where ID =: insCont.Contact__c limit 1];
        
            String lName = con.LastName;
            
            if(//insCont.lastmodifiedbyid != '0051U000001M0nl' && (!lName.contains('@'))
            1<2){
                //Make sure accounts not updated twice
                lstInsertId.add(insCont.Id);
                
                //Check Recursive
                If(!checkRecursive.SetOfIDs.contains(insCont.Id)){
                                    
                    //If contact is integration type then add to contact list
                    EBSResponsibilityDML.getJsonString(insCont.Id, 'CREATE');                
                }
            } 
        }
    } 
    //Trigger if after update
    else if(trigger.isAfter && trigger.isUpdate && !System.isFuture()){
         
        //Loop through list of contacts
        For(Responsibility_Type__c insCont : trigger.new){

            Responsibility_Type__c cont = trigger.OldMap.get(insCont.ID);
            Contact con = [Select lastname from contact where ID =: insCont.Contact__c limit 1];
        
            String lName = con.LastName;        

            boolean contFieldsChanged = (cont.Email__c == insCont.Email__c && cont.Other_Email__c == insCont.Other_Email__c && 
                cont.Phone__c == insCont.Phone__c && cont.Other_Phone__c == insCont.Other_Phone__c && cont.Fax__c == insCont.Fax__c &&
                insCont.Primary_Responsibility_Flag__c == cont.Primary_Responsibility_Flag__c &&
                insCont.Responsibility_Type__c == cont.Responsibility_Type__c && 
                insCont.Contact_Status__c == cont.Contact_Status__c ) ? false : true;

            //Make sure 'Verified' checkbox doesn't cause recursive behaviour
            if(insCont.lastmodifiedbyid != '0051U000001M0nl' && contFieldsChanged && (!lName.contains('@'))){
                //Check Recursive
                If(!checkRecursive.SetOfIDs.contains(insCont.Id)){
                    
                    if(insCont.Contact_ID__c != null){
                        //If contact is integration type then add to contact list
                        EBSResponsibilityDML.getJsonString(insCont.Id, 'UPDATE');    
                    } else {
                        //If contact is integration type then add to contact list
                        EBSResponsibilityDML.getJsonString(insCont.Id, 'CREATE');   

                    }            
                }                   
            }
        }
    }
}