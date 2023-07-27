/**
 * Created by hubert.bogusz on 10.04.2022.
 */

public with sharing class DoctorsController {
    public Id doctorId { get; set;}
    public Integer pageSize { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctors { get; set; }
    private List<String> conditions = new List<String>();
    public boolean disableClear { get; set; }

    public DoctorsController() {
        doctor = new Doctor__c();
        doctors = new List<Doctor__c>();
        pageSize = 5;
        disableClear = true;
    }

    public ApexPages.StandardSetController setController {
        get {
            if (setController == null) {
                setController = new ApexPages.StandardSetController(doctors);
            }
            return setController;
        }
        set;
    }
    public List<Doctor__c> getDoctorsList() {
        return (List<Doctor__c>) setController.getRecords();
    }

    public void searchDoctors() {
        String query = ' SELECT First_Name__c, Name, Email__c, Specialization__c, Phone__c FROM Doctor__c ';
        conditions.clear();

        if (String.isNotBlank(doctor.First_Name__c)) {
            conditions.add('First_Name__c LIKE ' + '\'' + doctor.First_Name__c + '%\'');
        }
        if (String.isNotBlank(doctor.Name)) {
            conditions.add('Name LIKE' + '\'' + doctor.Name + '%\'');
        }
        if (String.isNotBlank(doctor.Specialization__c)) {
            conditions.add('Specialization__c LIKE' + '\'' + doctor.Specialization__c + '%\'');
        }
        if (String.isNotBlank(doctor.Email__c)) {
            conditions.add('Email__c LIKE' + '\'' + doctor.Email__c + '%\'');
        }

        if (conditions.size() > 0) {
            query += 'WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++) {
                query += ' AND ' + conditions[i];
            }
        }

        doctors = Database.query(query);
        setController = new ApexPages.StandardSetController(doctors);
        setController.setPageSize(pageSize);
        checkDisableClear();

        if (doctors.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There-s no records with provided criteria'));
        }
    }

    public PageReference refreshPageSize() {
        setController.setPageSize(pageSize);
        return null;
    }

    public void clearFields() {
        if (doctor != null) {
            doctor.clear();
        }
        if (doctors != null) {
            doctors.clear();
            setController = new ApexPages.StandardSetController(doctors);
        }
        checkDisableClear();
    }
    public PageReference checkDisableClear(){
        if ( doctors.size() > 0 || String.isNotBlank(doctor.First_Name__c) || String.isNotBlank(doctor.Name)
                || String.isNotBlank(doctor.Email__c) || String.isNotBlank(doctor.Specialization__c)) {
            disableClear = false;
        } else {
            disableClear = true;
        }
        return null;
    }

    public PageReference exportResultToCSV() {
        return Page.ExportDoctorsToCSV;
    }
    public PageReference exportResultToXLSX() {
        PageReference pageReference = Page.ExportDoctorsToXLSX;
        pageReference.setRedirect(false);
        return pageReference;
    }
    public String COMMA {
        get {
            return String.fromCharArray(new List<Integer> { 44 });
        }
    }
    public String CRLF {
        get {
            return '\r';
        }
    }
}