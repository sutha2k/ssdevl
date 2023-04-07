/**
 * @author Sutharsan Pushparajah
 * @date 29/03/2021 - SSDL V1.3
 * @description EM011_CalloutTracker - Entity to manage CalloutTracker__e platform event 
 */
public inherited sharing class EM011_CalloutTracker {
    
    /* Truncate field String if beyond */
    private static final Integer MAX_LENGTH_LONG_TEXT_AREA = 131000;
    private static final Integer MAX_LENGTH_TEXT_AREA = 31000;
    private static final Integer MAX_LENGTH_TEXT = 254; 

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
        String requestStr = '';
        String responseStr = '';

        CalloutTracker__e calloutTracker = new CalloutTracker__e();
        calloutTracker.TransactionId__c = transactionId;
        calloutTracker.ServiceId__c = serviceId;
        calloutTracker.Headers__c = truncate(JSON.serialize(wrpRequest.header), MAX_LENGTH_TEXT_AREA);
        calloutTracker.HttpMethod__c = wrpRequest.requestType;
        calloutTracker.Resource__c = truncate(resource, MAX_LENGTH_TEXT);
        calloutTracker.Endpoint__c = truncate(wrpRequest.endPoint, MAX_LENGTH_TEXT);
        calloutTracker.QueryParameters__c = truncate(wrpRequest.queryParameters, MAX_LENGTH_TEXT);
        calloutTracker.Timeout__c = wrpRequest.timeout;
        calloutTracker.StartTime__c = startTime;
        calloutTracker.EndTime__c = endTime;
        calloutTracker.UserId__c = userId;
        calloutTracker.Username__c = userName;
        calloutTracker.Message__c = truncate(message, MAX_LENGTH_TEXT_AREA);

        if (wrpRequest.httpResponse != null){
            calloutTracker.Status__c = truncate(wrpRequest.httpResponse.getStatus(), MAX_LENGTH_TEXT);
            calloutTracker.StatusCode__c = wrpRequest.httpResponse.getStatusCode();
        }

        if (String.isNotEmpty(wrpRequest.body)){
            requestStr = ' BODY['+wrpRequest.body+']';
        }

        if (wrpRequest.bodyDocument != null){
            requestStr += ' BODYDOC['+wrpRequest.bodyDocument.toXmlString()+']';
        }

        if (wrpRequest.httpResponse != null){
            responseStr = 'BODY['+wrpRequest.httpResponse.getBody()+']';
        }

        if (wrpRequest.soapRequest == null){
            calloutTracker.Request__c = truncate(requestStr, MAX_LENGTH_LONG_TEXT_AREA);
            calloutTracker.Response__c = truncate(responseStr, MAX_LENGTH_LONG_TEXT_AREA);
        } else {
            calloutTracker.Request__c = truncate(wrpRequest.soapRequest+requestStr, MAX_LENGTH_LONG_TEXT_AREA);
            calloutTracker.Response__c = truncate(wrpRequest.soapResponse+responseStr, MAX_LENGTH_LONG_TEXT_AREA);
        }

        return calloutTracker;
    }

    /* @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description truncate and return the string representation of the object 
     * @param value object to transform/truncate into string
     * @param maxLength maximum length allowed
     * @return substring to respect max length
     */
    @testVisible
    private static String truncate(Object value, Integer maxLength){
        String temp = null;

        if (value != null){
            temp = String.valueOf(value);
            
            if (temp.length() > maxLength){
                temp = temp.substring(0, maxLength);
            }

            temp = temp.replaceAll('\\$', '&#x24;');
        }

        return temp;
    }
}