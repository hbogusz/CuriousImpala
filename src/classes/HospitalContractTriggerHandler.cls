/**
 * Created by hubert.bogusz on 13.04.2022.
 */

public with sharing class HospitalContractTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean IsDisabled() {
        return TriggerDisabled;
    }
    public void BeforeInsert(List<SObject> newItems) {
        checkContract(newItems);
        System.debug('Before');
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        checkContract(newItems.values());
    }
    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterInsert(Map<Id, SObject> newItems) {
        checkDebug();
    }
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }

    public static void checkDebug(){
        System.debug('After');
    }
    public static void checkContract(List <Hospital_Contract__c> contracts) {
        Map <String, List <Hospital_Contract__c>> contractsMap = new Map<String, List<Hospital_Contract__c>>();
        Set <Id> hospitalIds = new Set<Id>();
        Set <Id> doctorsIds = new Set<Id>();
        String mapKey;

        for (Hospital_Contract__c doctorContract : contracts) {
            hospitalIds.add(doctorContract.Hospital__c);
            doctorsIds.add(doctorContract.Doctor__c);
        }

        List <Hospital_Contract__c> contractsFromDb = [
                SELECT Doctor__c, Hospital__c, Name, Start_Date__c, Expiration_Date__c
                FROM Hospital_Contract__c
                WHERE Doctor__c in :doctorsIds AND Hospital__c IN :hospitalIds
        ];
        for (Hospital_Contract__c contract : contractsFromDb) {
            if (contractsMap.containsKey((String) contract.Doctor__c + (String) contract.Hospital__c)) {
                contractsMap.get((String) contract.Doctor__c + (String) contract.Hospital__c).add(contract);
            } else {
                contractsMap.put((String) contract.Doctor__c + (String) contract.Hospital__c, new List<Hospital_Contract__c>{
                        contract
                });
            }
        }
        for (Hospital_Contract__c newContract : contracts) {
            mapKey = (String) newContract.Doctor__c + (String) newContract.Hospital__c;
            if (contractsMap.containsKey(mapKey)) {
                for (Hospital_Contract__c oldContract : contractsMap.get(mapKey)) {
                    if (oldContract.Id != newContract.Id || oldContract.Id == null) {
                        if (isActive(newContract) && isActive(oldContract)) {
                            newContract.AddError('Active contract already exists.');
                        }
                        if (!checkDate(newContract, oldContract)) {
                            newContract.AddError('Contract between provided dates already exists.\n It starts ' +
                                    oldContract.Start_Date__c.format() + ' and ' + (oldContract.Expiration_Date__c == null ? 'has no expiration date' : 'ends ' + oldContract.Expiration_Date__c.format() + '.'));
                        }
                    }
                }
                contractsMap.get(mapKey).add(newContract);
            } else {
                contractsMap.put(mapKey, new List<Hospital_Contract__c>{
                        newContract
                });
            }
        }
    }
    public static boolean checkDate(Hospital_Contract__c newContract, Hospital_Contract__c oldContract) {
        return (newContract.Start_Date__c > oldContract.Expiration_Date__c) ||
                (newContract.Start_Date__c < oldContract.Start_Date__c && newContract.Expiration_Date__c < oldContract.Start_Date__c);
    }
    public static boolean isActive(Hospital_Contract__c contract) {
        return contract.Start_Date__c <= Date.today() && contract.Expiration_Date__c >= Date.today();
    }

}