/**
 * @author Sutharsan Pushparajah
 * @date 22/08/2019 - SSDL V1.0
 * @description Test class for APC002_SObjectInfoCache
 */
@isTest
private class APC002_SObjectInfoCache_TEST{

    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing creating a cacheId for user and SObject
     */
    @isTest
    private static void testBuildCacheId(){
        Test.startTest();
        
        String cacheId = APC002_SObjectInfoCache.buildCacheId('123456', 'SObjectName');
        System.assertEquals('123456-SObjectName', cacheId);
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing getting userId and SObjectName from cacheId
     */
    @isTest
    private static void testDecomposeCacheId(){
        Test.startTest();
        
        List<String> cacheId = APC002_SObjectInfoCache.decomposeCacheId('123456-SObjectName');
        System.assertEquals('123456', cacheId.get(0));
        System.assertEquals('SObjectName', cacheId.get(1));
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing getting user and schema information from cache
     */
    @isTest
    private static void testGetFromCache(){
        Id userId = UserInfo.getUserId();
        String sObjectName = SObjectType.SampleForTest__c.Name;
        
        Test.startTest();
        
        WRP001_UserInfo userInfo = APC002_SObjectInfoCache.getFromCache(userId, sObjectName);
        System.assertNotEquals(null, userInfo);
        System.assertEquals(userId, userInfo.user.Id);
        System.assertNotEquals(null, userInfo.schemaMap);
        
        Map<String, Schema.DescribeSObjectResult> describer = userInfo.describeSObjectResult;
        System.assertNotEquals(null, describer);
        
        Schema.DescribeSObjectResult result = describer.get(sObjectName);
        System.assertNotequals(null, result);
        System.assertequals(sObjectName, result.getName());   
        
        Test.stopTest();
    }
}