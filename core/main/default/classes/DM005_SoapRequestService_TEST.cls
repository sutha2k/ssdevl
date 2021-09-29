/**
 * @author Sutharsan Pushparajah
 * @date 29/09/2021 - SSDL V1.4
 * @description Test class for DM005_SoapRequestService_TEST
 */
@isTest
private class DM005_SoapRequestService_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 29/9/2021
     * @description Mocking callout in test context with success path
     */
    @isTest
    private static void testSuccess(){
        
        Test.startTest();

        MCK002_MultiWebserviceMock multiMock = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMock);
        multiMock.addRequestMock('SID-0000', new MCK001_SoapRequestMock());

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

        ITF005_SoapRequestManager requestManager = new DM005_SoapRequestService('TestingMockService');
        requestManager.sendRequest(soapRequest);

        System.assertNotEquals(null, wrpReq.soapResponse);
        System.assertEquals('Mock Response', ((Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element>)wrpReq.soapResponse).get('response_x').soapRequestResult);

        Test.stopTest();
    }
}