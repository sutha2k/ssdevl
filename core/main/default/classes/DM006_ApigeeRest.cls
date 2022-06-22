/**
 * @author Sutharsan Pushparajah
 * @date 01/04/2022
 * @description DM006_ApigeeRest - Every Apigee REST Webservice class must extends this class to inherit standard behaviour
 */
public inherited sharing class DM006_ApigeeRest extends DM003_HttpRequestService{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 01/04/2022
     * @description ApigeeCustomException - Custom Exception to control WS response from Apigee
     */
    public class ApigeeCustomException extends Exception{}

    /* All Apigee successful respnse code */
    private static final Set<Integer> allowedStatusCode = new Set<Integer>{200, 201, 206};

    /* A seed */
    private static final String K_HEX_CHARS = '0123456789abcdef';

    /**
     * @author Sutharsan Pushparajah
     * @date 01/04/2022
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public DM006_ApigeeRest(String serviceName) {
        super(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 17/06/2022
     * @description method to generate specific guid for apigee
     * @return generated GUID
     */
    private static String generateGuid(){

        String returnValue = '';
        Integer nextByte = 0;

        for (Integer i=0; i<16; i++){

            if (i == 4 || i == 6 || i == 8 || i == 10){
                returnValue += '-';
            }

            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if (i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }

            if (i==8){
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += getCharAtIndex(K_HEX_CHARS, nextByte >> 4);
            returnValue += getCharAtIndex(K_HEX_CHARS, nextByte & 15);
        }

        return returnValue;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 17/06/2022
     * @description method to get substring
     * @return String Character at index
     */
    private static String getCharAtIndex(String str, Integer index) {

        if (str == null) return null;

        if (str.length() <= 0) return str;    

        if (index == str.length()) return null;    

        return str.substring(index, index + 1);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 04/04/2022
     * @description method to callout external service
     * @param httpRequestInfos wrapper containing request/response infos 
     * @return void
     */
    public override void sendRequest(WRP003_HttpRequest httpRequestInfos){
        Map<String, String> apigeeHeaders = new Map<String, String>{'Content-Length' => '0', 'X-correlation-id' => generateGuid()};
        httpRequestInfos.header.putAll(apigeeHeaders);
        super.sendRequest(httpRequestInfos);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 01/04/2022
     * @description Handle the response of the WS
     * @param httpRequestInfos wrapper containing request parameters
     * @return void
     */
    public override void parseHttpResponse(WRP003_HttpRequest httpRequestInfos){
        
        if (httpRequestInfos.theException != null){
            throw new ApigeeCustomException(httpRequestInfos.theException);
        }

        if (!allowedStatusCode.contains(httpRequestInfos.httpResponse.getStatusCode())){
            throw new ApigeeCustomException(httpRequestInfos.httpResponse.getBody());
        }
    }
}