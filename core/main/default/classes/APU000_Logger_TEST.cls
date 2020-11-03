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
        
        Test.stopTest();
    }
}