/**
 * Created by hubert.bogusz on 12.04.2022.
 */

public with sharing class HospitalDetailController {
    public Hospital__c hospital { get; set; }
    public Hospital_Contract__c contract { get; set; }
    public HospitalWrapper hospitalWrapper { get; set; }
    public HospitalDetailController(ApexPages.StandardController standardController) {
        hospitalWrapper = new HospitalWrapper();
        String hospitalId = standardController.getId();
        if (String.isBlank(hospitalId)) {
            hospitalWrapper = new HospitalWrapper();
        } else {
            hospitalWrapper.hospital = [
                    SELECT Name, Email__c, Phone__c, Opening_Date__c, Country__c, City__c, Street__c, Postal_Code__c, CreatedBy.Name,CreatedBy.CreatedDate, LastModifiedBy.Name,
                            LastModifiedBy.CreatedDate, (
                            SELECT Doctor__r.First_Name__c, Doctor__r.Name, Start_Date__c, Expiration_Date__c, Active__c
                            FROM Hospital_Contracts__r
                    )
                    FROM Hospital__c
                    WHERE Id = :hospitalId
            ];
            if(hospitalWrapper.hospital.City__c == 'New York'){
                hospitalWrapper.latitude = 40.716941;
                hospitalWrapper.longitude = -74.008185;
            } else if(hospitalWrapper.hospital.City__c == 'Lublin'){
                    hospitalWrapper.latitude = 51.247455;
                    hospitalWrapper.longitude = 22.565162;
                }
        }
    }
}