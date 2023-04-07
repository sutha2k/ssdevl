/**
 * @author Sutharsan Pushparajah
 * @date 01/10/2021
 * @description PIC002_CalloutTracker - Call Callout logger from IP
 */
global inherited sharing class PIC002_CalloutTracker /*implements vlocity_cmt.VlocityOpenInterface*/{
    
    public static final String METHOD_NAME = 'trackCallout';
    public static final String METHOD_NAME_V2 = 'trackCalloutV2';
  
    /**
     * @author Sutharsan Pushparajah
     * @date 01/10/2021
     * @param methodName name of the method to invoke
     * @param input Map of key/value for inputs
     * @param output Map of key/value for outputs
     * @description invokeMethod trackCallout to publish callout event
     * @return true if no errors
     */
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        if (methodName.equals(METHOD_NAME)){
            return APU000_Logger.trackCallout(input, output, options);
        } else if (methodName.equals(METHOD_NAME_V2)){
            Map<String, Object> commonNode = (Map<String, Object>) input.get('TrackCalloutCommon');
            Map<String, Object> newInput = new Map<String, Object>();
            
            newInput.put('serviceName', commonNode.get('serviceName'));
            newInput.put('method', commonNode.get('method'));
            newInput.put('startTime', commonNode.get('startTime'));
            newInput.put('endTime', Datetime.now());
            
            String requestNodeName = (String) commonNode.get('requestNode');
            newInput.put('request', input.get(requestNodeName));
            
            String responseNodeName = (String) commonNode.get('responseNode');
            newInput.put('response', input.get(responseNodeName));
            
            newInput.put('message', '');
            newInput.put('queryParameters', (String) commonNode.get('queryParameters'));
            
            String statusNodeName = (String) commonNode.get('statusNode');
            
            Map<String, Object> statusNode = (Map<String, Object>) input.get(statusNodeName);
            
            if (statusNode != null){
            	newInput.put('status', statusNode.get('status'));
            	newInput.put('statusCode', statusNode.get('statusCode'));
            } else {
                newInput.put('status', 'KO');
            	newInput.put('statusCode', 500);
            }
            
            return APU000_Logger.trackCallout(newInput, output, options);
        }

        return false;
    }
}