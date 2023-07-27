@IsTest
private class LeadProcessorTest {
    @IsTest
    static void testBehavior() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(LastName='Test',Company='Test'));
        }
        insert leads;
        Test.startTest();
        LeadProcessor leadProcessor = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcessor);
        Test.stopTest();
    }
}