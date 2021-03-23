/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-23-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-08-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@RestResource(urlMapping='/secured/*')
global inherited sharing class RestUtil {
    @InvocableMethod(label='call Heroku' description='call heroku')
    public static List<List<String>> callHeroku(){
        DM003_HttpRequestService dm = new DM003_HttpRequestService('HEROKU_S01');
        WRP003_HttpRequest inf = new WRP003_HttpRequest();
        inf.requestType = 'GET';
        dm.sendRequest(inf);

        return new List<List<String>>{new List<String>{inf.httpResponse.getBody()}};
    }

    @HttpGet
    global static void mockHeroku(){
        RestResponse res = RestContext.response;
        res.responseBody  = Blob.valueOf('Accessing Secured Resources (Mock)');
    }
}
