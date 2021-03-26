/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @description Test class for APT000_TriggerManager
 */
@isTest
private class APT000_TriggerManager_TEST{
    
   /**
    * @author Sutharsan Pushparajah
    * @date 30/08/2019
    * @description TriggerEventManager for test purpose
    */
    public inherited sharing class APT100_SObjectInstance_BeforeInsert extends APT001_TriggerEventManager{
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 30/08/2019
     * @description Testing creating an instance of triggermanager
     */
    @isTest
    private static void testConstructor(){
        Test.startTest();
        
        ITF002_TriggerManager triggermanager;
        Boolean hasErrors = false;
        String message;
        
        //USE CASE 01 - BOTH SObjectName and triggerClassName are not provided
        try {
            triggermanager = new APT002_SObjectInstance(null, null);
        } catch(APT000_TriggerManager.TriggerManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('SObject Name and trigger class name must be provided, actual=null - null', message);
        
        //USE CASE 02 - Only SObjectName is provided
        message = null;
        hasErrors = false;
        String sObjectName = SObjectType.SampleForTest__c.Name;
        
        try {
            triggermanager = new APT002_SObjectInstance(sObjectName, null);
        } catch(APT000_TriggerManager.TriggerManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('SObject Name and trigger class name must be provided, actual='+sObjectName+' - null', message);
        
         //USE CASE 04 - Only triggerClassName is provided
        message = null;
        hasErrors = false;
        String triggerClassName = 'SampleForTestTrigger';
        
        try {
            triggermanager = new APT002_SObjectInstance(null, triggerClassName);
        } catch(APT000_TriggerManager.TriggerManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('SObject Name and trigger class name must be provided, actual=null - '+triggerClassName, message);
        
        //USE CASE 04 - BOTH SObjectName and triggerClassName are provided
        message = null;
        hasErrors = false;
        
        triggermanager = new APT002_SObjectInstance(sObjectName, triggerClassName);
        System.assertNotequals(null, triggermanager);
        System.assertEquals(sObjectName, ((APT000_TriggerManager)triggermanager).theSObjectName);
        System.assertEquals(triggerClassName, ((APT000_TriggerManager)triggermanager).triggerClassName);
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 30/08/2019
     * @description Testing execution of triggermanager
     */
    @isTest
    private static void testExecute(){
        String triggerClassName = 'SampleForTestTrigger';
        String sObjectName = SObjectType.SampleForTest__c.Name;
        String eventName = 'BEFORE_INSERT';
        Boolean hasErrors = false;
        String errorMessage;
        
        Test.startTest();
        
        ITF002_TriggerManager triggermanager = new APT002_SObjectInstance(sObjectName, triggerClassName);
        
        APU002_Context.addTriggerEventBypass(triggerClassName, eventName);
        ITF003_TriggerEventManager triggerEventManager = ((APT000_TriggerManager)triggerManager).doExecute(eventName);
        System.assertEquals(null, triggerEventManager);
        APU002_Context.removeTriggerEventBypass(triggerClassName, eventName);
        
        triggerEventManager = ((APT000_TriggerManager)triggerManager).doExecute(eventName);
        System.assertNotEquals(null, triggerEventManager);
        System.assertEquals(true, triggerEventManager instanceof APT001_TriggerEventManager);
        System.assertEquals(APT000_TriggerManager.TRIGGER_TRANSACTION_GUID, ((APT001_TriggerEventManager)triggerEventManager).transactionId);
        
        try{
            triggermanager.execute();
        } catch(APT000_TriggerManager.TriggerManagerException exp){
            hasErrors = true;
            errorMessage = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Operation type is required', errorMessage);
        
        triggermanager.overrideTriggerEvent(new Map<String, String>{'BEFORE_INSERT' => 'APT000_TriggerManager_TEST.APT100_SObjectInstance_BeforeInsert'});
        triggerEventManager = ((APT000_TriggerManager)triggerManager).doExecute(eventName);
        System.assertEquals(true, triggerEventManager instanceof APT000_TriggerManager_TEST.APT100_SObjectInstance_BeforeInsert);
        
        Test.stopTest();
    }
}