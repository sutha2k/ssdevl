/**
 * @author Sutharsan Pushparajah
 * @date 25/11/2016 - First version
 * @date 26/08/2019 - SSDL V1.0
 * @description ITF002_TriggerManager - Interface for APT000_TriggerManager
 */
public interface ITF002_TriggerManager{
    void execute();
    void overrideTriggerEvent(Map<String, String> overrideEvents);
}