/**
 * @author Sutharsan Pushparajah
 * @date 22/09/2021 - SSDL V1.4
 * @description WRP004_SoapRequest - Wrapper to embed SOAP Request/Response values 
 */
public inherited sharing class WRP004_SoapRequest {
    
    /* An instance of the auto-generated class */
    public Object stub;
    /* The SOAP Web service request being invoked */
    public Object request;
    /* A collection of key/value pairs representing the response to send for the request */
    public Map<String,Object> response = new Map<String,Object>();
    /* List of various parameters */
    public List<String> infoArray = new List<String>();
    /* An instance of WRP003_HttpRequest holding request/response information */
    public WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();

    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description Build SoapRequest based on input parameters from instance and/or RequestService__mdt setting
     * @param requestService Holds the setting for the resource to call
     * @return N/A
     */
    public void buildRequest(HttpRequestService__mdt requestService){
        if (requestService != null){
            if (Test.isRunningTest()){
                ((ITF006_SoapRequestMock)stub).setServiceId(requestService.ServiceId__c);
            }

            httpRequestInfos.buildRequest(requestService);
        }
    }

}