@IsTest
private class AddPrimaryContactTest {
    @TestSetup
    static void setup(){
        List<Account> accountsNY = new List<Account>();
        List<Account> accountsCA = new List<Account>();

        for (Integer i=0; i <50; i++) {
            accountsNY.add(new Account(Name='Test', BillingState='NY'));
            accountsCA.add(new Account(Name='Test', BillingState='CA'));
        }
        insert accountsNY;
        insert accountsCA;
    }
    @IsTest
    static void testBehavior() {
        AddPrimaryContact addPrimaryContact = new AddPrimaryContact(new Contact(LastName='Test'), 'CA');
        Test.startTest();
        System.enqueueJob(addPrimaryContact);
        Test.stopTest();
        List<Account> result = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE BillingState = 'CA' ];
        List<Contact> resultContacts = [SELECT Id FROM Contact WHERE Account.BillingState = 'CA'];
        System.assertEquals(50, resultContacts.size());
    }
}