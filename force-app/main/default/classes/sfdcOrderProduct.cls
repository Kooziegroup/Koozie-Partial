///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Batch class used to grab orders modified in last 2 hours
global class sfdcOrderProduct implements Database.Batchable<sObject>{

    //Method used to get querylocator
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        //Variables used to create dynamic SOQL
        DateTime ordUpdateDate = system.Now().addHours(-2);
        //DateTime ordUpdateDate = todDate.addHours(-2);  
        String sOQLQuery = 'select id, product_id__c from ebs_order_line__c where Order__r.order_type__c = \'Sample Fullfillment\' ';
        sOQLQuery += ' and line_type__c = \'Standard (Line Invoicing)\' and product_id__c != null and createddate >=: ordUpdateDate';
        system.debug(sOQLQuery);
        
        //Return queryLocator
        return Database.getQueryLocator(sOQLQuery);        
    }
    
    //Execute the batch
    global void execute(Database.Batchablecontext BC, List<ebs_order_line__c > scope){
        
        //Set up global variables
        Set<String> prodId = new Set<String>();
        List<ebs_order_line__c> eOLineUpd = new List<ebs_order_line__c>();
        Map<String, Product2> mpProd  = new Map<String, Product2>();
        
        //Get list of product IDs
        For(ebs_order_line__c eLine : scope){
            prodID.add(eLine.product_id__c);            
        }
        
        //Loop through products that contain product IDs
        For(Product2 p2 : [Select ID, Product_ID__c, Name From Product2 Where Product_ID__c =: prodID]){
            mpProd.put(p2.Product_ID__c, p2);
        }
        
        //Update order line if product found
        if(mpProd.size() > 0){        
        
            //Loop through Order Line records 
            For(ebs_order_line__c eLine : scope){
                Product2 p2ID = (mpProd.get(eLine.product_id__c) != null) ? mpProd.get(eLine.product_id__c) : null;
                
                //Add order line to list
                if(p2ID != null) {
                    eLine.Product__c = p2ID.ID;
                    eline.Product_Name_Marketing__c = p2ID.Name;
                    eOLineUpd.add(eLine);
                }
            }
        }
        
        //Update list if valid
        if(eOLineUpd.size() > 0){
            update eOLineUpd;
        }  
    }

   //Needed in class but does nothing
   global void finish(Database.BatchableContext BC){
   }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////