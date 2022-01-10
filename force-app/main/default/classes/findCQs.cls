public class findCQs {

    public List<Clarification_Question__c > CQ;
    public List<Clarification_Question__c > parseCQ;
    public List<Clarification_Question__c > CQc;
    public List<Clarification_Question__c > parseCQc;   
    public List<Clarification_Question__c > NQc;
    public List<Clarification_Question__c > parseNQc;       
    public case caseID {get;set;}
    
    public void setCaseID(Case c){
        caseID = c;
        findCQs();
    }     

    public void findCQs () {
    
        System.Debug('ID**** ' + caseID);
        Case newCase = caseID;
        ID caseString = newCase.ID;

        List<String> lineNum = new List<String>();
        Map<String, String> mpLines = new Map<String,String>();

        CQ = new  List<Clarification_Question__c>();

        parseCQ= [select Message_Text__c, Product_Number__c, Online_Proof_URL__c, Line_Number__c, LastModifiedDate 
        From Clarification_Question__c
        Where Question_Type__c = 'Proof'
        AND status__c != 'Closed'
        And Case__c =: caseString 
        order by Line_Number__c, LastModifiedDate
        ];

        For(Clarification_Question__c cqRecord : parseCQ){
            if((!lineNum.contains(cqRecord.Line_Number__c))){
                CQ.add(cqRecord);
                lineNum.add(cqRecord.Line_Number__c);
            }
        }        
    }
    
    public void findCQcs () {
    
        Case newCase = caseID;
        ID caseString = newCase.ID;

        List<String> lineNum = new List<String>();
        Map<String, String> mpLines = new Map<String,String>();

        CQc = new  List<Clarification_Question__c>();

        parseCQc= [select Message_Text__c, Product_Number__c, Line_Number__c, LastModifiedDate,  SEQ__c
        From Clarification_Question__c
        Where Question_Type__c = 'Clarification'
        AND status__c != 'Closed'
        And Case__c =: caseString 
        order by SEQ__c, Line_Number__c, LastModifiedDate
        ];

        For(Clarification_Question__c cqRecord : parseCQc){
            //if((!lineNum.contains(cqRecord.Line_Number__c))){
                CQc.add(cqRecord);
                //lineNum.add(cqRecord.Line_Number__c);
            //}
        }        
    }   

    public void findNQcs () {
    
        Case newCase = caseID;
        ID caseString = newCase.ID;

        List<String> lineNum = new List<String>();
        Map<String, String> mpLines = new Map<String,String>();

        NQc = new  List<Clarification_Question__c>();

        parseNQc= [select Message_Text__c, Product_Number__c, Line_Number__c, LastModifiedDate,  SEQ__c
        From Clarification_Question__c
        Where Question_Type__c = 'Notification'
        AND status__c != 'Closed'
        And Case__c =: caseString 
        order by SEQ__c, Line_Number__c, LastModifiedDate
        ];

        For(Clarification_Question__c cqRecord : parseNQc){
            //if((!lineNum.contains(cqRecord.Line_Number__c))){
                NQc.add(cqRecord);
                //lineNum.add(cqRecord.Line_Number__c);
            //}
        }        
    }    

    public List<Clarification_Question__c > getCQ() {
        findCQs();
        return CQ;
    }
    
    public List<Clarification_Question__c > getCQc() {
        findCQcs();
        return CQc;
    }   

    public List<Clarification_Question__c > getNQc() {
        findNQcs();
        return NQc;
    }       
    
}