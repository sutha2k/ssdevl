/**
 * @author Jerry Huang & Bobby White (Salesforce.com)
 * @date 22/09/2021
 * @description Custom Auth Provider for Apigee API Gateway
 * Implements the Client Credentials flow which is intended for server-to-server integrations
 * Modified and Customized for by Sutharsan Pushparajah
 */
public class APP001_ApigeeAuthProvider extends Auth.AuthProviderPluginClass{

    public static final String RESOURCE_CALLBACK = '/services/authcallback/';
    public static final String DEFAULT_TOKEN_TYPE = 'BearerToken';
    public static final String DUMMY_CODE = '999';

    /* This class is dependant on this Custom Metadata Type created to hold custom parameters */
    public static final String CUSTOM_MDT_NAME = 'ApigeeAuthProvider__mdt';
    /* CallbackUrl can be empty */
    public static final String CMT_FIELD_CALLBACK_URL = 'CallbackURL__c';
    /* Name to give to the custom auth provider, ex: ApigeAuthProvider */
    public static final String CMT_FIELD_PROVIDER_NAME = 'ProviderName__c';
    /* Name of the platform org cache, ex: local.TokenCache */
    public static final String CMT_FIELD_CACHEPROVIDER = 'CacheProvider__c';
    /* Name of the key holding the token into cache, ex: ApigeeToken */
    public static final String CMT_FIELD_CACHEPROVIDER_KEY = 'CacheProviderKey__c';
    /* TTL of the token that must expire before the real session expiration, ex: 3570 */
    public static final String CMT_FIELD_CACHEPROVIDER_TTL = 'CacheProviderTTL__c';
    
    public static final String STATE_PARAM = 'state';
    public static final String CODE_PARAM = 'code';
    
    /**
	 * @description Name of custom metadata type to store this auth provider configuration fields. This method is required by its abstract parent class.
     * @return String Name of the custommetadatatype holding the settings
     */
    public String getCustomMetadataType() {
        return CUSTOM_MDT_NAME;
    } 
    
    /**
     * @description Initiate callback. No End User authorization required in this flow so skip straight to the Token request.
     * @retrun PageReference The interface requires the callback url to be defined. Eg: https://test.salesforce.com/services/authcallback/<authprovidername>
     **/
    public PageReference initiate(Map<String, String> config, String stateToPropagate) {
        PageReference pageRef = new PageReference(getCallbackUrl(config)); //NOSONAR
        pageRef.getParameters().put(STATE_PARAM, stateToPropagate);
        pageRef.getParameters().put(CODE_PARAM, DUMMY_CODE); // Empirically found this is required, but unused

        return pageRef;
    } 

    /**
     * @description This method composes the callback URL automatically UNLESS it has been overridden through Configuration.
     * Normally one should not override the callback URL, but it's there in case the generated URL doesn't work.
     * @return String the callback URL
     **/
    private String getCallbackUrl(Map<String, String> config) {
        // https://{salesforce-hostname}/services/authcallback/{urlsuffix}
        String overrideUrl = config.get(CMT_FIELD_CALLBACK_URL);
        String generatedUrl = URL.getSalesforceBaseUrl().toExternalForm() + RESOURCE_CALLBACK + config.get(CMT_FIELD_PROVIDER_NAME);
        
        return String.isEmpty(overrideUrl) ? generatedUrl : overrideUrl;
    }
    
    /** 
     * @description Handle callback (from initial loop back "code" step in the flow).
     * In the Client Credentials flow, this method retrieves the access token directly.
     * Required by parent class.
     * Error handling here is a bit painful as the UI never displays the exception or error message 
     * supplied here.  The exception is thrown for Logging/Debugging purposes only.
     * @return Auth.AuthProviderTokenResponse The access token
     **/
    public Auth.AuthProviderTokenResponse handleCallback(Map<String, String> config, Auth.AuthProviderCallbackState state) {
        WS001_ApigeeLogin.TokenResponse response = retrieveToken(config);
        
        return new Auth.AuthProviderTokenResponse(config.get(CMT_FIELD_PROVIDER_NAME)
                                                  , response.access_token
                                                  , 'No Refresh Token'
                                                  , state.queryParameters.get(STATE_PARAM));
    } 
    
    /**
     * @description Refresh is required by the parent class and it's used if the original Access Token has expired.
     * In the Client Credentials flow, there is no Refresh token, so its implementation is exactly the
     * same as the Initiate() step.
     * @return Auth.OAuthRefreshResult The access token
     **/
    public override Auth.OAuthRefreshResult refresh(Map<String, String> config, String refreshToken) {
        WS001_ApigeeLogin.TokenResponse response = retrieveToken(config);
        
        return new Auth.OAuthRefreshResult(response.access_token, response.token_type);
    }
   
    /**
     * @description getUserInfo is required by the Parent class, but not fully supported by this provider.
     * Effectively the Client Credentials flow is only useful for Server-to-Server API integrations
     * and cannot be used for other contexts such as a Registration Handler for Communities.
     * @return Auth.UserData User Info
     **/
    public Auth.UserData getUserInfo(Map<string,string> config, Auth.AuthProviderTokenResponse response) {
        WS001_ApigeeLogin.TokenResponse token = retrieveToken(config);

        Auth.UserData userData = new Auth.UserData(
              token.application_name // identifier
            , null // firstName
            , null // lastName
            , null // fullName
            , null // email
            , null // link
            , null // userName
            , null  //locale
            , config.get(CMT_FIELD_PROVIDER_NAME) //provider
            , null // siteLoginUrl
            , new Map<String,String>());

        return userData;
    }
    
     /**
      * @author Sutharsan Pushparajah
      * @date 20/06/2022
      * @description Private method that gets the Auth Token using the Client Credentials Flow.
      * @return WS001_ApigeeLogin.TokenResponse Wrapper containing the session token
      **/
     private WS001_ApigeeLogin.TokenResponse retrieveToken(Map<String, String> config) {     
        
        Cache.OrgPartition part = null;
        Boolean isOrgCacheAvailable = true;
        WS001_ApigeeLogin.TokenResponse tokenResp = new WS001_ApigeeLogin.TokenResponse();

        //Retrieve from cache if still alive
        try {
            part = Cache.Org.getPartition(config.get(CMT_FIELD_CACHEPROVIDER));
            String cacheToken = (String) part.get(config.get(CMT_FIELD_CACHEPROVIDER_KEY));
         
            if (String.isNotEmpty(cacheToken)){
                tokenResp.access_token = cacheToken;
                return tokenResp;
            }
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.WARN, 'APP001_ApigeeAuthProvider', 'retrieveToken', 'Org Platform Cache not available');
            isOrgCacheAvailable = false;
        }
         
        //cannot be null so we don't check, Exception can be thrown
        tokenResp = WS001_ApigeeLogin.getToken();

        if (isOrgCacheAvailable){
            part.put(config.get(CMT_FIELD_CACHEPROVIDER_KEY), tokenResp.access_token, Integer.valueof(config.get(CMT_FIELD_CACHEPROVIDER_TTL)));
        }

        return tokenResp;
    }
}