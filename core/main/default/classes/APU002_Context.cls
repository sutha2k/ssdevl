/**
 * @author Sutharsan Pushparajah
 * @date 23/11/2016 - First version
 * @date 26/08/2019 - SSDL V1.0
 * @description APU002_Context - Utility to set/unset context variables
 */
public inherited sharing class APU002_Context{

    /* Unique Id for the whole transaction */
    public static final String TRANSACTION_GUID = APU001_Crypto.generateGUID();
    
    /* Must use this prefix for any Custom Permission on trigger */
    private static final String BYPASS_PREFIX = 'BP_';
    /* Separator used between classname and eventname */
    private static final String SEPARATOR = '_';
    
    /* Boolean to bypass all triggers. */
    public static Boolean contextualBypassAllTriggers = false;
    /* Number of contextual programmatic recursion alowed */
    public static Integer contextualRecursionLevel = null;
    /* Is the transaction initiated by trigger. */
    public static Boolean isTriggerInitiated = false;
    /* Is the transaction initiated by process. */
    public static Boolean isProcessInitiated = false;
    /* Contains Trigger Class Name or Trigger Event Name to bypass on the fly */
    private static Set<String> contextualBypassSpecificTriggers = new Set<String>();
    /* Count running triggers event instance */
    private static Map<String, Integer> runningTriggers = new Map<String, Integer>();
    
    /**
     * @author Sutharsan Pushparajah
     * @date 28/08/2019
     * @description check if all triggers are bypassable
     * @return Boolean true to bypass all, false to proceed 
     */
     @testVisible
    private static Boolean hasTriggersBypassAllEnabled(){
        return (FeatureManagement.checkPermission(APC000_CoreSetting.coreSetting.BypassAllTriggerPermission__c)
        || contextualBypassAllTriggers == true);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description check if current trigger is bypassable
     * @param triggerClassName name of the trigger implementation class
     * @return Boolean true if bypassable 
     */
    public static Boolean hasTriggersBypassEnabled(String triggerClassName){
        return (hasTriggersBypassAllEnabled()
        || FeatureManagement.checkPermission(BYPASS_PREFIX+triggerClassName)
        || contextualBypassSpecificTriggers.contains(BYPASS_PREFIX+triggerClassName)
        );
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description check if all triggers are bypassable
     * @param triggerClassName name of the trigger implementation class
     * @param eventName name of the the trigger event
     * @return Boolean true if bypassable 
     */
    public static Boolean hasTriggersEventBypassEnabled(String triggerClassName, String eventName){
        return (hasTriggersBypassEnabled(triggerClassName)
        || FeatureManagement.checkPermission(BYPASS_PREFIX+triggerClassName+SEPARATOR+eventName)
        || contextualBypassSpecificTriggers.contains(BYPASS_PREFIX+triggerClassName+SEPARATOR+eventName)
        || stopRecursion(triggerClassName, eventName)
        );
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description add trigger bypass on the fly
     * @param triggerClassName name of the trigger implementation class
     * @return N/A 
     */
    public static void addTriggerBypass(String triggerClassName){
        contextualBypassSpecificTriggers.add(BYPASS_PREFIX+triggerClassName);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description add trigger event bypass on the fly
     * @param triggerClassName name of the trigger implementation class
     * @param eventName name of the the trigger event
     * @return N/A 
     */
    public static void addTriggerEventBypass(String triggerClassName, String eventName){
        contextualBypassSpecificTriggers.add(BYPASS_PREFIX+triggerClassName+SEPARATOR+eventName);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description remove trigger bypass on the fly
     * @param triggerClassName name of the trigger implementation class
     * @return N/A 
     */
    public static void removeTriggerBypass(String triggerClassName){
        contextualBypassSpecificTriggers.remove(BYPASS_PREFIX+triggerClassName);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description remove trigger event bypass on the fly
     * @param triggerClassName name of the trigger implementation class
     * @param eventName name of the trigger event
     * @return N/A 
     */
    public static void removeTriggerEventBypass(String triggerClassName, String eventName){
        contextualBypassSpecificTriggers.remove(BYPASS_PREFIX+triggerClassName+SEPARATOR+eventName);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description remove All trigger bypass on the fly
     * @return N/A 
     */
    public static void removeAllTriggersBypass(){
        contextualBypassSpecificTriggers.clear();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 05/11/2019
     * @description add running trigger
     * @param triggerClassName name of the trigger implementation class
     * @param eventName name of the trigger event 
     * @return N/A 
     */
    public static void addRunningTrigger(String triggerClassName, String eventName){
        String triggerEventName = triggerClassName+SEPARATOR+eventName;
        Integer countRunning = runningTriggers.get(triggerEventName);
        
        if (countRunning == null){
            countRunning = 1;
        } else {
            countRunning = countRunning + 1;
        }
        
        runningTriggers.put(triggerEventName, countRunning);
        isTriggerInitiated = (isProcessInitiated?false:true);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 05/11/2019
     * @description remove running trigger
     * @param triggerClassName name of the trigger implementation class
     * @param eventName name of the trigger event 
     * @return N/A 
     */
    public static void removeRunningTrigger(String triggerClassName, String eventName){
        String triggerEventName = triggerClassName+SEPARATOR+eventName;
        Integer countRunning = runningTriggers.get(triggerEventName);
        
        if (countRunning != null){
            countRunning = countRunning - 1;
            
            if (countRunning <= 0){
                runningTriggers.remove(triggerEventName);
            } else {
                runningTriggers.put(triggerEventName, countRunning);
            }
        }
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 05/11/2019
     * @description Bypass trigger when recursion threshold is reached 
     * @param triggerClassName name of the trigger implementation class
     * @param eventName name of the trigger event 
     * @return Boolean true to bypass, false to proceed 
     */
    private static Boolean stopRecursion(String triggerClassName, String eventName){
        
        if (APC000_CoreSetting.coreSetting.RecursionLevel__c != null || contextualRecursionLevel != null){
            String triggerEventName = triggerClassName+SEPARATOR+eventName;
            Integer countRunning = runningTriggers.get(triggerEventName);
            Integer allowedRecursionLevel = (contextualRecursionLevel != null?contextualRecursionLevel:(Integer)APC000_CoreSetting.coreSetting.RecursionLevel__c);
            
            return (countRunning != null && countRunning >= allowedRecursionLevel);            
        }
        
        return false;
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 06/11/2019
     * @description Check if there are Triggers running in same transaction  
     * @return Boolean true if has remaining triggers in transaction
     */
    public static Boolean isTriggerStillRunning(){
        return !runningTriggers.isEmpty();
    }
}