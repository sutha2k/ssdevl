/**
 * @author Sutharsan Pushparajah
 * @date 17/06/2022
 * @description WS001_ApigeeLogin - Implement the Apigee Login Service to get session token
 */
public inherited sharing class WS001_ApigeeLogin {

    /* Body param key for auth */
    public static final String GRANT_TYPE_PARAM = 'grant_type';
    /* Body param value for auth */
    public static final String GRANT_TYPE_CLIENT_CREDS = 'client_credentials';
    /* Custom Exception to throw if any error */
    public class ApigeeTokenException extends Exception {}
    /* Default value for the callout response field token_type */
    public static final String DEFAULT_TOKEN_TYPE = 'BearerToken';
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'APIGEE_LOGIN';
    /* Apigee Login remote service instance */
    private static ITF004_HttpRequestManager apigeeLoginServiceHttp = new DM006_ApigeeRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 17/06/2022
     * @description Wrapper to capture response from the callout (Do not change syntax even it's not following best practices)
     */
    public inherited sharing class TokenResponse {
        public String token_type {get; set;}
        public String issued_at {get; set;}
        public String client_id {get; set;}
        public String access_token {get; set;}
        public String application_name {get; set;}
        public String scope {get; set;}
        public String expires_in {get; set;}
        public String refresh_count {get; set;}
        public String status {get; set;}

        // Apigee Edge -- hosted version uses these fields for error handling
        public String ErrorCode {get; set;}
        public String Error {get; set;}

        // Apigee on premise version uses this Field for error handling
        public Fault fault {get; set;}

        public Boolean isError() {
            return Error != null || fault != null;
        }

        public String getErrorMessage() {
            if (Error != null) {
                return 'Code: ' + ErrorCode + '/ Message: ' + Error;
            }

            if (fault != null) {
                // Substitute the error code to compose
                return fault.faultString.replace('{0}', fault.detail.errorcode);
            }

            return null;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 17/06/2022
     * @description Wrapper to capture response from the callout (Do not change syntax even it's not following best practices)
     */
    public inherited sharing class Fault {
        public String faultstring {get; set;}
        public Detail detail {get; set;}
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 17/06/2022
     * @description Wrapper to capture response from the callout (Do not change syntax even it's not following best practices)
     */
    public inherited sharing class Detail {
        public String errorcode {get; set;}
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 17/06/2022
     * @description Callout to token endpoint to get an access token
     * @return TokenResponse Wrapper containing the token and some session information
     */
    public static TokenResponse getToken(){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'POST';
        httpRequestInfos.bodyParams.put(GRANT_TYPE_PARAM,GRANT_TYPE_CLIENT_CREDS);

        apigeeLoginServiceHttp.sendRequest(httpRequestInfos);

        // use default parsing for everything we can.
        TokenResponse parsedResponse = new TokenResponse();
        String responseBody = null;

        try{
            responseBody = httpRequestInfos.httpResponse.getBody();
            parsedResponse = (TokenResponse) System.JSON.deserialize(responseBody, TokenResponse.class);

            if (parsedResponse.isError()){
                throw new ApigeeTokenException(parsedResponse.getErrorMessage());
            }

            // explicitly parse out the developer.email property because it's an illegal identifier
            Map<String,Object> props = (Map<String, Object>) System.JSON.deserializeUntyped(responseBody);
            // Ensure values for key fields
            parsedResponse.token_type = (parsedResponse.token_type == null) ? DEFAULT_TOKEN_TYPE : parsedResponse.token_type;
        } catch(Exception exp){
            parsedResponse.Error = exp.getMessage() + ' response: '+responseBody;
            throw new ApigeeTokenException(parsedResponse.Error);
        }
       
        return parsedResponse;
    }
}
