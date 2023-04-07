/**
 * @author Sutharsan Pushparajah
 * @date 04/03/2021 - SSDL V1.2
 * @description DM002_HttpRequest - Every Custom HttpRequest Webservice class must extends this class to inherit standard behaviour
 */
public inherited sharing abstract class DM002_HttpRequest {
    
    /* Holds the setting for the resource to call */
    private HttpRequestService__mdt requestService;

    /**
     * @author Sutharsan Pushparajah
     * @date 08/03/2021
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public DM002_HttpRequest(String serviceName){
        requestService = HttpRequestService__mdt.getInstance(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 04/03/2021
     * @description Method to make a HTTP Callout
     * @param httpRequestInfos wrapper containing request parameters
     * @return N/A
     */
    protected void executeHttpRequest(WRP003_HttpRequest httpRequestInfos){
        Datetime startTime;
        Datetime endTime;
        String message;
        try {
            httpRequestInfos.buildRequest(requestService);
            startTime = System.now();
            httpRequestInfos.httpResponse = new Http().send(httpRequestInfos.httpRequest);
        } catch (Exception exp){
           	httpRequestInfos.theException = exp;
            message = exp.getMessage();
            APU000_Logger.log(LoggingLevel.ERROR, 'DM002_HttpRequest', 'executeHttpRequest', message);
        }  finally {
            endTime = System.now();
            APU000_Logger.trackCallout(requestService, startTime, endTime, message, httpRequestInfos);
            parseHttpResponse(httpRequestInfos);
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 04/03/2021
     * @description method to be implemented depending on how to handle response for each service provider
     * @param httpRequestInfos wrapper containing request/response infos
     * @return void
     */
    public abstract void parseHttpResponse(WRP003_HttpRequest httpRequestInfos);
}