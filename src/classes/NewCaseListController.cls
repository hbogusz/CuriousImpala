public class NewCaseListController {
    public List<Case> getNewCases(){
        List<Case> results = [SELECT ID, CaseNumber
            FROM Case 
            WHERE Status='New'];
        return results;
}
}