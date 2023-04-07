/**
 * @author Sutharsan Pushparajah
 * @date 27/08/2019 - SSDL V1.0
 * @date 17/02/2021 - Adding StripInaccessible feature
 * @date 26/03/2021 - Mock Core Setting
 * @description APC000_CoreSetting - Core Setting Custom Metadata Type to retrieve framework settings
 */
public inherited sharing class APC000_CoreSetting{
    
    /* mock core setting : do not change values as it used in Test class */
    private static final String MOCK_CORE_SETTING = 'MockCoreSettings';
    /* default core setting for the framework */
    public static CoreSetting__mdt coreSetting;

    static {
        CoreSetting__mdt mockCoreSetting;
        String orgId = UserInfo.getOrganizationId();
        
        List<CoreSetting__mdt> coreSettingList = new List<CoreSetting__mdt>([select BypassAllTriggerPermission__c, DeveloperName,
                                                    CoreTriggerManagerClass__c, IsActive__c, IsDefault__c, 
                                                    OrgId__c, RecursionLevel__c,
                                                    SobjectInfoSessionCache__c, UserInfoSessionCache__c,
                                                    WithSecurityEnforced__c, WithStripInaccessible__c, WithSchemaDescriber__c,
                                                    BypassSchemaDescriberPermission__c, BypassStripinaccessiblePermission__c, BypassWithSecurityPermission__c,
                                                    LoggingEnabled__c, EnableLoggingPermission__c, LoggingEventEnabled__c, EnableLoggingEventPermission__c, 
                                                    CalloutTrackingEnabled__c, EnableCalloutTrackingPermission__c
                                                    from CoreSetting__mdt 
                                                    where IsActive__c = true WITH SYSTEM_MODE]);

        for (CoreSetting__mdt cs : coreSettingList){
            if (cs.DeveloperName == MOCK_CORE_SETTING){
                mockCoreSetting = cs;
            }

            if (cs.IsActive__c){
                if (orgId == cs.orgId__c){
                    coreSetting = cs;
                    break;
                } else if (cs.IsDefault__c){
                    //Keep the default one if setting is not found for current org 
                    coreSetting = cs;
                }
            }
        }

        //To validate test unit, we replace the core setting with the one used in test context and ensure that previous lines are covered
        if (Test.isRunningTest()){
            coreSetting = mockCoreSetting;
        }
    }
}