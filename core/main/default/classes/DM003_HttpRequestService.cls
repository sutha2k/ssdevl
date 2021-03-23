/**
 * @author Sutharsan Pushparajah
 * @date 04/03/2021 - SSDL V1.2
 * @description DM003_HttpRequestService - extends HttpRequest to callout external service
 */
public inherited sharing class DM003_HttpRequestService extends DM002_HttpRequest{

    /**
     * @author Sutharsan Pushparajah
     * @date 04/03/2021
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public DM003_HttpRequestService(String serviceName){
        super(serviceName);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 04/03/2021
     * @description method to be implemented depending on how to handle response for each service provider
     * @param httpRequestInfos wrapper containing request/response infos
     * @return void
     */
    public override virtual void parseHttpResponse(WRP003_HttpRequest httpRequestInfos){
        System.debug('Response : '+httpRequestInfos.httpResponse.getBody());
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 04/03/2021
     * @description method to callout external service
     * @param httpRequestInfos wrapper containing request/response infos
     * @return void
     */
    public void sendRequest(WRP003_HttpRequest httpRequestInfos){
        executeHttpRequest(httpRequestInfos);
    }
}