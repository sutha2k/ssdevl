/**
 * @author Sutharsan Pushparajah
 * @date 27/08/2019 - SSDL V1.0
 * @description APT001_TriggerEventManager - Default Trigger Event Manager Implementation
 */
public inherited sharing virtual class APT001_TriggerEventManager implements ITF003_TriggerEventManager{
    
    /* Transaction GUID given by trigger manager */
    @testVisible
    public String transactionId;
    
    /**
     * @author Sutharsan Pushparajah
     * @date 27/08/2019
     * @description Trigger Event preparation phase, put especially callout and soql here
     * @return N/A
     */    
    public virtual void prepare(){return;}
    
    /**
     * @author Sutharsan Pushparajah
     * @date 27/08/2019
     * @description Trigger Event process phase, put especially logics upon prepared data
     * @return N/A
     */ 
    public virtual void process(){return;}
    
    /**
     * @author Sutharsan Pushparajah
     * @date 27/08/2019
     * @description Trigger Event finish phase, put especially dml operations and post commit operations
     * @return N/A
     */ 
    public virtual void finish(){return;}
    
    /**
     * @author Sutharsan Pushparajah
     * @date 27/08/2019
     * @description Process Trigger Event
     * @return N/A
     */
    public void execute(String transactionId){
        this.transactionId = transactionId;
        prepare();
        process();
        finish();
    }
}