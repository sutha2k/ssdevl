/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @description Test class for APC000_CoreSetting
 */
@isTest
private class APC000_CoreSetting_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing initializing core setting
     */
    @isTest
    private static void testInit(){
    
        Test.startTest();
        
        System.assertNotEquals(null, APC000_CoreSetting.coreSetting, 'Must not be null');
        System.assertNotEquals(null, APC000_CoreSetting.coreSetting.DeveloperName, 'Must not be null');
        
        Test.stopTest();
    }
}