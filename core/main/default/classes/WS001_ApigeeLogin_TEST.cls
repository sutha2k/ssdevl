/**
 * @author Sutharsan Pushparajah
 * @date 21/06/2022 - SSDL V1.5
 * @description Test class for WS001_ApigeeLogin
 */
@isTest
private class WS001_ApigeeLogin_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Error response for mock
     * @return String Serialized Error response
     */
    private static String buildErrorResponse(){

        WS001_ApigeeLogin.TokenResponse tokenResponse = new WS001_ApigeeLogin.TokenResponse();
        tokenResponse.access_token = 'error';
        tokenResponse.application_name = 'ApigeeAuthProvider';
        tokenResponse.expires_in = '32123938';
        tokenResponse.issued_at = '1111111';
        tokenResponse.refresh_count = '1';
        tokenResponse.status = 'KO';
        tokenResponse.scope = 'read';
        tokenResponse.client_id = '1234';
        tokenResponse.Error = 'Error';
        tokenResponse.ErrorCode = '400';

        return System.JSON.serializePretty(tokenResponse);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Failure response for mock
     * @return String Serialized Failure response
     */
    private static String buildFailureResponse(){
        WS001_ApigeeLogin.Detail detail = new WS001_ApigeeLogin.Detail();
        detail.errorcode = '400';

        WS001_ApigeeLogin.Fault fault = new WS001_ApigeeLogin.Fault();
        fault.faultstring = 'Login Error {0}';
        fault.detail = detail;

        WS001_ApigeeLogin.TokenResponse tokenResponse = new WS001_ApigeeLogin.TokenResponse();
        tokenResponse.access_token = 'error';
        tokenResponse.application_name = 'ApigeeAuthProvider';
        tokenResponse.expires_in = '32123938';
        tokenResponse.issued_at = '1111111';
        tokenResponse.refresh_count = '1';
        tokenResponse.status = 'KO';
        tokenResponse.scope = 'read';
        tokenResponse.client_id = '1234';
        tokenResponse.fault = fault;

        return System.JSON.serializePretty(tokenResponse);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);

            WS001_ApigeeLogin.TokenResponse tokenResponse = new WS001_ApigeeLogin.TokenResponse();
            tokenResponse.access_token = 'mocktoken';
            tokenResponse.application_name = 'ApigeeAuthProvider';
            tokenResponse.expires_in = '32123938';
            tokenResponse.issued_at = '1111111';
            tokenResponse.refresh_count = '1';
            tokenResponse.status = 'OK';
            tokenResponse.scope = 'read';
            tokenResponse.client_id = '1234';

            res.setBody(System.JSON.serializePretty(tokenResponse));

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Mocking callout in test context Error Case
     */
    public inherited sharing class TestingMockError implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);

            res.setBody(buildErrorResponse());

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Mocking callout in test context Failure Case
     */
    public inherited sharing class TestingMockFailure implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);

            res.setBody(buildFailureResponse());

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Testing getting token from resource ApigeeLogin
     */
    @isTest
    private static void testGetToken(){

        Test.startTest();

        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0001', new TestingMock());

        WS001_ApigeeLogin.TokenResponse tokenResponse = null;
        Boolean isError = false;
        
        try{
            tokenResponse = WS001_ApigeeLogin.getToken();
        } catch(WS001_ApigeeLogin.ApigeeTokenException exp){
            isError = false;
        }
        
        System.assertEquals(false, isError);
        System.assertNotEquals(null, tokenResponse);
        System.assertEquals('mocktoken', tokenResponse.access_token);
        System.assertEquals('ApigeeAuthProvider', tokenResponse.application_name);
        System.assertEquals('32123938', tokenResponse.expires_in);
        System.assertEquals('1111111', tokenResponse.issued_at);
        System.assertEquals('1', tokenResponse.refresh_count);
        System.assertEquals('OK', tokenResponse.status);
        System.assertEquals(false, tokenResponse.isError());

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Testing getting token from resource ApigeeLogin error Case
     */
    @isTest
    private static void testGetTokenError(){

        Test.startTest();

        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0001', new TestingMockError());

        WS001_ApigeeLogin.TokenResponse tokenResponse = new WS001_ApigeeLogin.TokenResponse();
        System.assertEquals(null, tokenResponse.getErrorMessage());

        tokenResponse = null;
        Boolean isError = false;
        
        try{
            tokenResponse = WS001_ApigeeLogin.getToken();
        } catch(WS001_ApigeeLogin.ApigeeTokenException exp){
            isError = true;
            String errorBody = buildErrorResponse();
            System.assertEquals('Code: 400/ Message: Error '+ 'response: '+errorBody, exp.getMessage());
        }
        
        System.assertEquals(true, isError);
        System.assertEquals(null, tokenResponse);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 21/06/2022
     * @description Testing getting token from resource ApigeeLogin Failure Case
     */
    @isTest
    private static void testGetTokenFailure(){

        Test.startTest();

        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0001', new TestingMockFailure());

        WS001_ApigeeLogin.TokenResponse tokenResponse = null;
        Boolean isError = false;
        
        try{
            tokenResponse = WS001_ApigeeLogin.getToken();
        } catch(WS001_ApigeeLogin.ApigeeTokenException exp){
            isError = true;
            String errorBody = buildFailureResponse();
            System.assertEquals('Login Error 400'+ ' response: '+errorBody, exp.getMessage());
        }
        
        System.assertEquals(true, isError);
        System.assertEquals(null, tokenResponse);

        Test.stopTest();
    }
}