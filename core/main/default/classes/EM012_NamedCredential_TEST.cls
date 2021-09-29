/**
 * @author Sutharsan Pushparajah
 * @date 29/09/2021 - SSDL V1.4
 * @description Test class for EM012_NamedCredentials
 */
@isTest
private class EM012_NamedCredential_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 29/09/2021
     * @description get the url from named credential
     */
    @isTest
    private static void getTrueEndpoint(){

        EM012_NamedCredential.endpointByName.put('testcallout', 'https://test');

        Test.startTest();

        System.assertEquals(null, EM012_NamedCredential.getTrueEndpoint(null));
        System.assertEquals('', EM012_NamedCredential.getTrueEndpoint(''));
        System.assertEquals('callout', EM012_NamedCredential.getTrueEndpoint('callout'));
        System.assertEquals('callout:', EM012_NamedCredential.getTrueEndpoint('callout:'));
        System.assertEquals('callout:/', EM012_NamedCredential.getTrueEndpoint('callout:/'));
        System.assertEquals('callout:not/', EM012_NamedCredential.getTrueEndpoint('callout:not/'));
        System.assertEquals('https://test', EM012_NamedCredential.getTrueEndpoint('callout:TestCallout/'));
        System.assertEquals('https://test', EM012_NamedCredential.getTrueEndpoint('callout:TESTCALLOUT/'));
        System.assertEquals('https://test', EM012_NamedCredential.getTrueEndpoint('callout:testcallout/'));

        Test.stopTest();
    }
}