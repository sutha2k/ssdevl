/**
 * @author Sutharsan Pushparajah
 * @date 29/03/2021 - SSDL V1.3
 * @description EM011_CalloutTracker - Entity to manage CalloutTracker__e platform event 
 */
public inherited sharing class EM011_CalloutTracker {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/03/2021
     * @description Create an instance of CalloutTracker__e Event
     * @param transactionId Identify the id of the transaction
     * @param serviceId Identify the id of the service
     * @param resource Identify the name of the resource
     * @param startTime Identify the start time of the callout
     * @param endTime Identify the end time of the callout
     * @param message The callout message
     * @param userId Id of the connected user
     * @param userName userName of the connected user
     * @param wrpRequest extra information on the request
     * @return instance of CalloutTracker__e Event
     */
    public static CalloutTracker__e create(String transactionId, String serviceId, String resource, Datetime startTime, Datetime endTime, String message, String userId, String userName, WRP003_HttpRequest wrpRequest){
        CalloutTracker__e calloutTracker = new CalloutTracker__e();
        calloutTracker.TransactionId__c = transactionId;
        calloutTracker.ServiceId__c = serviceId;
        calloutTracker.Headers__c = JSON.serialize(wrpRequest.header);
        calloutTracker.HttpMethod__c = wrpRequest.requestType;
        calloutTracker.Resource__c = resource;
        calloutTracker.Endpoint__c = wrpRequest.endPoint;
        calloutTracker.QueryParameters__c = wrpRequest.queryParameters;
        calloutTracker.Timeout__c = wrpRequest.timeout;
        calloutTracker.StartTime__c = startTime;
        calloutTracker.EndTime__c = endTime;
        calloutTracker.UserId__c = userId;
        calloutTracker.Username__c = userName;
        calloutTracker.Message__c = message;

        if (wrpRequest.httpResponse != null){
            calloutTracker.Status__c = wrpRequest.httpResponse.getStatus();
            calloutTracker.StatusCode__c = wrpRequest.httpResponse.getStatusCode();
        }

        return calloutTracker;
    }
}
