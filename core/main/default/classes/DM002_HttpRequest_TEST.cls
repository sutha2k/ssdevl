/**
 * @author Sutharsan Pushparajah
 * @date 26/03/2021 - SSDL V1.2
 * @description Test class for DM002_HttpRequest
 */
@isTest
private class DM002_HttpRequest_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('This is a mock');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Mocking callout in test context with success path
     */
    @isTest
    private static void testSuccess(){
        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0000', new TestingMock());

        Test.startTest();

        ITF004_HttpRequestManager requestManager = new DM003_HttpRequestService('TestingMockService');
        WRP003_HttpRequest wrpReq = new WRP003_HttpRequest();
        wrpReq.requestType = 'GET';

        requestManager.sendRequest(wrpReq);

        System.assertNotEquals(null, wrpReq.httpResponse);
        System.assertEquals('This is a mock', wrpReq.httpResponse.getBody());
        System.assertEquals('OK', wrpReq.httpResponse.getStatus());
        System.assertEquals(200, wrpReq.httpResponse.getStatusCode());

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Mocking callout in test context with KO path
     */
    @isTest
    private static void testKo(){
        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-FAKE', new TestingMock());

        Test.startTest();

        ITF004_HttpRequestManager requestManager = new DM003_HttpRequestService('TestingMockService');
        WRP003_HttpRequest wrpReq = new WRP003_HttpRequest();
        wrpReq.requestType = 'GET';

        requestManager.sendRequest(wrpReq);

        System.assertEquals('Mock not available', wrpReq.httpResponse.getBody());
        System.assertEquals('KO', wrpReq.httpResponse.getStatus());
        System.assertEquals(400, wrpReq.httpResponse.getStatusCode());

        //METHOD GET not provided, POST by default
        wrpReq = new WRP003_HttpRequest();
        requestManager.sendRequest(wrpReq);
        System.assertEquals('POST', wrpReq.requestType);

        //HTTP METHOD  not provided
        wrpReq = new WRP003_HttpRequest();
        wrpReq.requestType = null;
        requestManager.sendRequest(wrpReq);
        System.assertNotEquals(null, wrpReq.theException);
 

        Test.stopTest();
    }
}