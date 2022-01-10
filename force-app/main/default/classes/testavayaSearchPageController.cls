@isTest
public class testavayaSearchPageController{

    public static testMethod void testMyController() {
        PageReference pageRef = Page.avayaSearchPageVF;
        Test.setCurrentPage(pageRef);
      
        avayaSearchPageController controller = new avayaSearchPageController();
        controller.searchAccounts();


        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');
      
        // Instantiate a new controller with all parameters in the page
        controller = new avayaSearchPageController(); 
        controller.FirstPage();
        controller.next();
        controller.next();
        controller.previous();
        controller.LastPage();
        controller.getnxt();
        controller.searchAcc();
        controller.getprev();
        
        controller.searchAccounts();

    }
}