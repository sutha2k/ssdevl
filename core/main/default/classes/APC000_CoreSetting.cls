/**
 * @author Sutharsan Pushparajah
 * @date 27/08/2019 - SSDL V1.0
 * @date 17/02/2021 - Adding StripInaccessible feature
 * @description APC000_CoreSetting - Core Setting Custom Metadata Type to retrieve framework settings
 */
public inherited sharing class APC000_CoreSetting{
    
    /* default core setting for the framework */
    public static CoreSetting__mdt coreSetting;
    static {
        String orgId = UserInfo.getOrganizationId();
        Schema.DescribeSObjectResult describer = CoreSetting__mdt.SObjectType.getDescribe();

        if (describer.isAccessible() && describer.isQueryAble()){
            List<CoreSetting__mdt> coreSettingList = [select BypassAllTriggerPermission__c, CoreSetting__mdt.DeveloperName,
                                                            CoreTriggerManagerClass__c, IsActive__c, IsDefault__c, 
                                                            LoggingEnabled__c, OrgId__c, RecursionLevel__c,
                                                            SobjectInfoSessionCache__c, UserInfoSessionCache__c,
                                                            WithSecurityEnforced__c, WithStripInaccessible__c, WithSchemaDescriber__c
                                                            from CoreSetting__mdt 
                                                            where IsActive__c = true WITH SECURiTY_ENFORCED];

            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, coreSettingList);
            coreSettingList = ( List<CoreSetting__mdt>) decision.getRecords();

            for (CoreSetting__mdt cs : coreSettingList){
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
        }
    }
}