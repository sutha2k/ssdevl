/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @description APC001_UserInfoCache - Cache Builder to retrieve user information and describe schema
 */
public inherited sharing class APC001_UserInfoCache implements Cache.CacheBuilder{
        
    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Load user from cache and get schema information
     * @param userId Id of the user to load from cache
     * @return WRP001_UserInfo represents information to get from cache by using userId
     */
    public Object doLoad(String userId) {
        User user = (User)[SELECT Id, Name, IsActive, Username, ProfileId, UserRoleId FROM User WHERE id = :userid];
        WRP001_UserInfo wrp = new WRP001_UserInfo(user, Schema.getGlobalDescribe()); 

        return wrp;
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 21/08/2019
     * @description get the user info from cache for this userId
     * @param userId id of the user in cache
     * @return WRP001_UserInfo represents the user Info in cache for this userId
     */
    public static WRP001_UserInfo getFromCache(String userId){
        return (WRP001_UserInfo) Cache.Session.get(APC001_UserInfoCache.class, APC000_CoreSetting.coreSetting.UserInfoSessionCache__c+'.'+userId);
    }
}