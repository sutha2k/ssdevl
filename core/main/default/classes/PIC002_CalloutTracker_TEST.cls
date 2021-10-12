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

        vlocity_cmt.VlocityOpenInterface calloutController = new PIC002_CalloutTracker();
        Boolean result = calloutController.invokeMethod('', null, null, null);
        System.assertEquals(false, result);

        result = calloutController.invokeMethod(PIC002_CalloutTracker.METHOD_NAME, null, null, null);
        System.assertEquals(false, result);

        Map<String, Object> input = new Map<String, Object>{APU000_Logger.SERVICE_NAME => 'TestingMockService', APU000_Logger.METHOD => 'POST'};
        result = calloutController.invokeMethod(PIC002_CalloutTracker.METHOD_NAME, input, null, null);
        System.assertEquals(true, result);

        APU002_Context.bypassEventPublishingInTestContext = true;

        Test.stopTest();
    }
}
