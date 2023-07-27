public with sharing class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }
    public void execute(QueueableContext param1) {
        List<Account> accounts = [
                SELECT Id, Name, (SELECT id, FirstName, LastName FROM Contacts)
                From Account
                WHERE BillingState = :state
                LIMIT 200
        ];
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            Contact cont = contact.clone(false, false, false, false);
            cont.AccountId = acc.Id;
            contacts.add(cont);
        }

        if (contacts.size() > 0) {
            insert contacts;
        }

    }
}
