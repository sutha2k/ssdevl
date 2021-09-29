/**
 * @author Sutharsan Pushparajah
 * @date 28/09/2021 - SSDL V1.4
 * @description Test class for WRP004_SoapRequest
 */
@isTest
private class WRP004_SoapRequest_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/09/2021
     * @description Testing instanciation of the constructor and building request
     */
    @isTest
    private static void testBuildRequest(){

        Test.startTest();

        MCK001_SoapRequestMock.SoapRequestPort soapRequestPort = new MCK001_SoapRequestMock.SoapRequestPort();
        MCK001_SoapRequestMock.SoapRequest_element request = soapRequestPort.buildRequest('inputMock');
        Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element> responseMap = soapRequestPort.buildResponseMap('mockResponse');
        String[] ns_map_type_info = soapRequestPort.ns_map_type_info;

        WRP004_SoapRequest soapRequest = new WRP004_SoapRequest();
        soapRequest.stub = soapRequestPort;
        soapRequest.request = request;
        soapRequest.response = responseMap;
        soapRequest.infoArray = ns_map_type_info;
        
        WRP003_HttpRequest wrpReq = soapRequest.httpRequestInfos;
        wrpReq.endPoint = 'https://mock';
        wrpReq.userName = 'testUser';
        wrpReq.password = 'testPwd';
        wrpReq.timeout = 120000;
        wrpReq.requestType = 'POST';
        wrpReq.body = 'testBody';

        soapRequest.buildRequest(null);

        HttpRequest req = wrpReq.httpRequest;

        System.assertEquals(null, req);

        HttpRequestService__mdt service = HttpRequestService__mdt.getInstance('TestingMockService');
        soapRequest.buildRequest(service);
        req = wrpReq.httpRequest;

        System.assertNotEquals(null, req);
        System.assertEquals(wrpReq.endPoint, req.getEndpoint());
        System.assertEquals(wrpReq.requestType, req.getMethod());
        System.assertEquals(wrpReq.body, req.getBody());
        System.assertEquals('http://YourServer/YourService', ((MCK001_SoapRequestMock.SoapRequestPort)soapRequest.stub).endpoint_x);
        System.assertEquals('inputMock', ((MCK001_SoapRequestMock.SoapRequest_element)soapRequest.request).input);
        System.assertEquals('mockResponse', ((Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element>)soapRequest.response).get('response_x').soapRequestResult);
        System.assertEquals('http://test/test', soapRequest.infoArray.get(0));
        System.assertEquals('tns:test', soapRequest.infoArray.get(1));

        Test.stopTest();
    }
}