/**
 * @author Sutharsan Pushparajah
 * @date 05/10/2021 - SSDL V1.4
 * @description EM013_CalloutTrackerExt - Entity to manage CalloutTrackerExt__c 
 */
public inherited sharing class EM013_CalloutTrackerExt {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 06/10/2021
     * @description Retrieve a list of all CalloutTrackerExt__c records to use in test context only
     * @return List<CalloutTrackerExt__c> Lif of all CalloutTrackerExt__c records
     */
    public static List<CalloutTrackerExt__c> getList(){
        
        List<CalloutTrackerExt__c> results = new List<CalloutTrackerExt__c>([select Id, CreatedDate, Name, EndTime__c, Endpoint__c, Headers__c, HttpMethod__c, Message__c, QueryParameters__c, Request__c, Resource__c, Response__c, ServiceId__c, StartTime__c, Status__c, StatusCode__c,  Timeout__c, TransactionId__c, UserId__c, Username__c from CalloutTrackerExt__c WITH SYSTEM_MODE]);
       
        return results;
    }
}