public with sharing class cqGetUniqueCaseID {
    public static Map<Case, List<Clarification_Question__c>> getUniqueCaseID(List<ID> idList) {
        list<ID> uniqueList = new list<ID>();

        Map<Case, List<Clarification_Question__c>> caseDetails = new Map<Case, List<Clarification_Question__c>>();

        For(ID lstID : idList){
            IF(!uniqueList.contains(lstID)){ 
                uniqueList.add(lstID);
            }
        }

    caseDetails = getMapCaseQuestions(uniqueList);

    return caseDetails;

    }

    private static Map<Case, List<Clarification_Question__c>> getMapCaseQuestions(List<ID> caseID){

        Map<Case, List<Clarification_Question__c>> caseDetails = new Map<Case, List<Clarification_Question__c>>();

        List<Case> caseRecs = new List<Case>([Select id, status, clarification_description__c, proof_description__c from Case where ID =: caseID]);
        List<Clarification_Question__c> cQuestions = new List<Clarification_Question__c>([Select id, Case__c, Online_Proof_URL__c, Status__c, Product_Number__c, Line_Number__c, Message_Text__c, Question_Type__c from Clarification_Question__c where case__c =:caseID]);

        For(Case caseLoop : caseRecs){

            List<Clarification_Question__c> clariQLoop = new List<Clarification_Question__c>();

            For(Clarification_Question__c cq : cQuestions){

                If(cq.case__c == caseLoop.ID){
                    clariQLoop.add(cq);
                }
            }

            caseDetails.put(caseLoop, clariQLoop);            

        }

        system.debug(caseDetails);
        return caseDetails;
    }
}