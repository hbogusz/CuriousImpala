/**
 * Created by hubert.bogusz on 27.04.2022.
 */

global with sharing class DoctorSOAPWebService {
    webservice static Doctor__c getDoctor(Id doctorId) {
        Doctor__c doctor = findDoctorById(doctorId);
        return doctor;
    }
    webservice static ID createDoctor(DoctorWrapper doctorWrapper) {
        Doctor__c doctor = convertDoctorWrapperToDoctor(doctorWrapper);
        Database.SaveResult result = Database.insert(doctor, false);
        return doctor.Id;
    }
    webservice static void deleteDoctor(Id doctorId) {
        Doctor__c doctor = findDoctorById(doctorId);
        Database.DeleteResult result = Database.delete(doctor, false);
    }
    webService static Doctor__c updateDoctor(Id doctorId, DoctorWrapper doctorWrapper) {
        Doctor__c doctor = findDoctorById(doctorId);
        doctor.First_Name__c = doctorWrapper.firstname;
        doctor.Name = doctorWrapper.lastname;
        doctor.Email__c = doctorWrapper.email;
        doctor.Phone__c = doctorWrapper.phone;
        doctor.Specialization__c = doctorWrapper.specialization;
        doctor.Professional_Title__c = doctorWrapper.title;
        doctor.Date_Of_Birth__c = Date.parse(doctorWrapper.birthDate);
        doctor.Country__c = doctorWrapper.country;
        doctor.City__c = doctorWrapper.city;
        doctor.Street__c = doctorWrapper.street;
        doctor.Postal_Code__c = doctorWrapper.postalCode;
        doctor.ImgURL__c = doctorWrapper.img;
        Database.SaveResult result = Database.update(doctor, false);
        return doctor;
    }
    webService static List<DoctorWrapper> queryDoctors(String query) {
        List<Doctor__c> doctors = Database.query(query);
        List<DoctorWrapper> doctorWrappers = new List<DoctorSOAPWebService.DoctorWrapper>();
        for (Doctor__c doctor : doctors) {
            doctorWrappers.add(convertDoctorToDoctorWrapper(doctor));
        }
        return doctorWrappers;
    }

    public static Doctor__c findDoctorById(Id doctorid) {
        Doctor__c doctor = [
                SELECT Id,First_Name__c, Name, Email__c, Phone__c, Specialization__c
                FROM Doctor__c
                WHERE Id = :doctorId
        ];
        return doctor;
    }

    public static doctorWrapper convertDoctorToDoctorWrapper(Doctor__c doctor) {
        DoctorWrapper doctorWrapper = new DoctorWrapper();
        doctorWrapper.firstname = doctor.First_Name__c;
        doctorWrapper.lastname = doctor.Name ;
        doctorWrapper.email = doctor.Email__c;
        doctorWrapper.phone = doctor.Phone__c ;
        doctorWrapper.specialization = doctor.Specialization__c;
        doctorWrapper.title = doctor.Professional_Title__c;
        doctorWrapper.birthDate = String.valueOf(doctor.Date_Of_Birth__c);
        doctorWrapper.country = doctor.Country__c;
        doctorWrapper.city = doctor.City__c;
        doctorWrapper.street = doctor.Street__c;
        doctorWrapper.postalCode = doctor.Postal_Code__c;
        doctorWrapper.img = doctor.ImgURL__c;
        return doctorWrapper;
    }
    public static Doctor__c convertDoctorWrapperToDoctor(DoctorWrapper doctorWrapper) {
        Doctor__c doctor = new Doctor__c();
        doctor.First_Name__c = doctorWrapper.firstname;
        doctor.Name = doctorWrapper.lastname;
        doctor.Email__c = doctorWrapper.email;
        doctor.Phone__c = doctorWrapper.phone;
        doctor.Specialization__c = doctorWrapper.specialization;
        doctor.Professional_Title__c = doctorWrapper.title;
        doctor.Date_Of_Birth__c = Date.parse(doctorWrapper.birthDate);
        doctor.Country__c = doctorWrapper.country;
        doctor.City__c = doctorWrapper.city;
        doctor.Street__c = doctorWrapper.street;
        doctor.Postal_Code__c = doctorWrapper.postalCode;
        doctor.ImgURL__c = doctorWrapper.img;

        return doctor;
    }

    global class DoctorWrapper {
        webservice String id { get; set; }
        webservice String firstname { get; set; }
        webservice String lastname { get; set; }
        webservice String email { get; set; }
        webservice String phone { get; set; }
        webservice String specialization { get; set; }
        webservice String title { get; set; }
        webservice String birthDate { get; set; }
        webservice String country { get; set; }
        webservice String city { get; set; }
        webservice String street { get; set; }
        webservice String postalCode { get; set; }
        webservice String img { get; set; }
    }
}