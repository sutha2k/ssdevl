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

    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Testing running triggers
     */
    @isTest
    private static void testRunningTriggers(){
        Test.startTest();

        System.assertEquals(false, APU002_Context.isTriggerStillRunning());
        APU002_Context.addRunningTrigger('test','test');
        System.assertEquals(true, APU002_Context.isTriggerInitiated);
        System.assertEquals(false, APU002_Context.stopRecursion('test','test'));
        System.assertEquals(true, APU002_Context.isTriggerStillRunning());

        for (Integer cpt=0;cpt<6;cpt++){
            System.assertEquals(false, APU002_Context.stopRecursion('test','test'));
            APU002_Context.addRunningTrigger('test','test');
            System.assertEquals(true, APU002_Context.isTriggerStillRunning());
        }
        System.assertEquals(true, APU002_Context.stopRecursion('test','test'));

        for (Integer cpt=0;cpt<7;cpt++){
            System.assertEquals(true, APU002_Context.isTriggerStillRunning());
            APU002_Context.removeRunningTrigger('test','test');
            System.assertEquals(false, APU002_Context.stopRecursion('test','test'));
        }

        System.assertEquals(false, APU002_Context.isTriggerStillRunning());

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 26/03/2021
     * @description Testing features permissions
     */
    @isTest
    private static void testFeaturesPermissions(){
        Test.startTest();

        System.assertEquals(true, APU002_Context.isWithSchemaDescriber());
        System.assertEquals(true, APU002_Context.isWithSecurityEnforced());
        System.assertEquals(true, APU002_Context.isWithStripInaccessible());
        System.assertEquals(true, APU002_Context.isLoggingEnabled());
        System.assertEquals(true, APU002_Context.isLoggingEventEnabled());
        System.assertEquals(true, APU002_Context.isCalloutTrackingEnabled());

        Test.stopTest();
    }
}