/**
 * Created by hubert.bogusz on 28.10.2022.
 */

public with sharing class HospitalBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT
                        Id, LastName
                FROM Contact
                WHERE LastName LIKE 'Test%'
        ]);
    }

        public void execute(Database.BatchableContext bc, List<Contact> scope){
            List<Contact> contacts = new List<Contact>();
            for (Contact contact : scope) {
                contact.LastName += ' Batch';
                recordsProcessed++;
                contacts.add(contact);
            }
            update contacts;
        }

        public void finish(Database.BatchableContext bc){
            System.debug(recordsProcessed + ' records processed. Shazam!');
        }
    }