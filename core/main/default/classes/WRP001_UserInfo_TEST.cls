/**
 * @author Sutharsan Pushparajah
 * @date 22/08/2019 - SSDL V1.0
 * @description Test class for WRP001_UserInfo
 */
@isTest
private class WRP001_UserInfo_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing instanciation of the constructor
     */
    @isTest
    private static void testConstructor(){
    
        User user = [select Id, Name from User where id=:UserInfo.getUserId()];
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        Test.startTest();
        
        WRP001_UserInfo userInfo = new WRP001_UserInfo(user);
        
        System.assertEquals(user.Id, userInfo.user.Id);
        System.assertNotEquals(null, userInfo.describeSObjectResult);
        
        Test.stopTest();
    }
}