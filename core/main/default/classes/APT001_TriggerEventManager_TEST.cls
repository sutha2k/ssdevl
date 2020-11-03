/**
 * @author Sutharsan Pushparajah
 * @date 30/08/2019 - SSDL V1.0
 * @description Test class for APT001_TriggerEventManager
 */
@isTest
private class APT001_TriggerEventManager_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 30/08/2019
     * @description Testing instanciation of trigger event manager
     */
    @isTest
    private static void testConstructor(){
        Test.startTest();
        
        ITF003_TriggerEventManager eventManager = new APT001_TriggerEventManager();
        eventManager.execute('test-transactionId');
        
        System.assertEquals('test-transactionId', ((APT001_TriggerEventManager)eventManager).transactionId);
        
        Test.stopTest();
    }
}