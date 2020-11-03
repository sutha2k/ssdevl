/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @description WRP001_UserInfo - Wrapper representing user information and accessible sobject description
 */
public inherited sharing class WRP001_UserInfo{
    /* Current user */
    public User user;
    /* Schema Global Description */
    public Map<String, Schema.SObjectType> schemaMap;
    /* Schema SObject Description */
    public Map<String, Schema.DescribeSObjectResult> describeSObjectResult;
    
   /**
    * @author Sutharsan Pushparajah
    * @date 19/08/2019
    * @description constructor to instantiate user and schema information
    * @param user current user
    * @param schemaMap Schema description
    */
    public WRP001_UserInfo(User user, Map<String, Schema.SObjectType> schemaMap){
        this.user = user;
        this.schemaMap = schemaMap;
        describeSObjectResult = new Map<String, Schema.DescribeSObjectResult>();
    }
}