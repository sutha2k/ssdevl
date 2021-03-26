/**
 * @author Sutharsan Pushparajah
 * @date 26/03/2021 - SSDL V1.2
 * @description ITF004_HttpRequestManager - Signature of methods accessible 
 */
public interface ITF004_HttpRequestManager {
    void parseHttpResponse(WRP003_HttpRequest httpRequestInfos);
    void sendRequest(WRP003_HttpRequest httpRequestInfos);
}
