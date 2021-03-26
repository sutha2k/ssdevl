/**
 * @author Sutharsan Pushparajah
 * @date 26/03/2021 - SSDL V1.2
 * @description Test class for WRP003_HttpRequest
 */
@isTest
private class WRP003_HttpRequest_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Testing instanciation of the constructor and building request
     */
    @isTest
    private static void testBuildRequest(){

        Test.startTest();

        WRP003_HttpRequest wrpReq = new WRP003_HttpRequest();
        wrpReq.endPoint = 'https://mock';
        wrpReq.userName = 'testUser';
        wrpReq.password = 'testPwd';
        wrpReq.timeout = 120000;
        wrpReq.requestType = 'POST';
        wrpReq.body = 'testBody';

        wrpReq.buildRequest(null);

        HttpRequest req = wrpReq.httpRequest;
        Blob headerValue = Blob.valueOf(wrpReq.userName + ':' + wrpReq.password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        System.assertNotEquals(null, req);
        System.assertEquals(wrpReq.endPoint, req.getEndpoint());
        System.assertEquals(wrpReq.requestType, req.getMethod());
        System.assertEquals(wrpReq.body, req.getBody());
        System.assertEquals(authorizationHeader, req.getHeader('Authorization'));

        HttpRequestService__mdt service = HttpRequestService__mdt.getInstance('TestingMockService');
        System.assertNotEquals(null, service);
        Map<String, String> customHeaders = (Map<String,String>) JSON.deserialize(service.CustomHeaders__c, Map<String,String>.class);

        wrpReq.requestType = 'GET';
        wrpReq.queryParameters = '/MyID';
        wrpReq.buildRequest(service);
        req = wrpReq.httpRequest;

        System.assertNotEquals(null, req);
        System.assertEquals(service.SecondaryNamedEndpoint__c+service.resource__c+wrpReq.queryParameters, req.getEndpoint());
        System.assertEquals(wrpReq.requestType, req.getMethod());
        System.assertEquals('', req.getBody());
        System.assertEquals(customHeaders.get('testheader'), req.getHeader('testheader'));

        Test.stopTest();
    }
}
