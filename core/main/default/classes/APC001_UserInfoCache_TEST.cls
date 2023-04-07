/**
 * @author Sutharsan Pushparajah
 * @date 22/08/2019 - SSDL V1.0
 * @description Test class for APC001_UserInfoCache
 */
@isTest
private class APC001_UserInfoCache_TEST{
   
    /**
     * @author Sutharsan Pushparajah
     * @date 13/012/2022
     * @description Testing getting User with doLoad
     */
    @isTest
    private static void testDoLoad(){
        
        Test.startTest();
        
        Id userId = UserInfo.getUserId();
        
        APC001_UserInfoCache infoCache = new APC001_UserInfoCache();
        WRP001_UserInfo userInfo = (WRP001_UserInfo) infoCache.doLoad(userId);
        System.assertNotEquals(null, userInfo, 'Must not be null');
        System.assertEquals(userId, userInfo.user.Id, 'Must be the same Id');
        System.assertNotEquals(null, userInfo.describeSObjectResult, 'Must not be null');
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 13/012/2022
     * @description Testing getting User with getUserInfo
     */
    @isTest
    private static void testGetUserInfo(){
        
        Test.startTest();
        
        Id userId = UserInfo.getUserId();
        
        WRP001_UserInfo userInfo = APC001_UserInfoCache.getUserInfo(userId);
        System.assertNotEquals(null, userInfo, 'Must not be null');
        System.assertEquals(userId, userInfo.user.Id, 'Must be the same Id');
        System.assertNotEquals(null, userInfo.describeSObjectResult, 'Must not be null');
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing getting user info from cache
     */
    @isTest
    private static void testGetFromCache(){
        Test.startTest();
        
        Id userId = UserInfo.getUserId();
        
        WRP001_UserInfo userInfo = APC001_UserInfoCache.getFromCache(userId);
        System.assertNotEquals(null, userInfo, 'Must not be null');
        System.assertEquals(userId, userInfo.user.Id, 'Must be the same Id');
        System.assertNotEquals(null, userInfo.describeSObjectResult, 'Must not be null');
        
        Test.stopTest();
    }
}