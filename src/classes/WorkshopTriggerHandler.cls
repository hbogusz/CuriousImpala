/**
 * Created by hubert.bogusz on 10.05.2022.
 */

public with sharing class WorkshopTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean IsDisabled() {
        Switcher__c triggerSwitcher = Switcher__c.getInstance(UserInfo.getProfileId());
        TriggerDisabled = triggerSwitcher.Disabled__c;
        return TriggerDisabled;
    }
    public void BeforeInsert(List<SObject> newItems) {
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterInsert(Map<Id, SObject> newItems) {
        System.enqueueJob(new QueueableWorkshopCallouts('insert', newItems.values()));
    }
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.enqueueJob(new QueueableWorkshopCallouts('update', newItems.values()));
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
        System.enqueueJob(new QueueableWorkshopCallouts('delete', oldItems.values()));
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
}