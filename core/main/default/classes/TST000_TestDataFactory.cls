/**
 * @author Sutharsan Pushparajah
 * @date 20/06/2022 - SSDL V1.5
 * @description Test Data Factory for SSDEVL Framework
 */
@isTest
public inherited sharing class TST000_TestDataFactory {

    /* Rely on FederationIdentifier to idnetify created user */
    private static final String SSDEVL_STD_USER_FEDID = 'SSDEVL001';
    /* The profile we are sure ton find in any org */
    private static final String SSDEVL_STD_USER_TYPE = 'Standard';
    /* Permission Set that contains minimum access right */
    private static final String SSDEVL_STD_USER_PERMSET = 'SSDEVL_TEST';

    /**
     * @author Sutharsan Pushparajah
     * @date 20/06/2022
     * @description Get user with Standard Profile and SSDEL_TEST PermissionSet
     */
    public static User getStandardUserForFramework(){
        return [SELECT Id FROM User WHERE FederationIdentifier =: SSDEVL_STD_USER_FEDID LIMIT 1];
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/06/2022
     * @description create user with Standard UserType and SSDEL_TEST PermissionSet
     * @return User created user
     */
    public static user createStandardUserForFramework(){
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile profile = [SELECT Id FROM Profile WHERE UserType =: SSDEVL_STD_USER_TYPE AND PermissionsViewSetup = true AND PermissionsPrivacyDataAccess = true ORDER BY CreatedDate ASC LIMIT 1];

        User user = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US', ProfileId = profile.Id,
        TimeZoneSidKey = 'America/Los_Angeles',
        UserName=uniqueUserName, FederationIdentifier = SSDEVL_STD_USER_FEDID);

        insert user;

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: SSDEVL_STD_USER_PERMSET LIMIT 1];

        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);

        return user;
    }
}
