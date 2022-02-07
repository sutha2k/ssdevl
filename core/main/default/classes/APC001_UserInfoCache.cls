/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @date 17/02/2021 - Fix cache issues when no sessionId like in Anonymous execution
 * @description APC001_UserInfoCache - Cache Builder to retrieve user information and describe schema
 */
public inherited sharing class APC001_UserInfoCache implements Cache.CacheBuilder{
     
    /* Schema describer */
    private static Map<String, Schema.SObjectType> globalDescribe;
    /* Contextual user */
    private static User user;

    /**
     * @author Sutharsan Pushparajah
     * @date 17/02/2021
     * @description get minimal info on running user
     * @param userId Id of the user to load from cache
     * @return WRP001_UserInfo represents information to get from database by using userId
     */
    public static WRP001_UserInfo getUserInfo(String userId) {
        
        if (user == null || globalDescribe == null){
            //REMOVING Security check to handle community user who do not have permisisons
            APC001_UserInfoCache.user = (User)[SELECT Id, Name, IsActive, Username, ProfileId, UserRoleId FROM User WHERE id = :userid /*WITH SECURITY_ENFORCED*/];
            APC001_UserInfoCache.globalDescribe = Schema.getGlobalDescribe();
        }
        
        WRP001_UserInfo wrp = new WRP001_UserInfo(APC001_UserInfoCache.user, APC001_UserInfoCache.globalDescribe); 

        return wrp;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Load user from cache and get schema information
     * @param userId Id of the user to load from cache
     * @return WRP001_UserInfo represents information to get from cache by using userId
     */
    public Object doLoad(String userId) {
        return getUserInfo(userId);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 21/08/2019
     * @description get the user info from cache for this userId
     * @param userId id of the user in cache
     * @return WRP001_UserInfo represents the user Info in cache for this userId
     */
    public static WRP001_UserInfo getFromCache(String userId){

        if (String.isEmpty(UserInfo.getSessionId())){
            return getUserInfo(userId);
        }

        return (WRP001_UserInfo) Cache.Session.get(APC001_UserInfoCache.class, APC000_CoreSetting.coreSetting.UserInfoSessionCache__c+'.'+userId);
    }
}