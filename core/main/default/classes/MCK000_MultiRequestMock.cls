/**
 * @author Sutharsan Pushparajah
 * @date 26/03/2021 - SSDL V1.2
 * @description  MCK000_MultiRequestMock - Mock response manager for multiple callout
 */
public inherited sharing class MCK000_MultiRequestMock implements HttpCalloutMock{

    /* map of mock by HttpServiceId */
    private Map<String, HttpCalloutMock> requests = new Map<String, HttpCalloutMock>();

    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Find the corresponding mock implementation based on service header
     * @param req request to send to external webservice
     * @return HttpResponse response given to each request
     */
    public HttpResponse respond(HttpRequest req) {
        
        String httpServiceId = req.getHeader(WRP003_HttpRequest.SERVICE_HEADER);

        HttpCalloutMock mock = requests.get(httpServiceId);

        if (mock != null) {
            return mock.respond(req);
        }

        HttpResponse res = new HttpResponse();
        res.setStatus('KO');
        res.setStatusCode(400);
        res.setBody('Mock not available');

        return res;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description fill a map of mock implementation by url
     * @param httpServiceId id of the service to call
     * @param mock Mock implementation for the service
     */
    public void addRequestMock(String httpServiceId, HttpCalloutMock mock) {
        requests.put(httpServiceId, mock);
    }
}
