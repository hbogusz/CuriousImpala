/**
 * Created by hubert.bogusz on 11.05.2022.
 */

public with sharing class QueueableWorkshopCallouts implements Queueable, Database.AllowsCallouts {
    private String action;
    private Map<Id, SObject> newItems;
    private List<Workshop__c> workshops;
    public WorkshopCalloutHandler calloutHandler;
    public Integer counter;


    public QueueableWorkshopCallouts(String action, List<Workshop__c> workshops) {
        this.action = action;
        this.workshops = workshops;
        calloutHandler = new WorkshopCalloutHandler();
    }

    public void execute(QueueableContext context) {
        LogHandler__c log = new LogHandler__c();
        if (this.action == 'insert') {
            log = calloutHandler.createWorkShop(workshops);
        } else if (this.action == 'update') {
            log = calloutHandler.updateWorkShop(workshops);
        } else if (this.action == 'delete') {
            log = calloutHandler.deleteWorkShop(workshops);
        }

        Set <Id> ids = new Set<Id>();
        for (Workshop__c workshop : workshops) {
            ids.add(workshop.Id);
        }
        List <LogHandler__c> logs = new List<LogHandler__c>();
        logs = [SELECT Id,ObjectId__c FRom LogHandler__c WHERE ObjectId__c IN :ids AND Operation__c = :action AND Success__c = false];
        if (!log.Success__c && logs.size() < 3) {
            RepeatWorkshopOperation.schedule(action, workshops);
        }
        if (logs.size() >= 3) {
            delete logs;
        }
    }
}