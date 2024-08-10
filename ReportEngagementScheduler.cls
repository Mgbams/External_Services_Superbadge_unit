global class ReportEngagementScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc) 
    {        
     // Get the current month and year
        String currentMonth = System.now().format('MMMM');
        Integer currentYear = Date.today().year();

        // Calculate the start and end of the current month
        Date startDate = Date.newInstance(currentYear, Date.Today().Month(), 1);
        Date endDate = startDate.addMonths(1).addDays(-1);

        // Query to count distinct OwnerId for Wellness Journey records created in the current month
        AggregateResult[] results = [
            SELECT COUNT_DISTINCT(OwnerId) ownerCount FROM Wellness_Journey__c
            WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate
        ];

        if(results.size() > 0) {
            Integer distinctOwnerCount = (Integer) results[0].get('ownerCount');
            
            // Divide the distinct owner count by number of employees in the org. Assuming 100 for simplicity. 
            Decimal dividedCount = distinctOwnerCount / 100.0;

            // Make a callout to an external service
            EmployeeFitWellUtilClass.reportEngagement(dividedCount, currentMonth);
        }    
    }
}