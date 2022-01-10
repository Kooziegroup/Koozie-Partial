public with sharing class avayaSearchPageController {
public Account acc{get;set;}
public List<Account> accountList {get;set;}
// create a list of strings to hold the conditions 
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 10;

public avayaSearchPageController(){
system.debug('==>AccountMultipleSearchWithPagenationCLS  is calling==>');
 acc = new Account();

 AccountList  = new List<Account>();
}

public void searchAcc(){
totalRecs = 0;
OffsetSize = 0;
if(accountList !=null && accountList.size()>0){
 accountList=null;
}
searchAccounts ();
conditions.clear();
}


public Void searchAccounts(){

System.debug('Total Records is ==>'+totalRecs);
System.debug('OffsetSize is ==>'+OffsetSize);

if(accountList != null && !accountList.isEmpty()){
  accountList.clear();
}
 String strQuery ='SELECT Id,Name,AccountNumber,CreatedDate,Phone,Website,Industry,AnnualRevenue From Account';
 /*
 if(acc.Created_From_Date__c !=null){
  String fromDate = acc.Created_From_Date__c+'';
  fromDate = fromDate.split(' ',0)[0]+'T00:00:00.000Z';
   conditions.add('CreatedDate >='+fromDate);
 }

if(acc.Created_To_Date__c !=null){
 String toDate = acc.Created_To_Date__c+'';
  toDate = toDate.split(' ',0)[0]+'T23:59:59.000Z';
   conditions.add('createdDate <='+toDate);
 }
*/
 if(acc.Name !=null && acc.Name !=''){
   conditions.add('Name Like \'%' +acc.Name +'%\' ');
 } else {
   conditions.add('Name Like \'%Bic%\' ');
 }
  if(acc.AccountNumber !=null && acc.AccountNumber !=''){
   conditions.add('AccountNumber Like\'%' +acc.AccountNumber +'%\' ');
 }

  

  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += '  AND ' + conditions[i];
  }
 if(totalRecs !=null && totalRecs ==0){
    List<Account> accTemp = Database.query(strQuery);
    totalRecs = (accTemp !=null &&accTemp.size()>0)?accTemp.size():0;
 }

 system.debug('strQuery ==>'+strQuery );
 // add sort and limits at the end  
  strQuery += ' ORDER BY Name  ASC, CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize';
  
  accountList  =Database.query(strQuery);
  
   

  //conditions.clear();
  //return accountList.size();
}

public void FirstPage()
{
OffsetSize = 0;
searchAccounts();
}
public void previous()
{
OffsetSize = (OffsetSize-LimitSize);
searchAccounts();
}
public void next()
{
OffsetSize = OffsetSize + LimitSize;
searchAccounts();
}
public void LastPage()
{
OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
searchAccounts();
}
public boolean getprev()
{

if(OffsetSize == 0){

return true;
}
else {

return false;
}
}
public boolean getnxt()
{
if((OffsetSize + LimitSize) > totalRecs){

return true;
}
else {

return false;
}
}


}