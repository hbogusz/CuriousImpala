/**
 * Created by hubert.bogusz on 06.05.2022.
 */
@RestResource(urlMapping='/Sample/*')
global with sharing class RESTService {
    private static final String ERROR = 'error';
    private static final String SUCCESS = 'success';
    @HttpPost
    global static RESTWrappers.HospitalsResponse createHospitals() {
        RestRequest request = RestContext.request;
        RestResponse restResponse = RestContext.response;
        String requestString = request.requestBody.toString();

        List <RESTWrappers.HospitalRESTWrapper> hospitalWrappers = (List<RESTWrappers.HospitalRESTWrapper>) JSON.deserialize(requestString, List<RESTWrappers.HospitalRESTWrapper>.class);
        RESTWrappers.HospitalsResponse response = new RESTWrappers.HospitalsResponse();
        List<Hospital__c> newHospitals = new List<Hospital__c>();
        newHospitals = convertWrappersToHospitals(hospitalWrappers);

        try {
            insert newHospitals;
            response.status = SUCCESS;
        } catch (Exception e) {
            response.status = ERROR;
            response.errorMessage = e.getMessage();
            return response;
        }
        return response;
    }
    @HttpDelete
    global static RESTWrappers.HospitalsResponse deleteHospital() {
        RESTWrappers.HospitalsResponse response = new RESTWrappers.HospitalsResponse();
        RestRequest request = RestContext.request;
        String hospitalId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        Hospital__c hospitalToDelete  = [ SELECT Id
        FROM Hospital__c
        WHERE Id=:hospitalId
        LIMIT 1];

        try {
            delete hospitalToDelete;
            response.status = SUCCESS;
        } catch (Exception e) {
            response.status = ERROR;
            response.errorMessage += e.getMessage();
        }

        return response;
    }

    @HttpPatch
    global static RESTWrappers.HospitalsResponse updateHospitals() {
        RestRequest request = RestContext.request;
        RestResponse restResponse = RestContext.response;
        String requestString = request.requestBody.toString();

        List <RESTWrappers.HospitalRESTWrapper> hospitalWrappers = (List<RESTWrappers.HospitalRESTWrapper>) JSON.deserialize(requestString, List<RESTWrappers.HospitalRESTWrapper>.class);
        RESTWrappers.HospitalsResponse response = new RESTWrappers.HospitalsResponse();
        List<Hospital__c> newHospitals = new List<Hospital__c>();
        newHospitals = convertWrappersToHospitals(hospitalWrappers);


        return response;
    }
    @HttpGet
    global static List <RESTWrappers.HospitalRESTWrapper> getHospitals() {
        RestRequest request = RestContext.request;
        String hospitalId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        List <RESTWrappers.HospitalRESTWrapper> hospitalRESTWrappers = new List <RESTWrappers.HospitalRESTWrapper>();
        List<Hospital__c> hospitals  = [ SELECT Id,Name,City__c,Country__c,Opening_Date__c,Phone__c,Postal_Code__c,Street__c,External_Id__c,Email__c
        FROM Hospital__c
        ];

        return convertHospitalsToWrappers(hospitals);
    }

    private static List <Hospital__C> convertWrappersToHospitals(List <RESTWrappers.HospitalRESTWrapper> hospitalWrappers){
        List <Hospital__C> hospitals = new List<Hospital__C>();
        for (RESTWrappers.HospitalRESTWrapper wrapper: hospitalWrappers){
            Hospital__c hospital= new Hospital__c(
                    Name = wrapper.name,
                    City__c = wrapper.city,
                    Country__c = wrapper.country,
                    Email__c = wrapper.email,
                    Opening_Date__c = Date.valueOf(wrapper.openingDate),
                    Phone__c = wrapper.phone,
                    Postal_Code__c = wrapper.postalCode,
                    Street__c = wrapper.street
            );
            hospitals.add(hospital);
        }
        return hospitals;
    }
    private static List <RESTWrappers.HospitalRESTWrapper> convertHospitalsToWrappers (List <Hospital__C> hospitals){
        List <RESTWrappers.HospitalRESTWrapper> wrappers = new List<RESTWrappers.HospitalRESTWrapper>();
        for(Hospital__c hospital : hospitals){
            RESTWrappers.HospitalRESTWrapper hospitalRESTWrapper = new RESTWrappers.HospitalRESTWrapper();
            hospitalRESTWrapper.id = hospital.Id;
            hospitalRESTWrapper.externalId = hospital.External_Id__c;
            hospitalRESTWrapper.name = hospital.Name;
            hospitalRESTWrapper.city = hospital.City__c;
            hospitalRESTWrapper.country = hospital.Country__c;
            hospitalRESTWrapper.openingDate = String.valueOf(hospital.Opening_Date__c);
            hospitalRESTWrapper.phone = hospital.Phone__c;
            hospitalRESTWrapper.postalCode = hospital.Postal_Code__c;
            hospitalRESTWrapper.street = hospital.Street__c;
            hospitalRESTWrapper.email = hospital.Email__c;
            wrappers.add(hospitalRESTWrapper);
        }
        return wrappers;
    }



}