/**
 * @author Sutharsan Pushparajah
 * @date 23/08/2019 - SSDL V1.0
 * @description Test class for DM001_SObjectInstance
 */
@isTest
private class DM001_SObjectInstance_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/08/2019
     * @description test instanciation of datamanager for SObject
     */
    @isTest
    private static void testConstructor(){
        Test.startTest();
        
        String sObjectName = SObjectType.SampleForTest__c.Name;
        ITF001_DataManager datamanager = new DM001_SObjectInstance(sObjectName, 'DM001_SObjectInstance_TEST');
        System.assertNotEquals(null, datamanager);
        Schema.DescribeSObjectResult describer = ((DM001_SObjectInstance)datamanager).describeResult;
        System.assertNotEquals(null, describer);
        System.assertEquals(sObjectName, describer.getName());
        
        Test.stopTest();   
    }
}