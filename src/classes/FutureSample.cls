/**
 * Created by hubert.bogusz on 01.04.2022.
 */

public class FutureSample {
    @future
    public static void someFutureMethod() {
        List<Account> accounts = [Select Id, Name from Account Limit 10];
        // process account records to do awesome stuff
    }
}