/**
 * @author Sutharsan Pushparajah
 * @date 22/08/2019 - SSDL V1.0
 * @description Test class for APU000_Logger
 */
@isTest
private class APU000_Logger_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing logging results
     */
    @isTest
    private static void testLog(){
        Test.startTest();
        
        String results = APU000_Logger.log(LoggingLevel.DEBUG, 'APU000_Logger_TEST', 'testLog', 'This is a test');
        System.assertEquals('## >> [APU000_Logger_TEST][testLog][MESSAGE]: This is a test', results);
        
        APU002_Context.bypassEventPublishingInTestContext = false;

        results = APU000_Logger.log(null, null, 'testLog', 'This is a test');
        System.assertEquals('## >> [null][testLog][MESSAGE]: This is a test [EVENT PUBLISHED=false]', results);

        results = APU000_Logger.log(LoggingLevel.DEBUG, null, 'testLog', 'This is a test');
        System.assertEquals('## >> [null][testLog][MESSAGE]: This is a test [EVENT PUBLISHED=false]', results);

        results = APU000_Logger.log(LoggingLevel.DEBUG, 'APU000_Logger_TEST', 'testLog', 'This is a test');
        System.assertEquals('## >> [APU000_Logger_TEST][testLog][MESSAGE]: This is a test [EVENT PUBLISHED=true]', results);
        APU002_Context.bypassEventPublishingInTestContext = true;

        Test.stopTest();

        System.assertEquals(0, Limits.getDmlStatements());
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 30/03/2021
     * @description Testing callout tracking results
     */
    @isTest
    private static void testTrackCallout(){
        
        HttpRequestService__mdt service = HttpRequestService__mdt.getInstance('TestingMockService');
        WRP003_HttpRequest wrpReq = new WRP003_HttpRequest();
        wrpReq.endPoint = 'https://mock';
        wrpReq.requestType = 'GET';
        wrpReq.header.put('testH', 'testV');
        wrpReq.queryParameters = '/Id/xxxx';
        wrpReq.timeout = 120000;

        Test.startTest();
        
        Boolean results = APU000_Logger.trackCallout(null, null, null, null, null);
        System.assertEquals(false, results);
        
        APU002_Context.bypassEventPublishingInTestContext = false;
        results = APU000_Logger.trackCallout(null, null, null, null, null);
        System.assertEquals(false, results);

        results = APU000_Logger.trackCallout(service, System.now(), System.now(), 'Sent', wrpReq);
        System.assertEquals(true, results);
        APU002_Context.bypassEventPublishingInTestContext = true;

        Test.stopTest();

        System.assertEquals(0, Limits.getDmlStatements());
    }
}