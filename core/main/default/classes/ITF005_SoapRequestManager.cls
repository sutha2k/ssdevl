/**
 * @author Sutharsan Pushparajah
 * @date 22/09/2021 - SSDL V1.4
 * @description ITF005_SoapRequestManager - Signature of methods accessible 
 */
public interface ITF005_SoapRequestManager {
    void parseSoapResponse(WRP004_SoapRequest soapRequestInfos);
    void sendRequest(WRP004_SoapRequest soapRequestInfos);
}