/**
 * Created by hubert.bogusz on 10.05.2022.
 */

trigger WorkshopTrigger on Workshop__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
        TriggerDispatcher.Run(new WorkshopTriggerHandler());
}