global with sharing class DoctorSOAPWebServiceV2TEST {

    global class DoctorWrapper {
        webService String firstName { get; set; }
        webService String lastName { get; set; }
        webService String email { get; set; }
        webService String phone { get; set; }
        webService String country { get; set; }
        webService String dateOfBirth { get; set; }
        webService String doctorId { get; set; }
    }

    global class WEBResponse {
        webService String response;
    }

    global class WEBResponseDoctor {
        webService String firstName { get; set; }
        webService String lastName { get; set; }
        webService String phoneNumber { get; set; }
        webService String email { get; set; }
    }

    global class WEBDoctorIdRequest {
        webService String doctorId;
    }

    webService static List<DoctorWrapper> searchDoctor(DoctorWrapper doctorWrapper) {
        List<DoctorWrapper> doctorWrappers = new List<DoctorWrapper>();
        List<Doctor__c> doctors = new List<Doctor__c>();


        String first_name = ((doctorWrapper.firstName == null) ? ' First_name__c LIKE \'%%\' ' : ' First_name__c LIKE \'%' + String.escapeSingleQuotes(doctorWrapper.firstName) + '%\' ');
        String name = ((doctorWrapper.lastName == null) ? ' AND Name LIKE \'%%\' ' : ' AND Name LIKE \'%' + String.escapeSingleQuotes(doctorWrapper.lastName) + '%\' ');
        String country = ((doctorWrapper.country == null) ? ' AND Country__c LIKE \'%%\' ' : ' AND Country__c LIKE \'%' + doctorWrapper.country + '%\' ');
        String query = 'SELECT First_name__c, Name, Email__c,Phone__c, Country__c, Date_OF_Birth__c';

        query = query + ' FROM Doctor__c ';
        query = query + ' WHERE ' + first_name + name + country ;
        doctors = Database.query(query);
        doctorWrappers.clear();
        for (Doctor__c doctor : doctors) {
            doctorWrappers.add(convertDoctorToWrapper(doctor));
        }

        return doctorWrappers;

    }
    webService static List<String> getCountryGlobalSet() {
        SObjectField picklistUsingGlobal = SObjectType.Doctor__c.fields.Country__c.getSObjectField();
        List<PicklistEntry> entries = picklistUsingGlobal.getDescribe().getPicklistValues();
        List<String> countriesAsString = new List<String>();
        for(Schema.PicklistEntry objPickList : entries ) {
            countriesAsString.add(objPickList.getValue());
        }
        return countriesAsString;
    }


    webService static WEBResponse createDoctor(DoctorWrapper doctorWrapper) {
        WEBResponse res = new WEBResponse();

        Doctor__c doctor = new Doctor__c();
        doctor.First_Name__c = doctorWrapper.firstName;
        doctor.Name = doctorWrapper.lastName;
        doctor.Email__c = doctorWrapper.email;
        doctor.Country__c = doctorWrapper.country;

        Database.SaveResult result = Database.insert(doctor, false);
        if (result.success) {
            res.response = 'Success';
        } else {
            res.response = result.errors.get(0).message;
        }
        return res;
    }

    webService static DoctorWrapper loadDoctorById(DoctorWrapper doctorWrapper) {
        DoctorWrapper doctorWrapperResponse = new DoctorWrapper();

        Doctor__c doctor = new Doctor__c();
        doctor = [SELECT Id, First_Name__c, Name, Email__c, Phone__c, Country__c FROM Doctor__c WHERE Id = :doctorWrapper.doctorId];

        doctorWrapperResponse.firstName = doctor.First_Name__c;
        doctorWrapperResponse.lastName = doctor.Name;
        if (String.isBlank(doctor.Email__c)) {
            doctorWrapperResponse.email = 'This Mechanic has no Email added to his profile';
        } else {
            doctorWrapperResponse.email = doctor.Email__c;
        }

        doctorWrapperResponse.phone = doctor.Phone__c;
        doctorWrapperResponse.country = doctor.Country__c;

        return doctorWrapperResponse;
    }

    webService static WEBResponse updateDoctor(DoctorWrapper doctorWrapper) {
        WEBResponse res = new WEBResponse();
        Doctor__c updatedDoctor = new Doctor__c();

        updatedDoctor = convertWrapperToDoctor(doctorWrapper);


        Database.SaveResult result = Database.update(updatedDoctor, false);
        if (result.success) {
            res.response = 'Success';
        } else {
            res.response = result.errors.get(0).message;
        }
        return res;
    }

    webService static WEBResponse deleteDoctorById(DoctorWrapper doctorWrapper) {
        WEBResponse res = new WEBResponse();
        Doctor__c doctor = new Doctor__c();
        doctor = [SELECT Id, First_Name__c, Name, Email__c FROM Doctor__c WHERE Id = :doctorWrapper.doctorId];

        Database.DeleteResult result = Database.delete(doctor, false);
        if (result.success) {
            res.response = 'Success';
        } else {
            res.response = result.errors.get(0).message;
        }
        return res;
    }

    public static DoctorSOAPWebServiceV2TEST.DoctorWrapper convertDoctorToWrapper(Doctor__c doctor) {
        DoctorWrapper doctorWrapper = new DoctorWrapper();

        doctorWrapper.firstName = doctor.First_Name__c;
        doctorWrapper.lastName = doctor.Name;
        doctorWrapper.email = doctor.Email__c;
        doctorWrapper.phone = doctor.Phone__c;
        doctorWrapper.country = doctor.Country__c;
        doctorWrapper.doctorId = doctor.Id;



        return doctorWrapper;
    }
    public static Doctor__c convertWrapperToDoctor(DoctorWrapper doctorWrapper) {
        Doctor__c doctor = new Doctor__c();

        doctor.First_Name__c = doctorWrapper.firstName;
        doctor.Name = doctorWrapper.lastName;
        doctor.Email__c = doctorWrapper.email;
        doctor.Phone__c = doctorWrapper.phone;
        doctor.Country__c = doctorWrapper.country;
        doctor.Id = doctorWrapper.doctorId;


        return doctor;
    }

}