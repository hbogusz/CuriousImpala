/**
 * Created by hubert.bogusz on 06.05.2022.
 */

global with sharing class RESTWrappers {
    global class HospitalRESTWrapper {
        global String id;
        global String externalId;
        global String name;
        global String city;
        global String country;
        global String email;
        global String openingDate;
        global String phone;
        global String postalCode;
        global String street;
    }
    global class HospitalsResponse {
        global String status;
        global String errorMessage;
        global Hospital__c addedHospital;
    }
    global class WorkshopRESTWrapper {
        global String id;
        global String externalId;
        global String name;
        global String city;
        global String country;
        global String email;
        global String openingHours;
        global String phone;
        global String street;
        global boolean disableTrigger;
    }
    global class WorkshopResponse {
        global String status;
        global String errorMessage;
        global List<Workshop__c> addedWorkshops;
    }


}