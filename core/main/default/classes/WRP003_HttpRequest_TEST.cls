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

        //Test case with basic information
        WRP003_HttpRequest wrpReq = new WRP003_HttpRequest();
        wrpReq.endPoint = 'https://mock';
        wrpReq.userName = 'testUser';
        wrpReq.password = 'testPwd';
        wrpReq.timeout = 120000;
        wrpReq.requestType = 'POST';
        wrpReq.body = 'testBody';
        wrpReq.bodyParams.put('grant_type', 'client_credentials');

        wrpReq.buildRequest(null);

        HttpRequest req = wrpReq.httpRequest;
        Blob headerValue = Blob.valueOf(wrpReq.userName + ':' + wrpReq.password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        System.assertNotEquals(null, req);
        System.assertEquals(wrpReq.endPoint, req.getEndpoint());
        System.assertEquals(wrpReq.requestType, req.getMethod());
        System.assertEquals('grant_type=client_credentials&testBody', req.getBody());
        System.assertEquals(authorizationHeader, req.getHeader('Authorization'));

        //Test case with advance parameters
        DOM.Document doc = new DOM.Document();
        doc.load('<xml></xml>');

        //certificate can't be test with fake value
        //wrpReq.certificate = 'fake';
        wrpReq.accessToken = '1234';
        wrpReq.bodyDocument = doc;
        wrpReq.body = null;

        wrpReq.buildRequest(null);
        req = wrpReq.httpRequest;
        authorizationHeader = 'Bearer 1234';

        System.assertNotEquals(null, req);
        System.assertEquals('<?xml version="1.0" encoding="UTF-8"?><xml />', req.getBodyDocument().toXmlString());
        System.assertEquals(authorizationHeader, req.getHeader('Authorization'));

        //test case with HttpRequestService
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