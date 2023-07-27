/**
 * Created by hubert.bogusz on 10.05.2022.
 */

    @RestResource(urlMapping='/Hospitals/*')
    global with sharing class RESTHospitalService {
        private static final String ERROR = 'error';
        private static final String SUCCESS = 'successful';
        @HttpGet
        global static List<RESTWrappers.HospitalRESTWrapper> getWorkshops() {
            RestRequest request = RestContext.request;
            String workshopId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
            String nameParam = request.params.get('name') + '%';
            String countryParam = request.params.get('country') + '%';
            List<RESTWrappers.HospitalRESTWrapper> hospitalRESTWrapper = new List<RESTWrappers.HospitalRESTWrapper>();
            List <Hospital__c> hospitals  = [ SELECT Id, Name, Country__c, City__C, Street__c, Phone__c, Email__c
            FROM Hospital__c
            WHERE Name LIKE :nameParam AND Country__c LIKE :countryParam
            ];
            for (Hospital__c hospital : hospitals){
                hospitalRESTWrapper.add(convertHospitalToWrapper(hospital));
            }

            return hospitalRESTWrapper;
        }
        @HttpPost
        global static RESTWrappers.HospitalsResponse createHospital() {
            RestRequest request = RestContext.request;
            RestResponse restResponse = RestContext.response;
            String requestString = request.requestBody.toString();

            RESTWrappers.HospitalRESTWrapper hospitalRESTWrapper = (RESTWrappers.HospitalRESTWrapper) JSON.deserialize(requestString, RESTWrappers.HospitalRESTWrapper.class);
            RESTWrappers.HospitalsResponse response = new RESTWrappers.HospitalsResponse();
            Hospital__c hospital = new Hospital__c();
            hospital = convertWrapperToHospital(hospitalRESTWrapper);

            try {
                insert hospital;
                response.status = SUCCESS;
                response.addedHospital = hospital;
            } catch (Exception e) {
                response.status = ERROR;
                response.errorMessage = e.getMessage();
                return response;
            }
            return response;
        }


        private static Hospital__c convertWrapperToHospital(RESTWrappers.HospitalRESTWrapper wrapper){
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
            hospitalRESTWrapper.name = hospital.Name;
            hospitalRESTWrapper.city = hospital.City__c;
            hospitalRESTWrapper.country = hospital.Country__c;
            hospitalRESTWrapper.phone = hospital.Phone__c;
            hospitalRESTWrapper.street = hospital.Street__c;
            hospitalRESTWrapper.email = hospital.Email__c;
            return hospitalRESTWrapper;
        }

    }