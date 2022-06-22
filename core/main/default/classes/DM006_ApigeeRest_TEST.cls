/**
 * @author Sutharsan Pushparajah
 * @date 07/04/2022
 * @description Test class for DM006_ApigeRest
 */
@isTest
private class DM006_ApigeeRest_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 07/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"message":"This is a mock"}');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 07/04/2022
     * @description Test parsing the response of the callout
     */
    @isTest
    private static void testParseHttpResponse(){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        ITF004_HttpRequestManager restManager = new DM006_ApigeeRest('TestingMockService');
        Boolean isException = false;

        Test.startTest();

        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0000', new TestingMock());

        try{
            restManager.sendRequest(httpRequestInfos);
        } catch(DM006_ApigeeRest.ApigeeCustomException exp){
            isException = true;
        }

        System.assertEquals(false, isException, 'No ApigeeCustomException must be thrown');
        System.assertEquals(true, httpRequestInfos.header.containsKey('Content-Length'), 'Header must contain Content-Length');
        System.assertEquals(true, httpRequestInfos.header.containsKey('X-correlation-id'), 'Header must contain X-correlation-id');

        //TESTING 1ST EXCEPTION : Exception caught
        httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.theException = new DM006_ApigeeRest.ApigeeCustomException('Something wrong');
        isException = false;

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(DM006_ApigeeRest.ApigeeCustomException exp){
            isException = true;
        }

        System.assertEquals(true, isException, 'An ApigeeCustomException must be thrown');

        //TESTING 2ND EXCEPTION : Missing Response
        httpRequestInfos = new WRP003_HttpRequest();
        isException = false;
        String expMesssage = '';

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(Exception exp){
            isException = true;
            expMesssage = exp.getMessage();
        }

        System.assertEquals(true, isException, 'An Exception must be thrown');

        //TESTING 3rd EXCEPTION : Error Status Code
        httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.httpResponse = new HttpResponse();
        httpRequestInfos.httpResponse.setStatusCode(400);
        isException = false;
        expMesssage = '';

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(DM006_ApigeeRest.ApigeeCustomException exp){
            isException = true;
            expMesssage = exp.getMessage();
        }

        System.assertEquals(true, isException, 'An Exception must be thrown, Status Code must be 200, 201 or 206');

        httpRequestInfos.httpResponse.setStatusCode(201);
        isException = false;
        expMesssage = '';

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(DM006_ApigeeRest.ApigeeCustomException exp){
            isException = true;
            expMesssage = exp.getMessage();
        }

        System.assertEquals(false, isException, 'No Exception must be thrown, Status Code must be 200, 201 or 206');

        httpRequestInfos.httpResponse.setStatusCode(206);
        isException = false;
        expMesssage = '';

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(DM006_ApigeeRest.ApigeeCustomException exp){
            isException = true;
            expMesssage = exp.getMessage();
        }

        System.assertEquals(false, isException, 'No Exception must be thrown, Status Code must be 200, 201 or 206');
        
        Test.stopTest();
    }
}