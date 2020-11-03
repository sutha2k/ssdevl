/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @description APC002_SObjectInfoCache - Cache Builder to retrieve user information and describe schema for an SObject
 */
public inherited sharing class APC002_SObjectInfoCache implements Cache.CacheBuilder{
    
    /* Used to separate userId and sObjectName on a compound string */
    private static final String SEPARATOR = '-';
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Load user Info from cache and add SObject schema description
     * @param userIdsObjectName compound id for cache using userId and SObjectName separated by '-'
     * @return WRP001_UserInfo represents information on user and all SObject accessed during a session
     */
    public Object doLoad(String userIdsObjectName) {
        List<String> params = decomposeCacheId(userIdsObjectName);
        String userId = params.get(0);
        String sObjectName = params.get(1);
        WRP001_UserInfo userInfo = APC001_UserInfoCache.getFromCache(userId);
        userInfo.describeSObjectResult.put(sObjectName, userInfo.schemaMap.get(sObjectName).getDescribe());
        
        return userInfo;
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Build a compound Id for cache based on userId and SObjectName separated by '-'
     * @param userId Id of the user
     * @param sObjectName API name of the SObject
     * @return String represents a compound Id for cache based on userId and SObjectName separated by '-'
     */
    public static String buildCacheId(String userId, String sObjectName){
        return String.format('{0}{1}{2}', new List<Object>{userId, SEPARATOR, sObjectName});
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description extract userId and SObjectName from the compound Id
     * @param cacheId represents the compound key containing UserId and SObjectName separated by '-'
     * @return List<String> contains userId and SObjectName
     */
    public static List<String> decomposeCacheId(String cacheId){
        return cacheId.split(SEPARATOR);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 21/08/2019
     * @description get the user & schema info from cache for this userId and SObject
     * @param userId id of the user in cache
     * @param sObjectName name of the SObject to describe
     * @return WRP001_UserInfo represents the user Info in cache for this userId and SObject
     */
    public static WRP001_UserInfo getFromCache(String userId, String sObjectName){
        return (WRP001_UserInfo) Cache.Session.get(APC002_SObjectInfoCache.class, APC000_CoreSetting.coreSetting.SobjectInfoSessionCache__c+'.'+buildCacheId(userId,sObjectName));
    }
}