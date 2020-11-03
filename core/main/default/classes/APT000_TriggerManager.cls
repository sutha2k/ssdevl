/**
 * @author Sutharsan Pushparajah
 * @date 25/11/2016 - First version
 * @date 26/08/2019 - SSDL V1.0
 * @description Apex Trigger Manager 000 - Every Trigger Class must extends this class to inherit standard behaviour
 */
public inherited sharing abstract class APT000_TriggerManager implements ITF002_TriggerManager{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description exception thrown in case of error detected
     */
    public class TriggerManagerException extends Exception{}
    
    //EVERY EXCEPTION MESSAGES
    private static final String EXCEPTION_SOBJECT_REQUIRED = 'SObject Name and trigger class name must be provided, actual={0} - {1}';
    private static final String EXCEPTION_TRIGGER_OPERATION_TYPE_REQUIRED ='Operation type is required';
     
    /* Unique Id for the whole transaction */
    @testVisible
    private static final String TRIGGER_TRANSACTION_GUID = APU002_Context.TRANSACTION_GUID;
    /* Identify package class from local class */
    private static final String LOCAL_NS = 'local.';
    
    /* Define class to instanciate for each SObject trigger event */
    private Map<String, String> overrideOperationsType = new Map<String, String>();
    
    /* SObject to handle */
    @testVisible
    private String theSObjectName;
    /* Trigger that instanciate this class */
    @testVisible
    private String triggerClassName;
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @param sObjectName Current SObject name
     * @param triggerClassName Name of the class that instanciate the triggerManager
     * @description Constructor to instanciate a trigger manager
     */
    public APT000_TriggerManager(String theSObjectName, String triggerClassName){
        APU000_Logger.log(LoggingLevel.DEBUG, triggerClassName, 'Constructor', String.format('Instanciate triggerManager for SObject={0}',new List<Object>{theSObjectName}));
         
        if (String.isEmpty(theSObjectName) || String.isEmpty(triggerClassName)){
            throw new TriggerManagerException(String.format(EXCEPTION_SOBJECT_REQUIRED ,new List<Object>{theSObjectName, triggerClassName}));
        }
        
        this.theSObjectName = theSObjectName;
        this.triggerClassName = triggerClassName;
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 30/08/2019
     * @description Execute common trigger logics and check security before executing trigger event
     * @param currentTriggerEvent trigger event to execute
     * @return ITF003_TriggerEventManager instance of the trigger event manager
     */
    @testVisible
    private ITF003_TriggerEventManager doExecute(String currentTriggerEvent){
    
        if (currentTriggerEvent == null){
            throw new TriggerManagerException(EXCEPTION_TRIGGER_OPERATION_TYPE_REQUIRED);
        }
        
        if (APU002_Context.hasTriggersEventBypassEnabled(triggerClassName, currentTriggerEvent)){
            return null;
        }
        
        String currentTriggerEventDefault = APC000_CoreSetting.coreSetting.CoreTriggerManagerClass__c;
        String currentTriggerEventOverride = overrideOperationsType.get(currentTriggerEvent);
        
        APU002_Context.addRunningTrigger(triggerClassName, currentTriggerEvent);
        
        ITF003_TriggerEventManager eventManager = null;
        
        if (currentTriggerEventOverride != null){
            eventManager = (ITF003_TriggerEventManager)Type.ForName('', currentTriggerEventOverride).newInstance();
        } else {
            if (currentTriggerEventDefault.startsWith(LOCAL_NS)){
                eventManager = (ITF003_TriggerEventManager)Type.ForName('', currentTriggerEventDefault.substringAfter(LOCAL_NS)).newInstance();
            } else {
                eventManager = (ITF003_TriggerEventManager)Type.ForName(currentTriggerEventDefault).newInstance();
            }
           
        }
        
        eventManager.execute(TRIGGER_TRANSACTION_GUID);
        
        APU002_Context.removeRunningTrigger(triggerClassName, currentTriggerEvent);
        
        return eventManager;
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description Execute common trigger logics and check security before executing trigger event
     * @return N/A
     */
    public void execute(){
        doExecute((Trigger.operationType != null)?String.valueOf(Trigger.operationType):null);
        doFinish();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @description Execute a kind of post commit action based on transaction static variables
     * @return N/A
     */
    private void doFinish(){
        if (Trigger.isAfter && !APU002_Context.isTriggerStillRunning()){
            return; //for future implementation
        }
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 26/08/2019
     * @param overrideEvents Map containing trigger operation name as key and class to instantiate as value
     * @description override core trigger event implementation by custom implementation
     * @return N/A
     */
    public void overrideTriggerEvent(Map<String, String> overrideEvents){
        overrideOperationsType.putAll(overrideEvents);
    }
}