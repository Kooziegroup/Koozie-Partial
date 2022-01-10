public with sharing class EBSResponsibilityDMLResponse {
	public static void EBSResponsibilityDMLResponse(HttpResponse response, Responsibility_Type__c con, String DMLType) {
		//Check if response is valid
		if(response.getStatusCode()==200 || response.getStatusCode()==201) 
		{      
		    string resBody = ''; 
		    resBody = response.getBody();
		    
		    //Add Json response text to SF
			Apex_Errors__c att1 = new Apex_Errors__c();  
			att1.string__c = resBody;		
			att1.Type__c = 'Response'; 
			att1.Responsibility_Type__c = con.Id;
			insert att1;            
	
			//Initial variables
			string conId = '';
			string addyId = '';
			string commId = '';
			string commName = '';
			string commInfo = '';
			string emailId = '';
			string otherEmailId = '';
			string phoneId = '';
			integer phoneCount = 0;			
			integer emailCount = 0;	
			Map<String, Map<String, String>> mpCommEmail = new Map<String, Map<String, String>>();
			Map<String, Map<String, String>> mpCommPhone = new Map<String, Map<String, String>>();
			
			
			//Parse Json response
			JSONParser parser = JSON.createParser(resBody);
			while (parser.nextToken() != null) {
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
					String fieldName = parser.getText();
					parser.nextToken();
					if(fieldName == 'ContactID') {
						if(DMLType == 'Create'){
						con.Contact_ID__c = parser.getText();
						}
			   		} else if(fieldName == 'AddressID'){
						con.Address1_ID__c = parser.getText();
			   		} else if(fieldName == 'CommunicationID'){
						commId = parser.getText();
						parser.nextToken();
						fieldName = parser.getText();
						
						if(fieldName == 'CommunicationMethod'){
						parser.nextToken();
						commName = parser.getText();
						
						if(commName == 'Email'){

							//Get next token. Create map of email types
							parser.nextToken();
							fieldName = parser.getText();

							if(fieldName == 'CommunicationInfo'){
								parser.nextToken();
								commInfo = parser.getText();
								
								Map<String, String> mpTempCommEmail = new Map<String, String>();
								mpTempCommEmail.put(commInfo,commID);

								if(mpCommEmail.size() == 0){
									mpCommEmail.put('Email', mpTempCommEmail);
								} else {
									Map<String, String> mpTempCommEmail2 = mpCommEmail.get('Email');
									mpTempCommEmail2.put(commInfo,commID);
                                    mpCommEmail.put('Email',mpTempCommEmail2);
                                    SYSTEM.DEBUG('##EMAIL: ' + mpCommEmail);
								}
							}

						} else if(commName == 'FAX'){
							con.FaxID__c = commID;						
						} else if(commName == 'PHONE'){

							//Get next token. Create map of email types
							parser.nextToken();
							fieldName = parser.getText();

							if(fieldName == 'CommunicationInfo'){
								parser.nextToken();
								commInfo = parser.getText();
								
								Map<String, String> mpTempCommPhone = new Map<String, String>();
								mpTempCommPhone.put(commInfo,commID);

								if(mpCommPhone.size() == 0){
									mpCommPhone.put('Phone', mpTempCommPhone);
								} else {
									Map<String, String> mpTempCommPhone2 = mpCommPhone.get('Phone');
									mpTempCommPhone2.put(commInfo,commID);
									mpCommPhone.put('Phone',mpTempCommPhone2);
								}
							}							
						} 						
						}	
					}
				} 
			}	
			
			//Update email IDs. 
			if(con.Email__c != null || con.Other_Email__c != null){
				Responsibility_Type__c conToUpdate = respEmailParse(mpCommEmail, con);
				con.EmailID__c = conToUpdate.EmailID__c;
				con.Other_Email_ID__c = conToUpdate.Other_Email_ID__c;		
			}		

			//Update Phone IDs. 
			if(con.Phone__c != null || con.Other_Phone__c != null){
				Responsibility_Type__c conToUpdatePhone = respPhoneParse(mpCommPhone, con);
				con.PhoneID__c = conToUpdatePhone.PhoneID__c;
				con.OtherPhoneID__c = conToUpdatePhone.OtherPhoneID__c;		
            }				
            
			//Clear ids for null communication types
			con.PhoneID__c = (con.Phone__c == null || con.Phone__c == '') ? null : con.PhoneID__c;
			con.OtherPhoneID__c = (con.Other_Phone__c == null || con.Other_Phone__c == '') ? null : con.OtherPhoneID__c;
			con.FaxID__c = (con.Fax__c == null || con.Fax__c == '') ? null : con.FaxID__c;			
			con.EmailID__c = (con.Email__c == null || con.Email__c == '') ? null : con.EmailID__c;
			con.Other_Email_ID__c = (con.Other_Email__c == null || con.Other_Email__c == '') ? null : con.Other_Email_ID__c;            
			
			//Update contact with IDs from EBS
			if(con != null){
				update con;
			}
	    	} else {
	    		
		    string resBody = ''; 
		    resBody = response.getBody();
		        		
		    //Add Json response (errors) text to SF
			Apex_Errors__c att2 = new Apex_Errors__c();   
			att2.string__c = resBody;		
			att2.Type__c = 'Response';
			att2.Responsibility_Type__c = con.Id;
			insert att2;          		
	    }
    }

	public static Responsibility_Type__c respEmailParse(Map<String, Map<String, String>> mpCommEmail, Responsibility_Type__c con){
	
		String conEmail = con.email__c;
		string conOtherEmail = con.Other_Email__c;
		
		Map<String, String> mpTempCommEmail2 = new Map<String, String>();
		mpTempCommEmail2 = mpCommEmail.get('Email');
		
		if(mpTempCommEmail2 != null){
			con.Other_Email_ID__c = (mpTempCommEmail2.get(con.Other_Email__c) != null) ? mpTempCommEmail2.get(con.Other_Email__c) : null;
			con.EmailID__c = (mpTempCommEmail2.get(con.Email__c) != null) ? mpTempCommEmail2.get(con.Email__c) : null;
		} else {
            con.Other_Email_ID__c = null;
            con.EmailID__c = null;
        }
	
		Return con;
	}

	public static Responsibility_Type__c respPhoneParse(Map<String, Map<String, String>> mpCommPhone, Responsibility_Type__c con){
	
		String conPhone = con.Phone__c;
		string conOtherPhone = con.Other_Phone__c;
		
		Map<String, String> mpCommPhone2 = new Map<String, String>();
		mpCommPhone2 = mpCommPhone.get('Phone');
		
		if(mpCommPhone2 != null){
			con.OtherPhoneID__c = (mpCommPhone2.get(con.Other_Phone__c) != null) ? mpCommPhone2.get(con.Other_Phone__c) : null;
			con.PhoneID__c = (mpCommPhone2.get(con.Phone__c) != null) ? mpCommPhone2.get(con.Phone__c) : null;
		} else {
            con.OtherPhoneID__c = null;
            con.PhoneID__c = null;
        }
	
		Return con;
	}    
}