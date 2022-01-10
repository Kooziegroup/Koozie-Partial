public class findVFs {

    public List<Virtual_Form_Item__c > VF;
    public List<Virtual_Form_Item__c > parseCQ;
    public Request_Form__c formID {get;set;}
    
    public void setformID(Request_Form__c rf){
        formID = rf;
        findVFs();
    }     

    public void findVFs () {
    
        System.Debug('ID**** ' + formID );
        Request_Form__c newRF = formID;
        ID formID = newRF.ID;

        List<String> lineNum = new List<String>();
        Map<String, String> mpLines = new Map<String,String>();

        VF = new  List<Virtual_Form_Item__c>();

        parseCQ= [select Item_Number__c, Item_Color__c, Imprint_Color__c, Art_Instructions__c, 
        LastModifiedDate, Any_Additional_Instructions__c, Previous_Virtual_Proof_URL__c
        From Virtual_Form_Item__c
        Where Request_Form__c =: formID 
        order by Item_Number__c
        ];

        For(Virtual_Form_Item__c cqRecord : parseCQ){
            //if((!lineNum.contains(cqRecord.Item_Number__c))){
                VF.add(cqRecord);
                lineNum.add(cqRecord.Item_Number__c);
            //}
        }        
    }

    public List<Virtual_Form_Item__c > getVF() {
        findVFs();
        return VF;
    }
    
}