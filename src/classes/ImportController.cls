/**
 * Created by hubert.bogusz on 15.04.2022.
 */

public with sharing class ImportController {
    public Blob csvFileBody { get; set; }
    public string csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public List<DoctorModel> doctorsFromFile { get; set; }
    public ApexPages.StandardController sController;
    public Map <Boolean, Doctor__c> importMap { get; set; }
    public boolean imported { get; set; }
    public string importResult { get; set; }
    public DoctorModel doctorModel { get; set; }


    public ImportController() {
        csvFileLines = new String[]{
        };
        doctorsFromFile = New List<DoctorModel>();
        this.imported = false;
        doctorModel = new DoctorModel();
        SObjectField picklistUsingGlobal = SObjectType.Doctor__c.fields.Country__c.getSObjectField();
        List<PicklistEntry> entries = picklistUsingGlobal.getDescribe().getPicklistValues();
        System.debug(entries);

    }

    public void importCSVFile() {
        try {
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            if (!doctorsFromFile.isEmpty()) {
                doctorsFromFile.clear();
            }

            for (Integer i = 1; i < csvFileLines.size(); i++) {
                DoctorModel doctorModel = new DoctorModel() ;
                String[] csvRecordData = csvFileLines[i].split(',');
                doctorModel.doctor.First_Name__c = csvRecordData[0] ;
                doctorModel.doctor.Name = csvRecordData[1];
                doctorModel.doctor.Email__c = csvRecordData[2];
                doctorModel.doctor.Specialization__c = csvRecordData[3];
                doctorsFromFile.add(doctorModel);
            }
            imported = false;
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
    }
    public PageReference getTemplate() {
        PageReference pageReference = Page.GetTemplate;
        pageReference.setRedirect(false);
        return pageReference;
    }
    public void checkAll() {
        for (DoctorModel doctor : doctorsFromFile) {
            doctor.isSelected = true;
        }
    }
    public void checkNone() {
        for (DoctorModel doctor : doctorsFromFile) {
            doctor.isSelected = false;
        }
    }
    public void checkReverse() {
        for (DoctorModel doctor : doctorsFromFile) {
            doctor.isSelected = !doctor.isSelected;
        }
    }
    public void importSelected() {
        try {
            List<Doctor__c> doctorsToImport = new List<Doctor__c>();
            List<DoctorModel> doctorsModelToImport = new List<DoctorModel>();
            Map <Id, Database.SaveResult> saveResultMap = new Map<Id, Database.SaveResult>();
            for (DoctorModel doctorModel : doctorsFromFile) {
                if (doctorModel.isSelected) {
                    doctorsToImport.add(doctorModel.doctor);
                    doctorsModelToImport.add(doctorModel);
                }
            }
            List<Database.SaveResult> results = Database.insert(doctorsToImport, false);
            for (Database.SaveResult result : results) {
                saveResultMap.put(result.getId(), result);
            }
            for (DoctorModel doctorModel : doctorsModelToImport) {
                if (saveResultMap.get(doctorModel.doctor.Id).isSuccess()) {
                    doctorModel.importResult = 'Success' ;
                } else {
                    doctorModel.importResult = saveResultMap.get(doctorModel.doctor.Id).getErrors().get(0).message;
                }
            }
            imported = true;
            doctorsFromFile = doctorsModelToImport;
        } catch (exception e) {
            ApexPages.addMessages(e);
            System.Debug('Exception');
        }

    }


}