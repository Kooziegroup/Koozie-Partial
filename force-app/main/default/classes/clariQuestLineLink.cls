public class clariQuestLineLink{

    public static void cQLineLink(List<Clarification_Question__c> lstCQ){
    
        List<EBS_Order_Line__c> lstEOL = new List<EBS_Order_Line__c>();
        Set<String> lstEOLString = new Set<String>();
        Map<String, EBS_Order_Line__c> mpEOL = new Map<String, EBS_Order_Line__c>();
        List<Clarification_Question__c> lstCQUpdate = new List<Clarification_Question__c>();
    
        For(Clarification_Question__c cq : lstCQ){
            if(cq.EBS_Order_Line_ID__c != null){
                lstEOLString.add(cq.EBS_Order_Line_ID__c);
            }            
        }
        
        If(lstEOLString.size() > 0){
            
            For(EBS_Order_Line__c eol : 
                [Select ID, Order_Line_ID__c 
                From EBS_Order_Line__c 
                Where Order_Line_ID__c =: lstEOLString]){
                    mpEOL.put(eol.Order_Line_ID__c, eol);                
                }
          
            For(Clarification_Question__c cqLst : lstCQ){
                if(mpEOL.get(cqLst.EBS_Order_Line_ID__c) != null){
                    cqLst.EBS_Order_Line__c = mpEOL.get(cqLst.EBS_Order_Line_ID__c).ID;
                    lstCQUpdate.add(cqLst);
                }          
            }          
        }    
    }
}