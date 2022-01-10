public with sharing class caseCategory{

    public static void updateCategory(Set<ID> caseList){
        
        List<Case> lstUpdateCase = new List<Case>();
        
        List<Case> lstCaseQuery = [Select ID, Subject, Category__c From Case Where ID =: caseList];
        
        For(Case casUpd : lstCaseQuery){
        
            if(casUpd.Subject != null){
        
                String caseSubj = casUpd.Subject;
            
                If(caseSubj.containsIgnoreCase('CALENDAR')){casUpd.Category__c = 'CALENDAR';}
                else If(caseSubj.containsIgnoreCase('CANCEL')){casUpd.Category__c = 'CANCEL';}
                else If(caseSubj.containsIgnoreCase('CONFIRMATION')){casUpd.Category__c = 'CONFIRMATION';}
                else If(caseSubj.containsIgnoreCase('HOLD REQUEST')){casUpd.Category__c = 'HOLD REQUEST';}
                else If(caseSubj.containsIgnoreCase('INCORRECT ART')){casUpd.Category__c = 'INCORRECT ART';}
                else If(caseSubj.containsIgnoreCase('INCORRECT SHIPPING')){casUpd.Category__c = 'INCORRECT SHIPPING';}
                else If(caseSubj.containsIgnoreCase('ISSUES')){casUpd.Category__c = 'ISSUES';}
                else If(caseSubj.containsIgnoreCase('PLACE ORDER ')){casUpd.Category__c = 'PLACE ORDER ';}
                else If(caseSubj.containsIgnoreCase('QUESTION')){casUpd.Category__c = 'QUESTION';}
                else If(caseSubj.containsIgnoreCase('REPEAT ORDER')){casUpd.Category__c = 'REPEAT ORDER';}
                else If(caseSubj.containsIgnoreCase('REQUEST')){casUpd.Category__c = 'REQUEST';}
                else If(caseSubj.containsIgnoreCase('SAMPLES')){casUpd.Category__c = 'SAMPLES';}
                else If(caseSubj.containsIgnoreCase('TRACKING')){casUpd.Category__c = 'TRACKING';}
                else If(caseSubj.containsIgnoreCase('WEB')){casUpd.Category__c = 'WEB';}
                else If(caseSubj.containsIgnoreCase('PROOF REQUEST') || caseSubj.containsIgnoreCase('E-PROOF') ){casUpd.Category__c = 'PROOF REQUEST';}
                else If(caseSubj.containsIgnoreCase('ORDER STATUS') || caseSubj.containsIgnoreCase('MISSING ORDER ') ){casUpd.Category__c = 'ORDER STATUS';}
                else If(caseSubj.containsIgnoreCase('REMAKE') || caseSubj.containsIgnoreCase('REPLACEMENT') ){casUpd.Category__c = 'REMAKE';}
                else If(caseSubj.containsIgnoreCase('CHANGE') || caseSubj.containsIgnoreCase('REVISION') ){casUpd.Category__c = 'CHANGE';}
                else If(caseSubj.containsIgnoreCase('INVOICE') || caseSubj.containsIgnoreCase('BILLING') || caseSubj.containsIgnoreCase('ORDER RECEIPT') ){casUpd.Category__c = 'INVOICE';}
                else If(caseSubj.containsIgnoreCase('PRICING') || caseSubj.containsIgnoreCase('QUOTE') || caseSubj.containsIgnoreCase('PRODUCT') ){casUpd.Category__c = 'PRICING';}
                else If(caseSubj.containsIgnoreCase('CREDIT') || caseSubj.containsIgnoreCase('CLAIMS') || caseSubj.containsIgnoreCase('WRONG IMPRINT') || caseSubj.containsIgnoreCase('IMPRINT QUALITY') || caseSubj.containsIgnoreCase('RETURN') ){casUpd.Category__c = 'CREDIT';}
                else If(caseSubj.containsIgnoreCase('URGENT') || caseSubj.containsIgnoreCase('3RD REQUEST') || caseSubj.containsIgnoreCase('2ND REQUEST') || caseSubj.containsIgnoreCase('RUSH') || caseSubj.containsIgnoreCase('EXPEDITE') || caseSubj.containsIgnoreCase('HELP REQUEST') || caseSubj.containsIgnoreCase('SECOND REQUEST') || caseSubj.containsIgnoreCase('THIRD REQUEST') || caseSubj.containsIgnoreCase('FOLLOW UP') ){casUpd.Category__c = 'URGENT';}
                
                lstUpdateCase.add(casUpd);
            }
        }
        
        if(lstUpdateCase.size() > 0){
            update lstUpdateCase;
        }
    }
}