public class EmployeeFitWellUtilClass {
    private static ExternalService.BalancedLiving_EvaluateEngagement_IN_body bdy;
    
    public static void reportEngagement(Decimal engagement, String month) {
        
        //Call EvaluateEngagement method
        ExternalService.BalancedLiving service = new ExternalService.BalancedLiving();
        //Prepare body input
        bdy = new ExternalService.BalancedLiving_EvaluateEngagement_IN_body();
        bdy.engagement = engagement;
        bdy.month = month;
        
        try {
            ExternalService.BalancedLiving.EvaluateEngagement_Request request = new ExternalService.BalancedLiving.EvaluateEngagement_Request();
            request.body = bdy;
            
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