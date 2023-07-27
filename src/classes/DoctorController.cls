/**
 * Created by hubert.bogusz on 07.04.2022.
 */

public with sharing class DoctorController {
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctors { get; set; }
    public List<String> conditions = new List<String>();
    public Integer pageSize { get; set; }
    public Integer pageNumber;
    public Decimal lastNumber { get; set; }
    public boolean disablePrevious { get; set; }
    public boolean disableNext { get; set; }
    public boolean isSearched { get; set; }
    public Integer size { get; set; }
    public List<Doctor__c> doctorListView { get; set; }

    public DoctorController() {
        doctor = new Doctor__c();
        doctors = new List<Doctor__c>();
        pageNumber = 0;
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
        String query = 'SELECT First_Name__c, Name, Phone__c, Specialization__c, Email__c FROM Doctor__c ';
        conditions.clear();

        if (String.isNotBlank(doctor.First_Name__c)) {
            conditions.add('First_Name__c LIKE \'' + doctor.First_Name__c + '%\'');
        }
        if (String.isNotBlank(doctor.Name)) {
            conditions.add('Name LIKE \'' + doctor.Name + '%\'');
        }
        if (String.isNotBlank(doctor.Email__c)) {
            conditions.add('Email LIKE \'' + doctor.Email__c + '%\'');
        }
        if (String.isNotBlank(doctor.Specialization__c)) {
            conditions.add('Specialization__c LIKE \'' + doctor.Specialization__c + '%\'');
        }

        if (conditions.size() > 0) {
            query += ' WHERE ' + conditions.get(0);
            for (Integer i = 1; i < conditions.size(); i++) {
                query += ' AND ' + conditions.get(i);
            }
        }

        lastNumber = Database.query(query).size();
        lastNumber.round(System.RoundingMode.CEILING);


        doctors = Database.query(query);
        setController = new ApexPages.StandardSetController(doctors);
        this.doctors = (List<Doctor__c>) this.setController.getRecords();

        checkPageNumber();
    }
    public void viewDoctors(){
        if (!doctorListView.isEmpty()) {
            doctorListView.clear();
        }
        if (doctors.size() > pageSize) {
            for (Integer i = pageNumber*pageSize; i < pageSize; i++){
                doctorListView.add(doctors.get(i));
            }
        } else {
            doctorListView = doctors;
        }

    }
    public void searchAndView(){
        searchDoctors();
        viewDoctors();
    }
    public void clearFields() {
        if (doctor != null) {
            doctor.clear();
        }
        if (doctors != null) {
            doctors.clear();
            setController = new ApexPages.StandardSetController(doctors);
        }
    }
    public void previousPage() {
        pageNumber--;
        searchDoctors();
    }
    public void nextPage() {
        pageNumber++;
        searchDoctors();
    }
    public void checkPageNumber() {
        if (pageNumber <= 0) {
            disablePrevious = true;
        } else {
            disablePrevious = false;
        }
        if (pageNumber >= lastNumber) {
            disableNext = true;
        } else {
            disableNext = false;
        }
    }

    public void setFirstPage() {
        pageNumber = 0;
        searchDoctors();
    }
    public void setLastPage() {
        pageNumber = lastNumber.intValue();
        searchDoctors();
    }
    public PageReference refreshPageSize() {
        setController.setPageSize(size);
        return null;
}
}