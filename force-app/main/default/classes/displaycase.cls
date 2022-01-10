public class displaycase {
public string getcasetype{get;set;}
public  void displaycase ()
{
    
}
public list<case> caselst{get;set;}


public list<selectoption>getcasestatus()
{
    list<selectoption>selectopt=new list<selectoption>();
    selectopt.add(new selectoption('Choose Case Status','Choose Case Status'));    
    selectopt.add(new selectoption('New','New'));
    selectopt.add(new selectoption('Follow-Up Needed','Follow-Up Needed'));
    selectopt.add(new selectoption('Customer Response','Customer Response'));
    selectopt.add(new selectoption('Closed','Closed'));
    return selectopt;
}
public void displaycaselist()
{
    caselst=new list<case>();
   caselst=[SELECT CaseNumber,ClosedDate,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type, 
       Contact.Name, EBS_Order__r.EBS_Order_Number__c, RecordType.Name, ID, Account.Name, 
       Account.Parent.Name
       FROM Case 
       where status=:getcasetype
       And 
       (
           Account.Name like '4Imprint%'
           OR Account.Parent.Name like '4Imprint%'
       )
       Order By CreatedDate desc];
}
}