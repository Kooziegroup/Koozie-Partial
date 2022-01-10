public class displayOrder {
public string getOrdertype{get;set;}
public  void displayOrder ()
{
    
}
public list<EBS_Order__c> orderlst{get;set;}


public list<selectoption>getorderstatus()
{
    list<selectoption>selectopt=new list<selectoption>();
    selectopt.add(new selectoption('Choose Order Status','Choose Order Status'));  
    selectopt.add(new selectoption('Entered','Entered'));      
    selectopt.add(new selectoption('Booked','Booked'));
    selectopt.add(new selectoption('Cancelled','Cancelled'));
    selectopt.add(new selectoption('Closed','Closed'));

    return selectopt;
}

public void displayorderlist()
{
    orderlst=new list<EBS_Order__c>();
    
    orderlst=[SELECT Order_Header_Status__c ,Order_Line_Count__c, Order_Header_Total__c, Order_Header_Tax__c, 
       Tracking_Link__c, Order_Header_Charges__c, EBS_Order_Number__c, Effective_Date__c, Customer_PO__c,
       ID, Account_Name__r.Name 
       FROM EBS_Order__c
       where Order_Header_Status__c =:getOrdertype
       And Account_Name__r.Name like '4Imprint%'
       Order By CreatedDate desc
       limit 50];
}
}