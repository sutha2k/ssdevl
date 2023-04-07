/**
 * @author Sutharsan Pushparajah
 * @date 05/10/2021 - SSDL V1.4
 * @description Test class for EM013_CalloutTrackerExt_TEST
 */
@isTest
private class EM013_CalloutTrackerExt_TEST {

    @TestSetup
    private static void initData(){
        TST000_TestDataFactory.createStandardUserForFramework();
    }
  
    /**
     * @author Sutharsan Pushparajah
     * @date 05/10/2021
     * @description Testing callout tracking results for IP
     */
    @isTest
    private static void testTrackCalloutIP(){
        
        String transactionId;
        
        Test.startTest();

        //New behavior SPRING23: Static variables are reset when called in multi user / flow context, do not persist anymore globally into whole transaction
        transactionId = APU002_Context.TRANSACTION_GUID;
        
        System.runAs(TST000_TestDataFactory.getStandardUserForFramework()){
            APU002_Context.bypassEventPublishingInTestContext = false;

            Boolean result = APU000_Logger.trackCallout(null, null, null);
            System.assertEquals(false, result);


            Map<String, Object> input = new Map<String, Object>{APU000_Logger.SERVICE_NAME => 'TestingMockService', 
                                                                APU000_Logger.METHOD => 'POST',
                                                                APU000_Logger.MESSAGE => 'test',
                                                                APU000_Logger.STATUS => 'OK',
                                                                APU000_Logger.STATUS_CODE => 200,
                                                                APU000_Logger.REQUEST => 'Request',
                                                                APU000_Logger.RESPONSE => 'Response',
                                                                APU000_Logger.QUERY_PARAMETERS => '?q=1'};
            result = APU000_Logger.trackCallout(input, null, null);
            System.assertEquals(true, result);

            //FIRE SOME EVENTS
            Test.stopTest();

            List<CalloutTrackerExt__c> resultList = EM013_CalloutTrackerExt.getList();

            System.assertNotEquals(null, resultList);
            System.assertEquals(1, resultList.size());

            CalloutTrackerExt__c ctext = resultList.get(0);
            System.assertNotEquals(null, ctext.EndTime__c);
            System.assertEquals('CALLOUT:MOCK2/mock', ctext.Endpoint__c);
            System.assertEquals('POST', ctext.HttpMethod__c);
            System.assertEquals('test', ctext.Message__c);
            System.assertEquals('?q=1', ctext.QueryParameters__c);
            System.assertEquals('BODY[Request]', ctext.Request__c);
            System.assertEquals('/mock', ctext.Resource__c);
            System.assertEquals('BODY[Response]', ctext.Response__c);
            System.assertEquals('SID-0000', ctext.ServiceId__c);
            System.assertNotEquals(null, ctext.StartTime__c);
            System.assertEquals('OK', ctext.Status__c); 
            System.assertEquals(200, ctext.StatusCode__c);
            System.assertEquals(120000, ctext.Timeout__c);
            System.assertEquals(transactionId, ctext.TransactionId__c);
            System.assertEquals(UserInfo.getUserId(), ctext.UserId__c);
            System.assertEquals(UserInfo.getUserName(), ctext.Username__c);

            APU002_Context.bypassEventPublishingInTestContext = true;
        }
    }
}