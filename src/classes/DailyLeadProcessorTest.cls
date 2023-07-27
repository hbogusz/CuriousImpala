@IsTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    @TestSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        for (Integer i=0; i < 200; i++) {
            leads.add(new Lead(LastName='Test'+i, Company='Test'+i));
        }
        insert leads;
    }
    @IsTest
    static void testBehavior() {

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new DailyLeadProcessor());
        Test.stopTest();
        List <Lead> result = [SELECT Id, LeadSource FROM Lead WHERE LeadSource='Dreamforce'];
        Assert.areEqual(200, result.size());
    }
}