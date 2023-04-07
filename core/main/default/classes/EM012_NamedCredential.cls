/**
 * @author Sutharsan Pushparajah
 * @date 24/09/2021 - SSDL V1.4
 * @description EM012_NamedCredential - Entity to manage NamedCredential
 */
public inherited sharing class EM012_NamedCredential {

    public static Map<String, String> endpointByName = new Map<String, String>();

    static {
        List<NamedCredential> results = new List<NamedCredential>([select Id, DeveloperName, Endpoint from NamedCredential WITH SYSTEM_MODE]);
        
        for (NamedCredential named : results){
            endpointByName.put(named.DeveloperName.toLowerCase(), named.Endpoint);
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/09/2021
     * @description return the true URL of stored in named credential
     * @param namedCallout some endpoint from callout
     * @return base URL of the enndpoint
     */
    public static String getTrueEndpoint(String namedCallout){
        String trueEndpoint = namedCallout;

        if (String.isNotEmpty(namedCallout)){
            String namedCred = namedCallout.toLowerCase().substringBetween('callout:', '/');
            if (String.isNotEmpty(namedCred)){
                String temp = endpointByName.get(namedCred);
                if (String.isNotEmpty(temp)){
                    trueEndpoint = temp;
                }
            }
        }

        return trueEndpoint;
    }
}