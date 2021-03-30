/**
 * @author Sutharsan Pushparajah
 * @date 29/03/2021 - SSDL V1.3
 * @description EM010_LoggingMessage - Entity to manage LogginMessage__e platform event 
 */
public inherited sharing class EM010_LoggingMessage {

    /**
     * @author Sutharsan Pushparajah
     * @date 29/03/2021
     * @description Create an instance of LoggingMessage__e Event
     * @param transactionId Identify the id of the transaction
     * @param className Idnetify the caller class
     * @param methodName Identify the caller method
     * @param logLevel Identify the Log level 
     * @param startTime Identify the start time of the log
     * @param endTime Identify the end time of the log
     * @param message The logging message
     * @param userId Id of the connected user
     * @param userName userName of the connected user
     * @return instance of LoggingMessage__e Event
     */
    public static LoggingMessage__e create(String transactionId, String className, string methodName, String logLevel, 
    Datetime startTime, Datetime endTime, String message, String userId, String userName) {
        LoggingMessage__e messageEvent = new LoggingMessage__e();
        messageEvent.TransactionId__c = transactionId;
        messageEvent.ClassName__c = className;
        messageEvent.MethodName__c = methodName;
        messageEvent.Loglevel__c = logLevel;
        messageEvent.StartTime__c = startTime;
        messageEvent.EndTime__c = endTime;
        messageEvent.Message__c = message;
        messageEvent.UserId__c = userId;
        messageEvent.userName__c = userName;

        return messageEvent;
    }
}
