/**
 * @author Sutharsan Pushparajah
 * @date 22/09/2021 - SSDL V1.4
 * @description DM004_SoapRequest - Every Custom SOAP Webservice class must extends this class to inherit standard behaviour
 */
public inherited sharing abstract class DM004_SoapRequest {

    /* Holds the setting for the resource to call */
    private HttpRequestService__mdt requestService;

    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public DM004_SoapRequest(String serviceName){
        requestService = HttpRequestService__mdt.getInstance(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description Method to make a SOAP Callout
     * @param soapRequestInfos wrapper containing request parameters
     * @return N/A
     */
    protected void invoke(WRP004_SoapRequest soapRequestInfos){
        Datetime startTime;
        Datetime endTime;
        String message;
        try {
            soapRequestInfos.buildRequest(requestService);
            startTime = System.now();
            WebServiceCallout.invoke(soapRequestInfos.stub, soapRequestInfos.request, soapRequestInfos.response, soapRequestInfos.infoArray);
        } catch (Exception exp){
            soapRequestInfos.httpRequestInfos.theException = exp;
            message = exp.getMessage();
            System.debug('#### EXP +'+exp);
        }  finally {
            endTime = System.now();
            soapRequestInfos.httpRequestInfos.soapRequest = soapRequestInfos.request;
            soapRequestInfos.httpRequestInfos.soapResponse = soapRequestInfos.response;
            APU000_Logger.trackCallout(requestService, startTime, endTime, message, soapRequestInfos.httpRequestInfos);
            parseSoapResponse(soapRequestInfos);
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description method to be implemented depending on how to handle response for each service provider
     * @param soapRequestInfos wrapper containing request parameters
     * @return void
     */
    public abstract void parseSoapResponse(WRP004_SoapRequest soapRequestInfos);
}