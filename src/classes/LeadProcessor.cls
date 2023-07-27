public class LeadProcessor implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT ID, LeadSource FROM Lead WHERE LeadSource <> \'Dreamforce\''
        );
    }
    public void execute(Database.BatchableContext bc, List<Lead> records) {
        for (Lead rec : records) {
            rec.LeadSource = 'DreamForce';
        }
        update records;
    }
    public void finish(Database.BatchableContext bc) {
    }
}