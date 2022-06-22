/**
 * @author Sutharsan Pushparajah
 * @date 21/06/2022 - SSDL V1.5
 * @description Test class for APP001_ApigeeAuthProvider
 */
@isTest
private class APP001_ApigeeAuthProvider_TEST {
    
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
            tokenResponse.access_token = '1234';
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

    @isTest
    private static void testAuthProvider(){

        Test.startTest();

        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0001', new TestingMock());

        APP001_ApigeeAuthProvider auth = new APP001_ApigeeAuthProvider();

        System.assertEquals('ApigeeAuthProvider__mdt', auth.getCustomMetadataType());

        PageReference pageRef = auth.initiate(new Map<String, String>{'CallbackURL__c' => '', 'ProviderName__c' => 'ApigeeAuthProvider'}, 'stateToPropagate');
        System.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/services/authcallback/' + 'ApigeeAuthProvider?code=999&state=stateToPropagate', pageRef.getUrl());

        pageRef = auth.initiate(new Map<String, String>{'CallbackURL__c' => 'test', 'ProviderName__c' => 'ApigeeAuthProvider'}, 'stateToPropagate');
        System.assertEquals('test?code=999&state=stateToPropagate', pageRef.getUrl());
        System.assertEquals('999', pageRef.getParameters().get('code'));
        System.assertEquals('stateToPropagate', pageRef.getParameters().get('state'));

        Auth.AuthProviderCallbackState apcs = new Auth.AuthProviderCallbackState(null, null, null);
        apcs.queryParameters = new Map<String, String>{'state' => 'state'};
        Auth.AuthProviderTokenResponse aptr = auth.handleCallback(new Map<String, String>{'CallbackURL__c' => '', 'ProviderName__c' => 'ApigeeAuthProvider'}, apcs);
        System.assertEquals('ApigeeAuthProvider', aptr.provider);
        System.assertEquals('state', aptr.state);
        System.assertEquals('No Refresh Token', aptr.oauthSecretOrRefreshToken);
        System.assertEquals('1234', aptr.oauthToken);

        Auth.OAuthRefreshResult orr = auth.refresh(new Map<String, String>{'CallbackURL__c' => '', 'ProviderName__c' => 'ApigeeAuthProvider'}, null);
        System.assertEquals('1234', orr.accessToken);

        Auth.UserData userData = auth.getUserInfo(new Map<String, String>{'CallbackURL__c' => '', 'ProviderName__c' => 'ApigeeAuthProvider'}, aptr);
        System.assertEquals('ApigeeAuthProvider', userData.provider);
        System.assertEquals('ApigeeAuthProvider', userData.identifier);

        Test.stopTest();
    }
}
