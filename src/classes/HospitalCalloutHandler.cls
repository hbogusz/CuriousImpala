/**
 * Created by hubert.bogusz on 10.05.2022.
 */

public with sharing class HospitalCalloutHandler {
    public String createResponseStatus { get; set; }

    public LogHandler__c createHospital(List<Hospital__c> newHospitals) {
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Hospitals';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = AuthorizeClass.getRequestToken();
        System.debug('accessToken: ' + accessToken);
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setBody(JSON.serialize(convertHospitalToWrapper(newHospitals.get(0))));
        System.debug('Hospital: ' + newHospitals.get(0));
        HttpResponse httpResponse = http.send(request);
        createResponseStatus = String.valueOf(httpResponse.getStatusCode());
        System.debug('Created done');
        return createLog(request, httpResponse, 'Hospital');
    }

    private static Hospital__c convertWrapperToHospital(RESTWrappers.HospitalRESTWrapper wrapper) {
        Hospital__c hospital = new Hospital__c(
                Name = wrapper.name,
                City__c = wrapper.city,
                Country__c = wrapper.country,
                Email__c = wrapper.email,
                Phone__c = wrapper.phone,
                Street__c = wrapper.street
        );
        return hospital;
    }

    private static RESTWrappers.HospitalRESTWrapper convertHospitalToWrapper(Hospital__c hospital) {
        RESTWrappers.HospitalRESTWrapper hospitalRESTWrapper = new RESTWrappers.HospitalRESTWrapper();
        hospitalRESTWrapper.id = hospital.id;
        hospitalRESTWrapper.name = hospital.Name;
        hospitalRESTWrapper.city = hospital.City__c;
        hospitalRESTWrapper.country = hospital.Country__c;
        hospitalRESTWrapper.phone = hospital.Phone__c;
        hospitalRESTWrapper.street = hospital.Street__c;
        hospitalRESTWrapper.email = hospital.Email__c;
        return hospitalRESTWrapper;
    }

    public static LogHandler__c createLog(HttpRequest request, HttpResponse response, String objectName) {

        LogHandler__c logHandler = new LogHandler__c();

        logHandler.Request_body__c = request.getBody();
        logHandler.Request_endpoint__c = request.getEndpoint();
        logHandler.Response_status_code__c = String.valueOf(response.getStatusCode());
        logHandler.Response_body__c = String.valueOf(JSON.deserializeUntyped(response.getBody()));
        logHandler.Status__c = response.getStatus();
        logHandler.Create_Date__c = Date.today();
        logHandler.Attempt_Number__c = 1;
        logHandler.Object__c = objectName;

        insert logHandler;
        return logHandler;

    }
}