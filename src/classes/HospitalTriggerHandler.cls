/**
 * Created by hubert.bogusz on 10.05.2022.
 */

public with sharing class HospitalTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean IsDisabled() {
        return TriggerDisabled;
    }
    public void BeforeInsert(List<SObject> newItems) {
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterInsert(Map<Id, SObject> newItems) {
        List <Hospital__c> newHospitals = newItems.values();
        Map <Id, Hospital__c> hospitals = new Map <Id, Hospital__c> ();
        for (Hospital__c hospital : newHospitals){
            if(hospital.External_Id__c == null){
                hospitals.put(hospital.id, hospital);
            }
        }
        System.enqueueJob(new QueueableHospitalCallouts('insert', hospitals));
    }
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
}