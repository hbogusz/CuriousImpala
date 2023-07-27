/**
 * Created by hubert.bogusz on 22.04.2022.
 */

public with sharing class HospitalWrapper {
    public Hospital__c hospital {get; set;}
    public boolean isSelected {get; set;}
    public Double latitude {get; set;}
    public Double longitude {get; set;}

    public HospitalWrapper(){
        this.hospital = new Hospital__c();
        this.isSelected = false;
    }
}