public class CaseCreateRequest {
    
    public class ContactID
    {
        public String Email;
        public String FirstName;
        public String LastName;
        public String EBSID;
        public String EBSACCTID;
    }
    
    public String ClarAppVersion;
    public String Subject;
    public String Description;
    public String Status;
    public String Origin;
    public ContactID ContactID;
    public String RecordType;
    public String Contact_Method;
    public String EBS_Order_ID;
    public String PO_Number;
    public String Type;
    public String EBS_Account_Number;
    public String EBS_Clar_ID;
    
    public List<ClarificationQuestions> ClarificationQuestions;
    
    public class ClarificationQuestions
    {
        public String ClarAppVersion;
        public String EBS_ID;
        public String EBS_Order_Line_ID;
        public String Product_Category;
        public String Form_Type;
        public String Line_Number;
        public String Message_Name;
        public String Message_Text;
        public String Message_Type;
        public String Question_Type;
        public String RecordType;
        public String Product_Number;
        public String SEQ;
        public String Status;
        public String Notification_Team;
        public String Response;
        public Boolean Void_Question;
        public String Online_Proof_URL;
        public String Proof_Disposition;
        public String Authorization_First_Name;
        public String Authorization_Last_Name;
        public String Authorization_Organization;
        public String Authorization_Comments;
        public String Integration_Proof;
        public Boolean Closed_by_Integration_Proof;
        public NotificationToAudience Notification_To_Audience;
        public NotificationCCAudience Notification_CC_Audience;
    }
    
    public class Audience
    {
        public String Email;
        public String FirstName;
        public String LastName;
        public String EBSID;
        public String EBSACCTID;
    }

    public class NotificationToAudience
    {
        public List<Audience> Audiences;
    }

    public class NotificationCCAudience
    {
        public List<Audience> Audiences;
    }
        
}