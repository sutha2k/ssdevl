/**
 * @author Sutharsan Pushparajah
 * @date 29/03/2021 - SSDL V1.3
 * @description Test class for EM010_LoggingMessage
 */
@isTest
private class EM010_LoggingMessage_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/03/2021
     * @description Testing creating and publishing an event
     */
    @isTest
    public static void testCreate(){
        
        Database.SaveResult sr;
        
        Test.startTest();

        Datetime theTime = System.now();
        LoggingMessage__e messageEvent = EM010_LoggingMessage.create('testId', 'testClass', 'testMethod', 'INFO', theTime, theTime+1, 'Testing', UserInfo.getUserId(), UserInfo.getUserName());
        sr = EventBus.publish(messageEvent);
        System.assertEquals('testId', messageEvent.TransactionId__c);
        System.assertEquals('testClass', messageEvent.ClassName__c);
        System.assertEquals('testMethod', messageEvent.MethodName__c);
        System.assertEquals('INFO', messageEvent.LogLevel__c);
        System.assertEquals(theTime, messageEvent.StartTime__c);
        System.assertEquals(theTime+1, messageEvent.EndTime__c);
        System.assertEquals('Testing', messageEvent.Message__c);
        System.assertEquals(UserInfo.getUserId(), messageEvent.UserId__c);
        System.assertEquals(UserInfo.getUserName(), messageEvent.UserName__c);
        System.assertEquals(true, sr.isSuccess());

        Test.stopTest();
    }
}
