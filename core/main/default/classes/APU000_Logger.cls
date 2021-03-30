/**
 * @author Sutharsan Pushparajah
 * @date 29/07/2019 - SSDL V1.0
 * @description APU000_Logger - Logging Utilities
 */
public inherited sharing class APU000_Logger{
    
    /** 
     * @author Sutharsan Pushparajah
     * @date 29/07/2019
     * @description Custom sytem.debug with log level and personnalized information
     * @param logLevel System.LoggingLevel to define
     * @param className name of the class from where the log is called
     * @param methodName name of the method from where the log is called
     * @param message Informations to display in logger
     * @return String message that has been logged
     */
    public static String log(System.LoggingLevel logLevel, String className, String methodName, String message){
        
        String results;

        try{

            if (APU002_Context.isLoggingEnabled()) {
                List<Object> parameters = new List<Object>{className, methodName, message};
                results = String.format('## >> [{0}][{1}][MESSAGE]: {2}', parameters);
            
                if (logLevel != null){
                    system.debug(logLevel, results);
                }               
            }

            if (APU002_Context.isLoggingEventEnabled()) {
                
                if (Test.isRunningTest() && APU002_Context.bypassEventPublishingInTestContext){
                    return results;
                }

                LoggingMessage__e messageEvent = EM010_LoggingMessage.create(APU002_Context.TRANSACTION_GUID, className, methodName, 
                logLevel.name(), System.now(), System.now(), message, UserInfo.getUserId(), UserInfo.getUsername());
                Database.SaveResult sr = EventBus.publish(messageEvent);
                results += ' [EVENT PUBLISHED='+sr.isSuccess()+']'; 
            }
        } catch(Exception exp){
            //PREVENT ANY ERROR TO BLOCK THE TRANSACTION
            system.debug(LoggingLevel.ERROR, 'PUBLISHING LoggingMessage__e FAILED: '+exp.getMessage());
            results += ' [EVENT PUBLISHED=false]';
        }
        return results;
    }

    /** 
     * @author Sutharsan Pushparajah
     * @date 29/03/2021
     * @description Track Callout information by publishing an event on CalloutTracker__e
     * @param requestService Instance of the service used to callout
     * @param startTime Identify the start time of the callout
     * @param endTime Identify the end time of the callout
     * @param message The callout message
     * @param wrpRequest extra information on the request
     * @return Boolean publishing has been done or not
     */
    public static Boolean trackCallout(HttpRequestService__mdt requestService, Datetime startTime, Datetime endTime, String message, WRP003_HttpRequest wrpRequest){
        Boolean results = false;
        
        if (APU002_Context.isCalloutTrackingEnabled()){
        
            if (Test.isRunningTest() && APU002_Context.bypassEventPublishingInTestContext){
                return results;
            }

            try{
                CalloutTracker__e calloutTrackerEvent = EM011_CalloutTracker.create(APU002_Context.TRANSACTION_GUID, requestService.ServiceId__c, requestService.Resource__c, startTime, endTime, message, UserInfo.getUserId(), UserInfo.getUsername(), wrpRequest);
                Database.SaveResult sr = EventBus.publish(calloutTrackerEvent);
                results = sr.isSuccess();
            } catch(Exception exp){
                //PREVENT ANY ERROR TO BLOCK THE TRANSACTION
                system.debug(LoggingLevel.ERROR, 'PUBLISHING CalloutTracker__e FAILED: ' +exp.getMessage());
            }
        }

        return results;
    }
}