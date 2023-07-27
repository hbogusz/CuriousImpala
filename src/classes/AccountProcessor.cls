public with sharing class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds){
        List<Account> accounts = [
                SELECT (SELECT Id FROM Contacts), Number_Of_Contacts__c
                FROM Account
                WHERE Id IN :accountIds];
        for (Account acc : accounts){
            acc.Number_Of_Contacts__c = acc.Contacts.size();
        }
        update accounts;
    }

}