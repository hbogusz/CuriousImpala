/**
 * Created by hubert.bogusz on 10.05.2022.
 */

public with sharing class QueueableHospitalCallouts implements Queueable, Database.AllowsCallouts{
    private String action;
    private Map<Id, SObject> newItems;
    private List<Hospital__c> hospitals;
    public HospitalCalloutHandler calloutHandler;
    public Integer counter = 1;



    public QueueableHospitalCallouts(String action, Map<Id, SObject> newItems) {
        this.action = action;
        this.newItems = newItems;
        this.hospitals = newItems.values();
        calloutHandler = new HospitalCalloutHandler();
    }

    public void execute(QueueableContext context) {
        System.debug('1');
        if (this.action == 'insert') {
            calloutHandler.createHospital(hospitals);
          /*  if(calloutHandler.createResponseStatus != '200'){
                RepeatCreateHospital repeatCreateHospitalFirst = new RepeatCreateHospital(hospitals);
                Date currentDate1 = Date.today();
                String sch1 = '0 0 0 '+  currentDate1.addDays(1).day() + ' ' + currentDate1.month() +  ' ? ' +  currentDate1.year();
                String jobID1 =  System.schedule('Repeat Create Hospital', sch1, repeatCreateHospitalFirst);
            }*/
        }
    }

}