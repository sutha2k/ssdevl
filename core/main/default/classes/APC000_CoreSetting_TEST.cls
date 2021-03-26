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
        String expectedMockCoreSetting = 'MockCoreSettings';

        Test.startTest();
        
        System.assertNotEquals(null, APC000_CoreSetting.coreSetting, 'Must not be null');
        System.assertEquals(expectedMockCoreSetting, APC000_CoreSetting.coreSetting.DeveloperName, 'Must not be null');
        System.assertEquals('BP_ALL_TRIGGERS', APC000_CoreSetting.coreSetting.BypassAllTriggerPermission__c, '');
        System.assertEquals('APT001_TriggerEventManager', APC000_CoreSetting.coreSetting.CoreTriggerManagerClass__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.IsActive__c, '');
        System.assertEquals(false, APC000_CoreSetting.coreSetting.IsDefault__c, '');
        System.assertEquals('Test Context', APC000_CoreSetting.coreSetting.OrgId__c, '');
        System.assertEquals(7, APC000_CoreSetting.coreSetting.RecursionLevel__c, '');
        System.assertEquals('local.UserInfoCache', APC000_CoreSetting.coreSetting.SobjectInfoSessionCache__c, '');
        System.assertEquals('local.UserInfoCache', APC000_CoreSetting.coreSetting.UserInfoSessionCache__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.WithSecurityEnforced__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.WithStripInaccessible__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.WithSchemaDescriber__c, '');
        System.assertEquals('BP_SCHEMA_DESCRIBER', APC000_CoreSetting.coreSetting.BypassSchemaDescriberPermission__c, '');
        System.assertEquals('BP_STRIPINACCESSIBLE', APC000_CoreSetting.coreSetting.BypassStripinaccessiblePermission__c, '');
        System.assertEquals('BP_SECURITY_ENFORCED', APC000_CoreSetting.coreSetting.BypassWithSecurityPermission__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.LoggingEnabled__c, '');
        System.assertEquals('EN_LOGGING', APC000_CoreSetting.coreSetting.EnableLoggingPermission__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.LoggingEventEnabled__c, '');
        System.assertEquals('EN_LOGGING_EVENT', APC000_CoreSetting.coreSetting.EnableLoggingEventPermission__c, '');
        System.assertEquals(true, APC000_CoreSetting.coreSetting.CalloutTrackingEnabled__c, '');
        System.assertEquals('EN_CALLOUT_TRACKING', APC000_CoreSetting.coreSetting.EnableCalloutTrackingPermission__c, '');

        Test.stopTest();
    }
}