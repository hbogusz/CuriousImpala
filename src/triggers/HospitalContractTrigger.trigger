/**
 * Created by hubert.bogusz on 12.04.2022.
 */

trigger HospitalContractTrigger on Hospital_Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (checkRecursive.runOnce()) {
        TriggerDispatcher.Run(new HospitalContractTriggerHandler());
    }
}