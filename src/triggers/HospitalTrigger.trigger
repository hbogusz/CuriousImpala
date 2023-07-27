/**
 * Created by hubert.bogusz on 10.05.2022.
 */

trigger HospitalTrigger on Hospital__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.Run(new HospitalTriggerHandler());
}