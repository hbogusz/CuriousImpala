@isTest
public class TestVerifyDate {
    @isTest static void testWithin30days() {
        Date date1 = Date.newInstance(1960, 2, 17);
        Date date2 = Date.newInstance(1960, 2, 27);
        Date days = VerifyDate.CheckDates(date1,date2);
        System.assertEquals(date2,days);
    }
   @isTest static void testBetweenMonths() {
        Date date1 = Date.newInstance(1960, 1, 21);
        Date date2 = Date.newInstance(1960, 2, 25);
        Date days = VerifyDate.CheckDates(date1,date2);
        System.assertEquals(Date.newInstance(1960, 1, 31),days);
    }
}