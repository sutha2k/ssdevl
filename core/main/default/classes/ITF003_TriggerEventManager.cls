/**
 * @author Sutharsan Pushparajah
 * @date 26/08/2019 - SSDL V1.0
 * @description ITF003_TriggerEventManager - Interface for trigger events
 */
public interface ITF003_TriggerEventManager{
    void prepare();
    void process();
    void finish();
    void execute(String transactionId);
}