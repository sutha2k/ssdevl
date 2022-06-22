/**
 * @author Sutharsan Pushparajah
 * @date 01/10/2021
 * @description PIC002_CalloutTracker - Call Callout logger from IP
 */
global inherited sharing class PIC002_CalloutTracker /*implements vlocity_cmt.VlocityOpenInterface*/{//uncomment this if you have vlocity
    
    public static final String METHOD_NAME = 'trackCallout';
  
    /**
     * @author Sutharsan Pushparajah
     * @date 01/10/2021
     * @param methodName name of the method to invoke
     * @param input Map of key/value for inputs
     * @param output Map of key/value for outputs
     * @description invokeMethod trackCallout to publish callout event
     * @return true if no errors
     */
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
        if (methodName.equals(METHOD_NAME)){
            return APU000_Logger.trackCallout(input, output, options);
        }

        return false;
    }
}
