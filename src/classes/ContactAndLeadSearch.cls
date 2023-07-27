public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(String matchingName){
        List<List<sObject>> searchList =[FIND :matchingName IN ALL FIELDS
                                     RETURNING Lead(FirstName,LastName),Contact(FirstName,LastName)];
        return searchList;
    }
}