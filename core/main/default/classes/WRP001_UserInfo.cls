/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @description WRP001_UserInfo - Wrapper representing user information and accessible sobject description
 */
public inherited sharing class WRP001_UserInfo{
    /* Current user */
    public User user;
    /* Schema SObject Description */
    public Map<String, Id> describeSObjectResult;
    
   /**
    * @author Sutharsan Pushparajah
    * @date 19/08/2019
    * @description constructor to instantiate user and schema information
    * @param user current user
    * @param schemaMap Schema description
    */
    public WRP001_UserInfo(User user){
        this.user = user;
        describeSObjectResult = new Map<String, Id>();
    }
}