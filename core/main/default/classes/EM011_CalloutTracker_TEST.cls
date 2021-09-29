/**
 * @author Sutharsan Pushparajah
 * @date 30/03/2021 - SSDL V1.3
 * @description Test class for EM011_CalloutTracker
 */
@isTest
private class EM011_CalloutTracker_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 30/03/2021
     * @description Testing creating and publishing an event
     */
    @isTest
    public static void testCreate(){
        
        Database.SaveResult sr;

        DOM.Document doc = new DOM.Document();
        doc.load('<xml></xml>');

        WRP003_HttpRequest wrpReq = new WRP003_HttpRequest();
        wrpReq.endPoint = 'https://mock';
        wrpReq.requestType = 'GET';
        wrpReq.header.put('testH', 'testV');
        wrpReq.queryParameters = '/Id/xxxx';
        wrpReq.timeout = 120000;
        wrpReq.body = 'test body';
        wrpReq.bodyDocument = doc;

        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);
        response.setBody('test response');

        Datetime theDate = System.now();
        
        Test.startTest();

        CalloutTracker__e calloutTrackerEvent = EM011_CalloutTracker.create('TID1', 'SID1', '/Account', theDate, theDate+1, 'sent', UserInfo.getUserId(), UserInfo.getUserName(), wrpReq);
        sr = EventBus.publish(calloutTrackerEvent);

        System.assertEquals(true, sr.isSuccess());
        System.assertEquals('TID1', calloutTrackerEvent.TransactionId__c);
        System.assertEquals('SID1', calloutTrackerEvent.ServiceId__c);
        System.assertEquals('/Account', calloutTrackerEvent.Resource__c);
        System.assertEquals(theDate, calloutTrackerEvent.StartTime__c);
        System.assertEquals(theDate+1, calloutTrackerEvent.EndTime__c);
        System.assertEquals('sent', calloutTrackerEvent.Message__c);
        System.assertEquals(UserInfo.getUserId(), calloutTrackerEvent.UserId__c);
        System.assertEquals(UserInfo.getUserName(), calloutTrackerEvent.Username__c);
        System.assertEquals(JSON.serialize(wrpReq.header),calloutTrackerEvent.Headers__c);
        System.assertEquals('GET', calloutTrackerEvent.HttpMethod__c);
        System.assertEquals('https://mock', calloutTrackerEvent.Endpoint__c);
        System.assertEquals('/Id/xxxx', calloutTrackerEvent.Queryparameters__c);
        System.assertEquals(120000, calloutTrackerEvent.Timeout__c);
        System.assertEquals(null, calloutTrackerEvent.Status__c);
        System.assertEquals(null, calloutTrackerEvent.StatusCode__c);
        System.assertEquals(' BODY['+wrpReq.body+'] BODYDOC['+wrpReq.bodyDocument.toXmlString()+']', calloutTrackerEvent.Request__c);
       
        wrpReq.httpResponse = response;
        calloutTrackerEvent = EM011_CalloutTracker.create('TID2', 'SID1', '/Account', theDate, theDate+1, 'sent', UserInfo.getUserId(), UserInfo.getUserName(), wrpReq);
        sr = EventBus.publish(calloutTrackerEvent);
        System.assertEquals(true, sr.isSuccess());
        System.assertEquals('TID2', calloutTrackerEvent.TransactionId__c);
        System.assertEquals('OK', calloutTrackerEvent.Status__c);
        System.assertEquals(200, calloutTrackerEvent.StatusCode__c);
        System.assertEquals('BODY[test response]', calloutTrackerEvent.Response__c);

        wrpReq.httpRequest = null;
        wrpReq.httpResponse = null;
        wrpReq.body = null;
        wrpReq.bodyDocument = null;
        wrpReq.soapRequest = 'SoapObject';
        wrpReq.soapResponse = new Map<String, Object>{'SoapResponse' => 'test response'};

        calloutTrackerEvent = EM011_CalloutTracker.create('TID2', 'SID1', '/Account', theDate, theDate+1, 'sent', UserInfo.getUserId(), UserInfo.getUserName(), wrpReq);
        sr = EventBus.publish(calloutTrackerEvent);

        System.assertEquals(true, sr.isSuccess());
        System.assertEquals('SoapObject', calloutTrackerEvent.Request__c);
        System.assertEquals('{SoapResponse=test response}', calloutTrackerEvent.Response__c);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 29/09/2021
     * @description Testing truncation when String > 132000
     */
    @isTest
    public static void testTruncate(){
        Test.startTest();

        String value = '01';

        String returnedValue = EM011_CalloutTracker.truncate(value);

        System.assertEquals(value, returnedValue);

        EM011_CalloutTracker.maxLength = 1;
        returnedValue = EM011_CalloutTracker.truncate(value);

        System.assertEquals('0', returnedValue);

        Test.stopTest();
    }
}