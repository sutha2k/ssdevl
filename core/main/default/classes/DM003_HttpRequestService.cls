/**
 * @author Sutharsan Pushparajah
 * @date 04/03/2021 - SSDL V1.2
 * @description DM003_HttpRequestService - extends HttpRequest to callout external service
 */
public inherited sharing class DM003_HttpRequestService extends DM002_HttpRequest implements ITF004_HttpRequestManager{

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
        //Implement behaviour depending on external systems
        //for example checking status code or parsing the response to check inner status
        //Each external Systems should have its own implemnentation on dedicated class
        //Every services from one external system should use only one service class (ex: DM003 for Goofle and DM004 for SAP which always extend DM002)
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