/**
 * @author Sutharsan Pushparajah
 * @date 04/03/2021 - SSDL V1.2
 * @description WRP003_HttpRequest - Wrapper to embed Http Request/Response values 
 */
public inherited sharing class WRP003_HttpRequest {
    /* Header used to identify the service used */
    public static final String SERVICE_HEADER = 'SID-XXXX';
    /* Available REST operations */
    public enum HttpMethods {POST, PUT, PATCH, GET}
    /* Body of the request */
    public String body;
    /* EndPoint URL of the service */
    public String endPoint;
    /* Query Parameters */
    public String queryParameters;
    /* Specifify GET, POST, PUT, PATCH */
    public String requestType = 'POST';
    /* Timeout The value of request timeout in ms */
    public Integer timeout;
    /* The username value for authentication */
    public String userName;
    /* The password value for authentication */
    public String password;
    /* The name of SSL certificate */
    public String certificate;
    /* The acces token */
    public String accessToken;
    /* Parameters to pass into the header (key/value) */
    public Map<String, String> header = new Map<String, String>();
    /* Body parameters */
    public Map<String, String> bodyParams = new Map<String,String>();
    /* HttpRequest */
    public System.HttpRequest httpRequest;
    /* HttpResponse */
    public System.HttpResponse httpResponse;
    /* Exception catching */
    public Exception theException;
    /* SoapRequest */
    public Object soapRequest;
    /* SoapResponse */
    public Map<String,Object> soapResponse;
    /* bodydocument */
    public DOM.Document bodyDocument;

    /**
     * @author Sutharsan Pushparajah
     * @date 04/08/2021
     * @description Build HttpRequest based on input parameters from instance and/or RequestService__mdt setting
     * @param requestService Holds the setting for the resource to call
     * @return N/A
     */
    public void buildRequest(HttpRequestService__mdt requestService){
        httpRequest = new HttpRequest();

        if (requestService != null){
            endpoint = requestService.PrimaryNamedEndpoint__c;
            
            if (requestService.ForceSecondaryEndpoint__c || FeatureManagement.checkPermission(requestService.BypassPrimaryEndpointPermission__c)){
                endpoint = requestService.SecondaryNamedEndpoint__c;
            }
                
            endpoint += requestService.Resource__c;

            if (String.isNotEmpty(queryParameters)){
                endPoint += queryParameters;
            }

            timeout = Integer.valueOf(requestService.Timeout__c);
            
            if (String.isNotEmpty(requestService.CustomHeaders__c)){
             	Map<String, String> customHeaders = (Map<String, String>) JSON.deserialize(requestService.CustomHeaders__c, Map<String, String>.class);
                header.putAll(customHeaders);
            }
            
            if (Test.isRunningTest()){
                header.put(SERVICE_HEADER, requestService.ServiceId__c);
            }
            
        }
        
        if (String.isNotEmpty(certificate)) {
            httpRequest.setClientCertificateName(certificate);
        }

        if (String.isNotEmpty(userName) && String.isNotEmpty(password)) {
            Blob headerValue = Blob.valueOf(userName + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            httpRequest.setHeader('Authorization', authorizationHeader);
        }

        httpRequest.setEndPoint(endPoint);
        httpRequest.setMethod(requestType);
        httpRequest.setTimeout(timeout);
        
        if (header != null) {
            for (String key : header.keySet()) {
                httpRequest.setHeader(key, header.get(key));
            }
        }

        if (String.isNotEmpty(accessToken)){
            httpRequest.setHeader('Authorization', 'Bearer '+accessToken);
        }

        String bodyTemp = '';

        if (bodyParams != null){
            String result = '';
            
            for (String thisKey : bodyParams.keySet()) {
                result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(bodyParams.get(thisKey), 'UTF-8') + '&';
            }
            
            if (!result.equals('')){
                bodyTemp = result;
            }
        }
        
        if (requestType != HttpMethods.GET.name() && String.isNotEmpty(body)){
            bodyTemp += body;
            httpRequest.setBody(bodyTemp);
        }

        if (body == null && bodyDocument != null){
            httpRequest.setBodyDocument(bodyDocument);
        }
    }
}