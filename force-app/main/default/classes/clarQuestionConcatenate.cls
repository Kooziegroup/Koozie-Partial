public class clarQuestionConcatenate{

    @InvocableMethod(label='Concatenate Questions' description='Concatenates clarification questions based on case Ids received.' category='Clarification_Question__c')
    public static void grabQuests(List<string> CaseID){
    
        system.debug('CASEID####### ' + CaseID);
    
        For(string caseParse : CaseID){
        
            string clarText = '<html><body>';    
            string proofText = '<html><body>For your convenience you may approve your proof(s) on-line by clicking the link below.\n';  
            string proofURLText = '';
            string fullProofText = '';
            integer clarNum = 0;
            integer proofNum = 0;
            
            list<Clarification_Question__c> qc = new List<Clarification_Question__c>([Select id, Online_Proof_URL__c, Product_Number__c, Line_Number__c, Message_Text__c, Question_Type__c from Clarification_Question__c where case__c =:caseParse
                and status__c not in ('Closed', 'EBS Closed') Order by Question_Type__c , Line_Number__c]);
            
            For(Clarification_Question__c qc1 : qc){
            
                IF(qc1.Question_Type__c == 'Clarification'){
                    clarText += string.valueOf(qc1.Line_Number__c) + ')  ' + qc1.Message_Text__c + '\n';
                    clarNum +=1;
                }
                
                IF(qc1.Question_Type__c == 'Proof'){
                    proofText += string.valueOf(qc1.Line_Number__c) + ')  ' + qc1.Message_Text__c + '\n';
                    
                    proofURLText += 'Line Number: ' + string.valueOf(qc1.Line_Number__c) +  'Product Number: ' + qc1.Product_Number__c + '\n';
                    proofURLText += 'Proof On-Line: ' + qc1.Online_Proof_URL__c + '\n';
                    
                    proofNum +=1;
                }                
                
            }
            
            clarText += '</body></html>';
            proofText += '</body></html>';
            
            
            Case c = new Case(id=caseparse);
            
            if(clarNum > 0){
                c.Clarification_Description__c = clarText;
                update c;
            }
            
            if(proofNum  > 0){
                fullProofText += proofText + '\n';
                fullProofText += proofURLText;
                
                c.Proof_Description__c = fullProofText;
                update c;
            }            
            
        }
    }
}