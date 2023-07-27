public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numberOfContacts, String createLastName){
         List<Contact> cons = new List<Contact>();
        for(Integer i=0;i<numberOfContacts;i++) {
            Contact c = new Contact(FirstName='Test' + i+1, LastName=createLastName);
            cons.add(c);
        }
        return cons;
    }
}