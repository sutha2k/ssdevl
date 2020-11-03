/**
 * @author Sutharsan Pushparajah
 * @date 29/07/2019 - SSDL V1.0
 * @description APU000_Logger - Logging Utilities
 */
public inherited sharing class APU000_Logger{
    
    /** 
     * @author Sutharsan Pushparajah
     * @date 29/07/2019
     * @description Custom sytem.debug with log level and personnalized information
     * @param logLevel System.LoggingLevel to define
     * @param className name of the class from where the log is called
     * @param methodName name of the method from where the log is called
     * @param message Informations to display in logger
     * @return String message that has been logged
     */
    public static String log(System.LoggingLevel logLevel, String className, String methodName, String message){
        
        if (!APC000_CoreSetting.coreSetting.LoggingEnabled__c) {
            return '';
        }
        
        String results;
        
        List<Object> parameters = new List<Object>{className, methodName, message};
        results = String.format('## >> [{0}][{1}][MESSAGE]: {2}', parameters);
        
        system.debug(logLevel, results);
        
        return results;
    }
}