public class EmployeeFitWellUtilClass {
    //1. BalancedLiving_EvaluateEngagement_IN_body is the Apex class name of the input i.e body
    private static ExternalService.BalancedLiving_EvaluateEngagement_IN_body bdy;
    
    public static void reportEngagement(Decimal engagement, String month) {
        
        //Call EvaluateEngagement method
        //1. BalancedLiving is the External Service name
        ExternalService.BalancedLiving service = new ExternalService.BalancedLiving();
        //Prepare body input by instantiating the apex class
        bdy = new ExternalService.BalancedLiving_EvaluateEngagement_IN_body();
        bdy.engagement = engagement;
        bdy.month = month;
        
        try {
            //EvaluateEngagement is the method name that i want to call.Append _Request to the name
            ExternalService.BalancedLiving.EvaluateEngagement_Request request = new ExternalService.BalancedLiving.EvaluateEngagement_Request();
            // Pass the prepared body input into the input parameter i.e body
            request.body = bdy;
            
            //Prepare the response by appending _Response to the method name ie EvaluateEngagement_Response
            ExternalService.BalancedLiving.EvaluateEngagement_Response response = service.EvaluateEngagement(request);
            if (response.responseCode == 200) {
                Engagement_Evaluation__c newEvalRecord = new Engagement_Evaluation__c();
                newEvalRecord.Recommendation__c = response.Code200.recommendation;
                newEvalRecord.Status__c = response.Code200.status;
                
                UUID randomUUID = UUID.randomUUID();
                string nem = randomUUID.toString().substring(1, 6) + 'test';
                newEvalRecord.Name = nem;
                
                insert newEvalRecord;
            }
        } catch (ExternalService.BalancedLiving.EvaluateEngagement_ResponseException e) {
            System.debug('Couldn\'t create user with ID: ' + e.defaultResponse);
        }   
        
    }
    
}