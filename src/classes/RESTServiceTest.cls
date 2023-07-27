@isTest
public with sharing class RESTServiceTest {
    @isTest static  void testGetCallout() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetHospitalResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result = RESTServiceCallouts.makeGetCallout();
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        System.assertEquals('application/json;charset=UTF-8',
                result.getHeader('Content-Type'),
                'The content type value is not expected.');
        List<RESTWrappers.HospitalRESTWrapper> results = (List<RESTWrappers.HospitalRESTWrapper>) JSON.deserialize(result.getBody(), List<RESTWrappers.HospitalRESTWrapper>.class);
        System.assertEquals(2, results.size(), 'The array should only contain 2 items.');
    }
    @isTest
    static void testHttpGetCallout() {
        Test.setMock(HttpCalloutMock.class, new RESTServiceHttpCalloutMock());
        HttpResponse response = RESTServiceCallouts.makeGetCallout();
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        List<RESTWrappers.HospitalRESTWrapper> results = (List<RESTWrappers.HospitalRESTWrapper>) JSON.deserialize(response.getBody(), List<RESTWrappers.HospitalRESTWrapper>.class);
        System.debug(results);
        System.assertEquals(2, results.size());
        System.assertEquals(200, response.getStatusCode());
    }
}