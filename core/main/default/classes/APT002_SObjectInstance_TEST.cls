/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @description Test class for APT002_SObjectInstance
 */
@isTest
private class APT002_SObjectInstance_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description test instanciation of trigger manager for SObject
     */
    @isTest
    private static void testConstructor(){
        Test.startTest();
        
        String sObjectName = SObjectType.SampleForTest__c.Name;
        ITF002_TriggerManager triggermanager = new APT002_SObjectInstance(sObjectName, 'SampleForTestTrigger');
        System.assertNotEquals(null, triggermanager);
        System.assertEquals(sObjectName, ((APT000_TriggerManager)triggermanager).theSObjectName);
        System.assertEquals('SampleForTestTrigger', ((APT000_TriggerManager)triggermanager).triggerClassName);
        
        triggermanager.overrideTriggerEvent(new Map<String, String>{'BEFORE_INSERT' => 'APT100_Account.BeforeInsert'});
        
        Test.stopTest();
    }
}