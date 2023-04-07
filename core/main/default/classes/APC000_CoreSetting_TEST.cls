/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @date 07/04/2023 - api version 57.0
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
        
        Assert.isNotNull(APC000_CoreSetting.coreSetting, 'Must not be null');
        Assert.areEqual(expectedMockCoreSetting, APC000_CoreSetting.coreSetting.DeveloperName, 'Must not be null');
        Assert.areEqual('BP_ALL_TRIGGERS', APC000_CoreSetting.coreSetting.BypassAllTriggerPermission__c, 'This custom permission was expected');
        Assert.areEqual('APT001_TriggerEventManager', APC000_CoreSetting.coreSetting.CoreTriggerManagerClass__c, 'This class was expected');
        Assert.isTrue(APC000_CoreSetting.coreSetting.IsActive__c, 'CoreSetting must be active');
        Assert.isFalse(APC000_CoreSetting.coreSetting.IsDefault__c, 'This CoreSetting mus not be the default one');
        Assert.areEqual('Test Context', APC000_CoreSetting.coreSetting.OrgId__c, 'OrgId must be specified expect in test context');
        Assert.areEqual(7, APC000_CoreSetting.coreSetting.RecursionLevel__c, 'This recursion level is the maximum expected');
        Assert.areEqual('local.UserInfoCache', APC000_CoreSetting.coreSetting.SobjectInfoSessionCache__c, 'This cache partition is expexted');
        Assert.areEqual('local.UserInfoCache', APC000_CoreSetting.coreSetting.UserInfoSessionCache__c, 'This cache partition is expected');
        Assert.isTrue(APC000_CoreSetting.coreSetting.WithSecurityEnforced__c, 'This security setting must be enforced');
        Assert.isTrue(APC000_CoreSetting.coreSetting.WithStripInaccessible__c, 'This security setting must be enforced');
        Assert.isTrue(APC000_CoreSetting.coreSetting.WithSchemaDescriber__c, 'This security setting must be enforced');
        Assert.areEqual('BP_SCHEMA_DESCRIBER', APC000_CoreSetting.coreSetting.BypassSchemaDescriberPermission__c, 'This custom permission was expected');
        Assert.areEqual('BP_STRIPINACCESSIBLE', APC000_CoreSetting.coreSetting.BypassStripinaccessiblePermission__c, 'This custom permission was expected');
        Assert.areEqual('BP_SECURITY_ENFORCED', APC000_CoreSetting.coreSetting.BypassWithSecurityPermission__c, 'This custom permission was expected');
        Assert.isTrue(APC000_CoreSetting.coreSetting.LoggingEnabled__c, 'This logging feature must be enabled');
        Assert.areEqual('EN_LOGGING', APC000_CoreSetting.coreSetting.EnableLoggingPermission__c, 'This custom permission was expected');
        Assert.isTrue(APC000_CoreSetting.coreSetting.LoggingEventEnabled__c, 'This event logging feature must be enabled');
        Assert.areEqual('EN_LOGGING_EVENT', APC000_CoreSetting.coreSetting.EnableLoggingEventPermission__c, 'This custom permission was expected');
        Assert.isTrue(APC000_CoreSetting.coreSetting.CalloutTrackingEnabled__c, 'This callout Tracking feature must nbe enabled');
        Assert.areEqual('EN_CALLOUT_TRACKING', APC000_CoreSetting.coreSetting.EnableCalloutTrackingPermission__c, 'This custom permission was expected');

        Test.stopTest();
    }
}