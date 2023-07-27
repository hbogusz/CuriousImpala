/**
 * Created by hubert.bogusz on 10.05.2022.
 */

public with sharing class RepeatCreateHospital implements Schedulable{
    private List<Hospital__c> hospitals;
    public String repeatResponse {get; set;}

    public RepeatCreateHospital(List<Hospital__c> hospitals){
        this.hospitals = hospitals;
    }

    public void execute(SchedulableContext ctx) {
        HospitalCalloutHandler calloutHandler = new HospitalCalloutHandler();
        calloutHandler.createHospital(hospitals);
        repeatResponse = calloutHandler.createResponseStatus;
    }
}