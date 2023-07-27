/**
 * Created by hubert.bogusz on 20.04.2022.
 */

public with sharing class DoctorModel {
    public Doctor__c doctor {get; set;}
    public boolean isSelected {get; set;}
    public String importResult {get; set;}

    public DoctorModel(){
        this.doctor = new Doctor__c();
        this.isSelected = false;
    }

}