/**
 * @author Sutharsan Pushparajah
 * @date 05/10/2021 - SSDL V1.4
 * @description Test class for PIC002_CalloutTracker
 */
@isTest
private class PIC002_CalloutTracker_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 05/10/2021
     * @description Testing logging results
     */
    @isTest
    private static void testInvokeMethod(){
        Test.startTest();

        APU002_Context.bypassEventPublishingInTestContext = false;

        PIC002_CalloutTracker calloutController = new PIC002_CalloutTracker();
        Boolean result = calloutController.invokeMethod('', null, null, null);
        System.assertEquals(false, result);

        result = calloutController.invokeMethod(PIC002_CalloutTracker.METHOD_NAME, null, null, null);
        System.assertEquals(false, result);

        Map<String, Object> input = new Map<String, Object>{APU000_Logger.SERVICE_NAME => 'TestingMockService', APU000_Logger.METHOD => 'POST'};
        result = calloutController.invokeMethod(PIC002_CalloutTracker.METHOD_NAME, input, null, null);
        System.assertEquals(true, result);
        
        input = new Map<String, Object>{APU000_Logger.SERVICE_NAME => 'TestingMockService', APU000_Logger.METHOD => 'POST', 'startTime' => Datetime.now(), 'requestNode' => 'test', 'responseNode' => 'test'};
        Map<String, Object> commonNode = new Map<String, Object>{'TrackCalloutCommon' => input};
            
        result = calloutController.invokeMethod(PIC002_CalloutTracker.METHOD_NAME_V2, commonNode, null, null);
        System.assertEquals(true, result);
        
        Map<String, Object> statusNode = new Map<String, Object>{'status' => 'OK', 'statusCode' => 200};
        input = new Map<String, Object>{APU000_Logger.SERVICE_NAME => 'TestingMockService', APU000_Logger.METHOD => 'POST', 'startTime' => Datetime.now(), 'requestNode' => 'test', 'responseNode' => 'test'};
        input.put('statusNode', 'statusNode');
        commonNode = new Map<String, Object>{'TrackCalloutCommon' => input};
        commonNode.put('statusNode', statusNode);
            
        result = calloutController.invokeMethod(PIC002_CalloutTracker.METHOD_NAME_V2, commonNode, null, null);
        System.assertEquals(true, result);

        APU002_Context.bypassEventPublishingInTestContext = true;

        Test.stopTest();
    }
}