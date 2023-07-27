/**
 * Created by hubert.bogusz on 10.05.2022.
 */

public with sharing class AuthorizeClass {

    public static string getRequestToken() {
/*        Target_Org__c credentials = Target_Org__c.getInstance();
        String reqBody = 'grant_type=password&client_id='
                + credentials.Client_Id__c + '&client_secret='
                + credentials.Client_Secret__c + '&username='
                + credentials.Username__c + '&password=' + credentials.Password__c;*/
        String reqBody =  'grant_type=password&client_id=3MVG9t0sl2P.pByrQA1yKEMcDROdYuiBeLb9VW.PVUw22dikG11onxndOXmV6lvQxyOiMbaVYHr.WTL2La0JK&client_secret='
                + '4E686D1155D979B51112633D59173960ADC953C946C8E870F5B1E85AFAA71C08&username='
                + 'hubert.bogusz99@gmail.com&password=Greenday7956CRCR0LBEpLabeFJrkiypzfkFf';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse hresp = h.send(req);
        responseWrapper wResp = (responseWrapper) JSON.deserialize(hresp.getBody(), responseWrapper.class);
        return wResp.access_token;
    }
    public class responseWrapper {
        public string id;
        public string access_token;
        public string instance_url;
    }

}