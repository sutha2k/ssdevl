/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @date 17/02/2021 - Fix cache issues when no sessionId like in Anonymous execution
 * @description APC002_SObjectInfoCache - Cache Builder to retrieve user information and describe schema for an SObject
 */
public inherited sharing class APC002_SObjectInfoCache implements Cache.CacheBuilder{
    
    /* Used to separate userId and sObjectName on a compound string */
    private static final String SEPARATOR = '-';
    /* SObject schema describer */
    private static Schema.DescribeSObjectResult describeResult;

    /**
     * @author Sutharsan Pushparajah
     * @date 17/02/2021
     * @description Load user Info from cache and add SObject schema description
     * @param userIdsObjectKeyPrefix compound id for cache using userId and SObject Key Prefix separated by '-'
     * @return WRP001_UserInfo represents information on user and all SObject accessed during a session
     */
    public static WRP001_UserInfo getUserInfo(String userIdsObjectKeyPrefix) {
        List<String> params = decomposeCacheId(userIdsObjectKeyPrefix);
        String userId = params.get(0);
        String sObjectKeyPrefix = params.get(1);
        Id fakeId = sObjectKeyPrefix + '30000000014c';
        Schema.DescribeSObjectResult dsr = fakeId.getSobjectType().getDescribe();
        String sObjectName = dsr.getName();

        WRP001_UserInfo userInfo = APC001_UserInfoCache.getFromCache(userId);
        userInfo.describeSObjectResult.put(sObjectName, dsr);
        
        return userInfo;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Load user Info from cache and add SObject schema description
     * @param userIdsObjectKeyPrefix compound id for cache using userId and SObject Key Prefix separated by '-'
     * @return WRP001_UserInfo represents information on user and all SObject accessed during a session
     */
    public Object doLoad(String userIdsObjectKeyPrefix) {
        return getUserInfo(userIdsObjectKeyPrefix);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description Build a compound Id for cache based on userId and SObjectName separated by '-'
     * @param userId Id of the user
     * @param sObjectName API name of the SObject
     * @return String represents a compound Id for cache based on userId and SObject Key Prefix separated by '-' in HEX format
     */
    public static String buildCacheId(String userId, String sObjectName){
        String sObjectKeyPrefix = (Schema.describeSObjects(new List<String>{sObjectName})).get(0).getKeyPrefix();
        return EncodingUtil.convertToHex(Blob.valueOf(String.format('{0}{1}{2}', new List<Object>{userId, SEPARATOR, sObjectKeyPrefix})));
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/08/2019
     * @description extract userId and SObject Key Prefix from the compound Id
     * @param cacheId represents the compound key containing UserId and SObject Key Prefix separated by '-' in HEX Format
     * @return List<String> contains userId and SObject Key Prefix
     */
    public static List<String> decomposeCacheId(String cacheId){
        return EncodingUtil.convertFromHex(cacheId).toString().split(SEPARATOR);
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

        if (String.isEmpty(UserInfo.getSessionId())){
            return getUserInfo(buildCacheId(userId, sObjectName));
        }

        return (WRP001_UserInfo) Cache.Session.get(APC002_SObjectInfoCache.class, APC000_CoreSetting.coreSetting.SobjectInfoSessionCache__c+'.'+buildCacheId(userId,sObjectName));
    }
}