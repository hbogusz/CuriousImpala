/**
 * Created by jakub.urbanek on 09.05.2022.
 */
@RestResource(UrlMapping='/GetCountry/*')
global class HS_RestCountrySet {

    @HttpGet
    global static List<String> getCountryGlobalSet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        SObjectField picklistUsingGlobal = SObjectType.Doctor__c.fields.Country__c.getSObjectField();

        List<PicklistEntry> entries = picklistUsingGlobal.getDescribe().getPicklistValues();
        List<String> countriesAsString = new List<String>();
        for (Schema.PicklistEntry objPickList : entries) {
            countriesAsString.add(objPickList.getValue());
        }
        return countriesAsString;
    }
}