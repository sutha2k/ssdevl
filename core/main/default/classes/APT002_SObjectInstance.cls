/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @description APT002_SObjectInstance - Instance to manipulate trigger on any SObject by providing his API name
 */
public inherited sharing class APT002_SObjectInstance extends APT000_TriggerManager{

    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description Constructor to instanciate a triggerManager for a SObject
     * @param sObjectName API name of the SObject to manipulate
     * @param triggerClassName Name of the class, used to check permissions (ex: AccountTrigger)
     * @return N/A
     */
    public APT002_SObjectInstance(String sObjectName, String triggerClassName){
        super(sObjectName, triggerClassName);
    }
}