/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @description Datas Manager 001 - Instance to manipulate any SObject by providing his API name
 */
public inherited sharing class DM001_SObjectInstance extends DM000_SObject implements ITF001_DataManager{

    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Constructor to instanciate a dataManager for a SObject
     * @param sObjectName API name of the SObject to manipulate
     * @param entityClassName Name of the class that instanciate the dataManager
     * @return N/A
     */
    public DM001_SObjectInstance(String sObjectName, String entityClassName){
        super(sObjectName, entityClassName);
    }
}