/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-08-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-08-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public inherited sharing class RestUtil {
    @InvocableMethod(label='call Heroku' description='call heroku')
    public static void callHeroku(){
        DM003_HttpRequestService dm = new DM003_HttpRequestService('HEROKU');
        WRP003_HttpRequest inf = new WRP003_HttpRequest();
        inf.requestType = 'GET';
        dm.sendRequest(inf);
    }
}
