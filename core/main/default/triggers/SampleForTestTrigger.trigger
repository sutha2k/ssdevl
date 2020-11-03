/**
 * @author Sutharsan Pushparajah
 * @date 05/07/2019 - SSDL V1.0
 * @description SampleForTestTrigger - Trigger for testing purpose on SampleForTest__c
 */
trigger SampleForTestTrigger on SampleForTest__c (before insert) {
    ITF002_TriggerManager triggerManager = new APT002_SObjectInstance(SObjectType.SampleForTest__c.Name, 'SampleForTestTrigger');
    triggerManager.execute();
}