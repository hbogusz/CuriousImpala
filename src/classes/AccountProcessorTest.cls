@IsTest
private class AccountProcessorTest {
    @IsTest
    static void testBehavior() {
        Account acc = new Account(Name='Test');
        insert acc;
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{acc.Id});
        Test.stopTest();
    }
}