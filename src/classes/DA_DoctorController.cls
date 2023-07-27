/**
 * Created by hubert.bogusz on 09.04.2022.
 */

public with sharing class DA_DoctorController {

    public Integer size { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctorList { get; set; }
    private List<String> conditions = new List<String>();
    public Integer numberOfRecords { get; set; }

    public DA_DoctorController() {
        doctor = new Doctor__c();
        doctorList = new List<Doctor__c>();
        size = 2;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('1', '1'));
        paginationSizeOptions.add(new SelectOption('2', '2'));
        paginationSizeOptions.add(new SelectOption('5', '5'));
        paginationSizeOptions.add(new SelectOption('10', '10'));
        paginationSizeOptions.add(new SelectOption('15', '15'));
    }

    public ApexPages.StandardSetController setController {
        get {
            if (setController == null) {
                setController = new ApexPages.StandardSetController(doctorList);
            }
            return setController;
        }
        set;
    }

    public List<Doctor__c> getDoctorsList() {
        return (List<Doctor__c>) setController.getRecords();
    }


    public void searchData() {
        String query = ' SELECT First_Name__c, Name, Email__c, Specialization__c FROM Doctor__c ';
        conditions.clear();

        if (String.isNotBlank(doctor.First_Name__c)) {
            conditions.add('First_Name__c LIKE ' + '\'' + String.escapeSingleQuotes(doctor.First_Name__c) + '%\'');
        }
        if (String.isNotBlank(doctor.Name)) {
            conditions.add('Name LIKE' + '\'' + String.escapeSingleQuotes(doctor.Name) + '%\'');
        }
        if (String.isNotBlank(doctor.Specialization__c)) {
            conditions.add('Specialization__c LIKE' + '\'' + String.escapeSingleQuotes(doctor.Specialization__c) + '%\'');
        }
        if (String.isNotBlank(doctor.Email__c)) {
            conditions.add('Email__c LIKE' + '\'' + String.escapeSingleQuotes(doctor.Email__c) + '%\'');
        }

        if (conditions.size() > 0) {
            query += 'WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++) {
                query += ' AND ' + conditions[i];
            }
        }

        numberOfRecords = Database.query(query).size();
        doctorList = Database.query(query);
        setController = new ApexPages.StandardSetController(doctorList);
        setController.setPageSize(size);
        this.doctorList = (List<Doctor__c>) this.setController.getRecords();

        if (doctorList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'System.Label.HP_Records_error'));
        }
    }

    public PageReference refreshPageSize() {
        setController.setPageSize(size);
        return null;
    }

    public void clearFields() {
        if (doctor != null) {
            doctor.clear();
        }
        if (doctorList != null) {
            doctorList = new List<Doctor__c>();
            setController = new ApexPages.StandardSetController(doctorList);
        }
    }
}