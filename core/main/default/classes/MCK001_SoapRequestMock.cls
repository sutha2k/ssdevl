/**
 * @author Sutharsan Pushparajah
 * @date 28/09/2021 - SSDL V1.4
 * @description Test Soap Callout
 */
@isTest
public inherited sharing class MCK001_SoapRequestMock implements WebServiceMock{
    
    /**
     * @date 28/09/2021
     * @description contains the response
     */
    public inherited sharing class SoapRequestResponse_element {
        public String soapRequestResult;

        private String[] SoapRequestResult_type_info = new String[]{'SoapRequestResult', 'http://test/test', null, '0', '1', 'false'};

        private String[] apex_schema_type_info = new String[]{'http://test/test', 'true', 'false'};

        private String[] field_order_type_info = new String[]{'EchoStringResult'};
    }

    /**
     * @date 28/09/2021 
     * @description contains the request
     */
    public inherited sharing class SoapRequest_element {
        public String input;

        private String[] input_type_info = new String[]{'input', 'http://test/test', null, '0', '1', 'false'};

        private String[] apex_schema_type_info = new String[]{'http://test/test', 'true', 'false'};

        private String[] field_order_type_info = new String[]{'input'};
    }

    /**
     * @date 28/09/2021
     * @description Build the request and invoke the WS
     */
    public inherited sharing class SoapRequestPort implements ITF006_SoapRequestMock{
        
        private String serviceId;
        public String endpoint_x = 'http://YourServer/YourService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public String[] ns_map_type_info = new String[]{'http://test/test', 'tns:test', 'http://test/test','test',
                                                        'http://test/test','SoapRequestResponse_element',
                                                        'MCK001_SoapRequestMock.SoapRequestResponse_element'};
        
        /**
         * @date 28/09/2021
         * @description get the service id in test context
         * @return serviceId of the mock implementation
         */
        public String getServiceId(){
            return serviceId;
        }

        /**
         * @date 28/09/2021
         * @description set the service id of the mock implementation in test context
         * @return N/A
         */
        public void setServiceId(String serviceId){
            this.serviceId = serviceId;
        }

        /**
         * @date 28/09/2021
         * @description build the Soap Request based on the input parameter
         * @param input SoapRequest input parameter
         * @return MCK001_SoapRequestMock.SoapRequest_element SoapRequest element
         */
        public MCK001_SoapRequestMock.SoapRequest_element buildRequest(String input){
            MCK001_SoapRequestMock.SoapRequest_element request_x = new MCK001_SoapRequestMock.SoapRequest_element();
            request_x.input = input;

            return request_x;
        }

        /**
         * @date 28/09/2021
         * @description build the Soap Request Result based for the expected output
         * @param result SoapRequest expected output parameter
         * @return Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element> SoapRequest Response element
         */
        public Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element> buildResponseMap(String result){
            MCK001_SoapRequestMock.SoapRequestResponse_element response_x = new MCK001_SoapRequestMock.SoapRequestResponse_element();
            response_x.soapRequestResult = result;
            Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element> response_map_x = new Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element>();
            response_map_x.put('response_x', response_x);

            return response_map_x;
        }

        /**
         * @date 28/09/2021
         * @description Simulate a soap callout
         * @param input SoapRequest input parameter
         * @param result SoapRequest expected output parameter
         * @return string SoapRequest expected output parameter
         */
        public String invoke(String input, String result) {
            MCK001_SoapRequestMock.SoapRequest_element request_x = buildRequest(input);
            Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element> response_map_x = buildResponseMap(result);
            
            MCK001_SoapRequestMock.SoapRequestResponse_element response_x = new MCK001_SoapRequestMock.SoapRequestResponse_element();
            response_x = response_map_x.get('response_x');

            return response_x.soapRequestResult;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 29/09/2021
     * @description Find the corresponding mock implementation based on service header
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param endpoint The endpoint URL for the request
     * @param soapAction The requested SOAP operation
     * @param requestName The requested SOAP operation name
     * @param responseNS The response namespace
     * @param responseName The name of the response element as defined in the WSDL
     * @param responseType The class for the response as defined in the auto-generated class
     * @return N/A
     */
    public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                            String requestName, String responseNS, String responseName, String responseType) {
        
        MCK001_SoapRequestMock.SoapRequestResponse_element response_x = new MCK001_SoapRequestMock.SoapRequestResponse_element();
        response_x.soapRequestResult = 'Mock Response';
        response.put('response_x', response_x);
    }
}