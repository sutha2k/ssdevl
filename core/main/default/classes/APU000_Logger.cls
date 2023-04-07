/**
 * @author Sutharsan Pushparajah
 * @date 29/07/2019 - SSDL V1.0
 * @description APU000_Logger - Logging Utilities
 */
public inherited sharing class APU000_Logger{
    
    /* key to retrieve the unique name of the HttpRequestService__mdt */
    public static final String SERVICE_NAME = 'serviceName';
    /* key to retrieve any message or error to log */
    public static final String MESSAGE = 'message';
    /* key to retrieve the http method */
    public static final String METHOD = 'method';
    /* key to retrieve any parameters to append to url */
    public static final String QUERY_PARAMETERS = 'queryParameters';
    /* key to retrieve the http request status */
    public static final String STATUS = 'status';
    /* key to retrieve the http request status code */
    public static final String STATUS_CODE = 'statusCode';
    /* key to retrieve the full request */
    public static final String REQUEST = 'request';
    /* key to retrieve the full reponse */
    public static final String RESPONSE = 'response';
    /* key to retrieve startTime */
    public static final String START_TIME = 'startTime';
    /* key to retrieve endTime */
    public static final String END_TIME = 'endTime';
    

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
                    System.debug(logLevel, results);
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
            System.debug(LoggingLevel.ERROR, 'PUBLISHING LoggingMessage__e FAILED: '+exp.getMessage());
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

            Boolean oldContextualBypassSchemaDescriber = APU002_Context.contextualBypassSchemaDescriber;
            Boolean oldContextualBypassStripInaccessible = APU002_Context.contextualBypassStripInaccessible;
            Boolean oldContextualBypassWithSecurityEnforced = APU002_Context.contextualBypassWithSecurityEnforced;

            try{
                //Entering SYSTEM MODE
                APU002_Context.contextualBypassSchemaDescriber = true;
                APU002_Context.contextualBypassStripInaccessible = true;
                APU002_Context.contextualBypassWithSecurityEnforced = true;

                if (requestService.TrackingEnabled__c){

                    wrpRequest.endPoint = EM012_NamedCredential.getTrueEndpoint(wrpRequest.endPoint);
                    CalloutTracker__e calloutTrackerEvent = EM011_CalloutTracker.create(APU002_Context.TRANSACTION_GUID, requestService.ServiceId__c, requestService.Resource__c, startTime, endTime, message, UserInfo.getUserId(), UserInfo.getUsername(), wrpRequest);
                    Database.SaveResult sr = EventBus.publish(calloutTrackerEvent);
                    results = sr.isSuccess();

                    if (!results){
                        System.debug(LoggingLevel.Error, 'PUBLISHING CalloutTracker__e FAILED: ' +sr.errors);
                    }
                }
            } catch(Exception exp){
                //PREVENT ANY ERROR TO BLOCK THE TRANSACTION
                System.debug(LoggingLevel.ERROR, 'PUBLISHING CalloutTracker__e FAILED: ' +exp.getMessage());
            } finally{
                //Leaving SYSTEM MODE
                APU002_Context.contextualBypassSchemaDescriber = oldContextualBypassSchemaDescriber;
                APU002_Context.contextualBypassStripInaccessible = oldContextualBypassStripInaccessible;
                APU002_Context.contextualBypassWithSecurityEnforced = oldContextualBypassWithSecurityEnforced;
            }
        }

        return results;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 01/10/2021
     * @param input Map of key/value for inputs
     * @param output Map of key/value for outputs
     * @param options Map of key/value for options
     * @description invokeMethod trackCallout to publish callout event
     * @return Boolean publishing has been done or not
     */
    public static Boolean trackCallout(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
        Boolean results = false;

        try{
            //Getting common static parameters
            HttpRequestService__mdt requestService = HttpRequestService__mdt.getInstance((String) input.get(SERVICE_NAME));
            Datetime startTime = Datetime.now();
            
            if (input.get(START_TIME) != null){
                startTime = (Datetime) input.get(START_TIME);
            }
            
            Datetime endTime = Datetime.now();
            
            if (input.get(START_TIME) != null){
                endTime = (Datetime) input.get(END_TIME);
            }
            
            String message = String.valueOf(input.get(MESSAGE));

            //Setting Request paramters
            WRP003_HttpRequest wrpRequest = new WRP003_HttpRequest();
            wrpRequest.body = String.valueOf(input.get(REQUEST));
            wrpRequest.requestType = String.valueOf(input.get(METHOD));
            wrpRequest.buildRequest(requestService);
            wrpRequest.queryParameters = String.valueOf(input.get(QUERY_PARAMETERS));

            //Setting Response parameters
            wrpRequest.httpResponse = new HttpResponse();

            if (input.get(STATUS) != null){
                wrpRequest.httpResponse.setStatus(String.valueOf(input.get(STATUS)));
            }

            if (input.get(STATUS_CODE) != null){
                wrpRequest.httpResponse.setStatusCode(Integer.valueOf(input.get(STATUS_CODE)));
            }

            if (input.get(RESPONSE) != null){
                wrpRequest.httpResponse.setBody(String.valueOf(input.get(RESPONSE)));
            }

            results = APU000_Logger.trackCallout(requestService, startTime, endTime, message, wrpRequest);

        } catch (Exception exp){
            System.debug(LoggingLevel.ERROR, 'PUBLISHING CalloutTracker__e FAILED: ' +exp.getMessage());
        }

        return results;
    }
}