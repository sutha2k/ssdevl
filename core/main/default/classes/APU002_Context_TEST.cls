/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @description Test class for APU002_Context
 */
@isTest
private class APU002_Context_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description Testing the bypass variable for all triggers
     */
    @isTest
    private static void testHasTriggersBypassAllEnabled(){
        Test.startTest();
        
        System.AssertEquals(false, APU002_Context.hasTriggersBypassAllEnabled());
        
        APU002_Context.contextualBypassAllTriggers = true;
        System.AssertEquals(true, APU002_Context.hasTriggersBypassAllEnabled());
        
        APU002_Context.contextualBypassAllTriggers = false;
        System.AssertEquals(false, APU002_Context.hasTriggersBypassAllEnabled());
        
        Test.stoptest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description Testing the bypass variable for specific trigger
     */
    @isTest
    private static void testHasTriggersBypassEnabled(){
        Test.startTest();
        
        System.assertEquals(false, APU002_Context.hasTriggersBypassEnabled('testHasTriggersBypassEnabled'));
        APU002_Context.contextualBypassAllTriggers = true;
        System.assertEquals(true, APU002_Context.hasTriggersBypassEnabled('testHasTriggersBypassEnabled'));
        APU002_Context.contextualBypassAllTriggers = false;
        
        APU002_Context.addTriggerBypass('testHasTriggersBypassEnabled');
        System.assertEquals(true, APU002_Context.hasTriggersBypassEnabled('testHasTriggersBypassEnabled'));
        APU002_Context.removeTriggerBypass('testHasTriggersBypassEnabled');
        System.assertEquals(false, APU002_Context.hasTriggersBypassEnabled('testHasTriggersBypassEnabled'));
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description Testing the bypass variable for specific trigger and event
     */
    @isTest
    private static void testHasTriggersEventBypassEnabled(){
        Test.startTest();
        
        System.assertEquals(false, APU002_Context.hasTriggersEventBypassEnabled('testHasTriggersEventBypassEnabled', 'AFTER_INSERT'));
        APU002_Context.contextualBypassAllTriggers = true;
        System.assertEquals(true, APU002_Context.hasTriggersEventBypassEnabled('testHasTriggersEventBypassEnabled', 'AFTER_INSERT'));
        APU002_Context.contextualBypassAllTriggers = false;
        
        APU002_Context.addTriggerEventBypass('testHasTriggersEventBypassEnabled', 'AFTER_INSERT');
        System.assertEquals(true, APU002_Context.hasTriggersEventBypassEnabled('testHasTriggersEventBypassEnabled', 'AFTER_INSERT'));
        APU002_Context.removeTriggerEventBypass('testHasTriggersEventBypassEnabled', 'AFTER_INSERT');
        System.assertEquals(false, APU002_Context.hasTriggersEventBypassEnabled('testHasTriggersEventBypassEnabled', 'AFTER_INSERT'));
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description Testing removing all bypass
     */
    @isTest
    private static void testRemoveAllTriggersBypass(){
        Test.startTest();
        
        APU002_Context.addTriggerBypass('testRemoveAllTriggersBypass');
        APU002_Context.addTriggerEventBypass('testRemoveAllTriggersBypass', 'AFTER_INSERT');
        
        System.assertEquals(true, APU002_Context.hasTriggersBypassEnabled('testRemoveAllTriggersBypass'));
        System.assertEquals(true, APU002_Context.hasTriggersEventBypassEnabled('testRemoveAllTriggersBypass', 'AFTER_INSERT'));
        
        APU002_Context.removeAllTriggersBypass();
        
        System.assertEquals(false, APU002_Context.hasTriggersBypassEnabled('testRemoveAllTriggersBypass'));
        System.assertEquals(false, APU002_Context.hasTriggersEventBypassEnabled('testRemoveAllTriggersBypass', 'AFTER_INSERT'));
        
        Test.stopTest();
    }
}