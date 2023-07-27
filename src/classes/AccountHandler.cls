public class AccountHandler {
    public static Account insertNewAccount(String NameAccount){
        try {
    Account acct = new Account(Name=NameAccount);
    // Insert the account 
    insert acct;
    return acct;
} catch (DmlException e) {
    System.debug('A DML exception has occurred: ' +
                e.getMessage());
    return null;
}
    }
}