/**
 * @author Sutharsan Pushparajah
 * @date 22/09/2021 - SSDL V1.4
 * @description DM005_SoapRequestService - extends SoapRequest to callout external service
 */
public virtual inherited sharing class DM005_SoapRequestService extends DM004_SoapRequest implements ITF005_SoapRequestManager{

    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public DM005_SoapRequestService(String serviceName){
        super(serviceName);
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description method to be implemented depending on how to handle response for each service provider
     * @param soapRequestInfos wrapper containing request/response infos
     * @return void
     */
    public override virtual void parseSoapResponse(WRP004_SoapRequest soapRequestInfos){
        //Implement behaviour depending on external systems
        //for example checking status code or parsing the response to check inner status
        //Each external Systems should have its own implemnentation on dedicated class
        //Every services from one external system should use only one service class
        return;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 22/09/2021
     * @description method to callout external service
     * @param soapRequestInfos wrapper containing request/response infos
     * @return void
     */
    public void sendRequest(WRP004_SoapRequest soapRequestInfos){
        invoke(soapRequestInfos);
    }
}