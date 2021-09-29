/**
 * @author Sutharsan Pushparajah
 * @date 29/09/2021 - SSDL V1.4
 * @description  MCK002_MultiWebserviceMock - Mock response manager for multiple callout
 */
@isTest
public inherited sharing class MCK002_MultiWebserviceMock implements WebServiceMock{

    /* map of mock by HttpServiceId */
    private Map<String, WebServiceMock> requests = new Map<String, WebServiceMock>();

    /**
     * @author Sutharsan Pushparajah
     * @date 29/09/2021
     * @description Find the corresponding mock implementation based on service header
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param endpoint The endpoint URL for the request
     * @param soapAction The requested SOAP operation
     * @param requestName The requested SOAP operation name
     * @param responseNS The response namespace
     * @param responseName The name of the response element as defined in the WSDL
     * @param responseType The class for the response as defined in the auto-generated class
     * @return N/A
     */
    public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                            String requestName, String responseNS, String responseName, String responseType) {
        
        String httpServiceId = ((ITF006_SoapRequestMock) stub).getServiceId();

        WebServiceMock mock = requests.get(httpServiceId);

        if (mock != null) {
            mock.doInvoke(stub, request, response, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 29/09/2021
     * @description fill a map of mock implementation by url
     * @param httpServiceId id of the service to call
     * @param mock Mock implementation for the service
     */
    public void addRequestMock(String httpServiceId, WebServiceMock mock) {
        requests.put(httpServiceId, mock);
    }
}