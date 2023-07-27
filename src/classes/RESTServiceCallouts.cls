public with sharing class RESTServiceCallouts {
    public static HttpResponse makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://curious-impala-hrscj9-dev-ed.my.salesforce.com/services/apexrest/Sample/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<RESTWrappers.HospitalRESTWrapper> results = (List<RESTWrappers.HospitalRESTWrapper>) JSON.deserialize(response.getBody(), List<RESTWrappers.HospitalRESTWrapper>.class);
            System.debug('Received the following results:');
            for(RESTWrappers.HospitalRESTWrapper result: results) {
                System.debug(result);
            }
        }
        return response;
    }
}