public class ContactSearch {
    public static Contact[] searchForContacts(String matchingLastName, String matchingPostlCode){
        Contact[] cts = [SELECT ID,Name FROM Contact 
                 WHERE LastName =:matchingLastName AND MailingPostalCode=:matchingPostlCode];
        return cts;
    }
}