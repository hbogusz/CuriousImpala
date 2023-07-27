/**
 * Created by hubert.bogusz on 11.04.2022.
 */

public with sharing class DoctorDetailsController {
    public Doctor__c doctor { get; set; }
    public Hospital_Contract__c contract { get; set; }
    public Hospital__c hospital { get; set; }
    public HospitalWrapper hospitalWrapper { get; set; }
    public HospitalWrapper searchWrapper { get; set; }
    public List<Hospital__c> hospitalsFromQuery { get; set; }
    public List<HospitalWrapper> hospitals { get; set; }
    private List<String> conditions = new List<String>();
    public String hospitalName { get; set; }
    public boolean isDisable { get; set; }
    public Id hospitalId { get; set; }
    public PageReference pageReference { get; set; }
    public Blob fileBody { get; set; }
    public String fileName { get; set; }
    public String imageUrl { get; set; }



    public DoctorDetailsController(ApexPages.StandardController standardController) {
        hospitalWrapper = new HospitalWrapper();
        searchWrapper = new HospitalWrapper();
        hospitals = new List<HospitalWrapper>();
        contract = new Hospital_Contract__c();
        pageReference = ApexPages.currentPage();
        isDisable = true;
        String doctorId = standardController.getId();
        if (String.isBlank(doctorId)) {
            doctor = new Doctor__c();
        } else {
            doctor = [
                    SELECT Professional_Title__c,Email__c,First_Name__c,
                            Phone__c,Name,Date_Of_Birth__c,Specialization__c, Country__c,City__c,
                            Street__c, Postal_Code__c,ImgURL__c, CreatedBy.Name,CreatedBy.CreatedDate, LastModifiedBy.Name,
                            LastModifiedBy.CreatedDate, (
                            SELECT Hospital__r.Name, Start_Date__c, Expiration_Date__c, Active__c
                            FROM Hospital_Contracts__r
                    )
                    FROM Doctor__c
                    WHERE Id = :doctorId
            ];
        }
    }

    public PageReference searchHospitals(){
        if (hospitals.size() > 0) {
            hospitals.clear();
        }
        String query =' SELECT Id, Name, Email__c, Country__c FROM Hospital__c WHERE Name LIKE '
                + '\'%' + searchWrapper.hospital.Name + '%\'' ;
        System.debug('hospital name : ' + searchWrapper.hospital.Name);
        conditions.clear();
        if (String.isNotBlank(searchWrapper.hospital.Email__c)) {
            conditions.add('Email__c LIKE ' + '\'%' + searchWrapper.hospital.Email__c + '%\'');
        }
        if (String.isNotBlank(searchWrapper.hospital.Country__c)) {
            conditions.add('Country__c LIKE' + '\'' + searchWrapper.hospital.Country__c + '%\'');
        }

        if (conditions.size() > 0) {
//            query += String.join(conditions, ' AND ');
            for (Integer i = 0; i < conditions.size(); i++) {
                query += ' AND ' + conditions[i];
            }
        }
        hospitalsFromQuery = Database.query(query);
        for(Hospital__c hospital: hospitalsFromQuery){
            HospitalWrapper hospitalWrapper = new HospitalWrapper();
            hospitalWrapper.hospital = hospital;
            hospitals.add(hospitalWrapper);
        }
        if (hospitals.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There-s no records with provided criteria'));
        }
        return null;
    }
    public void clearFields() {
        if (searchWrapper.hospital != null) {
            searchWrapper.hospital.clear();
        }
        if (hospitals != null) {
            hospitals.clear();
        }
        isDisable=true;
    }
    public void showInfo(){
        for (HospitalWrapper wrapper : hospitals){
            if(wrapper.hospital.id == hospitalId){
                hospitalWrapper = wrapper;
                wrapper.isSelected = true;
            }
            else {
                wrapper.isSelected = false;
            }
        }
    }
    public PageReference saveContract() {
        try {
            contract.Hospital__c = hospitalWrapper.hospital.Id;
            contract.Doctor__c = doctor.Id;
            insert contract;
            pageReference.setRedirect(true);
            return pageReference;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    public void checkDisableClear(){
        if ( hospitals.size() > 0 || String.isNotBlank(searchWrapper.hospital.Name)
                || String.isNotBlank(searchWrapper.hospital.Email__c) || String.isNotBlank(searchWrapper.hospital.Country__c)) {
            isDisable = false;
        } else {
            isDisable = true;
        }
    }

    public void addImage(){
       try{
           doctor.ImgURL__c = imageUrl;
           System.debug(imageUrl);
           update doctor;
       }
       catch(exception e) {
           ApexPages.addMessages(e);
           System.debug('error');
       }
    }

    public PageReference refreshHiddenInput(){
        System.debug('imageUrl: ' + imageUrl);
        return null;
    }
}