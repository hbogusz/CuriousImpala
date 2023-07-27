/**
 * Created by hubert.bogusz on 08.05.2022.
 */

public with sharing class SearchWorkshopController {
    public Workshop__c searchWorkshop {get; set;}
    public Workshop__c newWorkshop {get; set;}
    public Workshop__c workshopToEdit {get; set;}
    public List<Workshop__c> workshops {get; set;}
    public List<Workshop__c> workshopsGroup {get; set;}
    public boolean isNewClicked {get; set;}
    public boolean isDeleteClicked {get; set;}
    public boolean isEditClicked {get; set;}
    public boolean isDisabled {get; set;}
    public Integer pageSize {get; set;}
    public Integer counter {get; set;}
    public boolean hasPrevious { get; set; }
    public boolean hasNext { get; set; }
    public List<SelectOption> countryOptions {set;}
    public String workshopId  { get; set; }
    public String successClass  { get; set; }
    public String errorClass  { get; set; }
    public String warningClass  { get; set; }
    public String errorContent { get; set; }
    public String warningContent { get; set; }
    private String accessToken;

    public SearchWorkshopController() {
        successClass = ' slds-hidden ';
        errorClass = ' slds-hidden ';
        warningClass = ' slds-hidden ';
        searchWorkshop = new Workshop__c();
        newWorkshop = new Workshop__c();
        workshopToEdit = new Workshop__c();
        workshops = new List<Workshop__c>();
        workshopsGroup = new List<Workshop__c>();
        if (String.isBlank(accessToken)){
            accessToken = getRequestToken();
        }
        getCountryOptions();
        isNewClicked=false;
        isDisabled=true;
        pageSize=5;
        counter=0;
    }

    public PageReference refreshPageSize() {
        spreadWorkshops();
        checkButtons();
        return null;
    }
    public class responseWrapper {
        public string id;
        public string access_token;
        public string instance_url;
    }
    public string getRequestToken() {
/*        Target_Org__c credentials = Target_Org__c.getInstance();
        String reqBody = 'grant_type=password&client_id='
                + credentials.Client_Id__c + '&client_secret='
                + credentials.Client_Secret__c + '&username='
                + credentials.Username__c + '&password=' + credentials.Password__c;*/
        String reqBody =  'grant_type=password&client_id=3MVG9t0sl2P.pByrQA1yKEMcDROdYuiBeLb9VW.PVUw22dikG11onxndOXmV6lvQxyOiMbaVYHr.WTL2La0JK&client_secret='
                + '4E686D1155D979B51112633D59173960ADC953C946C8E870F5B1E85AFAA71C08&username='
                + 'hubert.bogusz99@gmail.com&password=Greenday7956CRCR0LBEpLabeFJrkiypzfkFf';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse hresp = h.send(req);
        responseWrapper wResp = (responseWrapper) JSON.deserialize(hresp.getBody(), responseWrapper.class);
        //Cache.Org.getPartition('local.SessionCache').put('orgToken', wResp.access_token);
        return wResp.access_token;
    }
    public void getWorkshops() {
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops/?name=' + searchWorkshop.Name + '&country=' + searchWorkshop.Country__c;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        HttpResponse httpResponse = http.send(request);
        List<RESTWrappers.WorkshopRESTWrapper> workshopsResponse = (List<RESTWrappers.WorkshopRESTWrapper>) JSON.deserialize(httpResponse.getBody(), List<RESTWrappers.WorkshopRESTWrapper>.class);
        workshops = convertWrappersToWorkshops(workshopsResponse);
    }
    public List<SelectOption> getCountryOptions() {
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/data/v39.0/tooling/sobjects/GlobalValueSet/0Nt7Q000000kj8G';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        HttpResponse httpResponse = http.send(request);
        List <String> countries = new List<String>();
        countries = GlobalValueSetWrapper.getPicklistValues(httpResponse);
        List<SelectOption> options = new List<SelectOption>();
        for ( String country : countries){
            if(country != 'null'){
                options.add(new SelectOption(country, country));
            }
        }
        return options;
    }

    public void searchWorkshops(){
        hideToasts();
        try{
            getWorkshops();
            if(workshops.size() == 0){
                warningContent = 'There\'s no records with provided criteria';
                showWarningToast();
            } else {
                spreadWorkshops();
            }
            checkButtons();
            checkIfFieldsEmpty();
        } catch (Exception e) {
            errorContent = e.getMessage();
            showErrorToast();
        }
    }

    public void createWorkshop() {
        try{
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setBody(JSON.serialize(convertWorkshopToWrapper(newWorkshop)));
        HttpResponse httpResponse = http.send(request);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }

    public void create(){
        try{
            createWorkshop();
            searchWorkshops();
            hideNewModal();
            showSuccessToast();
        } catch (Exception e) {
            errorContent = e.getMessage();
            showErrorToast();
        }
    }

    public void deleteWorkshop(){
        try{
            string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops/' + workshopId;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('DELETE');
            request.setEndpoint(endPoint);
            HttpResponse httpResponse = http.send(request);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }

    public void deleteAction(){
        try{
            deleteWorkshop();
            hideDeleteModal();
            searchWorkshops();
            showSuccessToast();
        } catch (Exception e) {
            errorContent = e.getMessage();
            showErrorToast();
        }
    }

    public void editWorkshop(){
        try{
            string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops/' + workshopId;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('PATCH');
            request.setEndpoint(endPoint);
            request.setBody(JSON.serialize(convertWorkshopToWrapper(workshopToEdit)));
            HttpResponse httpResponse = http.send(request);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    public void edit(){
        try{
            editWorkshop();
            hideEditModal();
            searchWorkshops();
            showSuccessToast();
        } catch (Exception e) {
            errorContent = e.getMessage();
            showErrorToast();
        }
    }

    public void spreadWorkshops() {
        if(workshopsGroup.size() > 0){
            workshopsGroup.clear();
        }
        for (Integer i=counter; i < pageSize+counter ; i++) {
            workshopsGroup.add(workshops.get(i));
            if (i == workshops.size() - 1) {
                break;
            }
        }
    }

    public void checkIfFieldsEmpty() {
        if (workshops.size() > 0 || String.isNotBlank(searchWorkshop.Name)
                || String.isNotBlank(searchWorkshop.Country__c)) {
            isDisabled = false;
        } else {
            isDisabled = true;
        }
    }

    public void showNewModal(){
        newWorkshop = new Workshop__c();
        isNewClicked = true;
    }
    public void hideNewModal(){
        isNewClicked = false;
        hideToasts();
    }

    public void showDeleteModal(){
        System.debug('Mechanic:' + workshopId);
        isDeleteClicked = true;
    }
    public void hideDeleteModal(){
        isDeleteClicked = false;
        hideToasts();
    }
    public void showEditModal(){
        for (Workshop__c workshop : workshops){
            if (workshop.External_Id__c == workshopId) {
                workshopToEdit = workshop;
            }
        }
        System.debug('Mechanic:' + workshopId);
        isEditClicked = true;
    }
    public void hideEditModal(){
        isEditClicked = false;
        hideToasts();
    }

    public void showErrorToast(){
        errorClass = '';
    }
    public void hideErrorToast(){
        errorClass = ' slds-hidden ';
    }
    public void showSuccessToast(){
        successClass = '';
    }
    public void hideSuccessToast(){
        successClass = ' slds-hidden ';
    }
    public void showWarningToast(){
        warningClass = '';
    }
    public void hideWarningToast(){
        warningClass = ' slds-hidden ';
    }
    public void hideToasts(){
        hideErrorToast();
        hideWarningToast();
        hideSuccessToast();
    }

    public void clearFields() {
        hideToasts();
        if (searchWorkshop != null) {
            searchWorkshop = new Workshop__c();
        }
        if (workshops != null) {
            workshops.clear();
        }
        isDisabled = true;
    }

    public void checkButtons(){
        if (workshops.size() > pageSize && counter != ((Integer) Math.ceil(Double.valueOf(workshops.size())/Double.valueOf(pageSize)) - 1) * pageSize) {
            hasNext = true;
        } else {
            hasNext = false;
        }
        if (counter > 0) {
            hasPrevious = true;
        } else {
            hasPrevious = false;
        }
    }

    public void first(){
        counter = 0;
        refreshPageSize();
    }
    public void previous(){
        counter = counter - pageSize;
        refreshPageSize();
    }
    public void next(){
        counter =+ pageSize;
        refreshPageSize();
    }
    public void last(){
        counter = ((Integer) Math.ceil(Double.valueOf(workshops.size())/Double.valueOf(pageSize)) - 1) * pageSize ;
        refreshPageSize();
    }

    private static List <Workshop__c> convertWrappersToWorkshops(List <RESTWrappers.WorkshopRESTWrapper> workshopRESTWrappers){
        List <Workshop__c> workshops = new List<Workshop__c>();
        for (RESTWrappers.WorkshopRESTWrapper wrapper: workshopRESTWrappers){
            Workshop__c workshop= new Workshop__c(
                    External_Id__c = wrapper.id,
                    Name = wrapper.name,
                    City__c = wrapper.city,
                    Country__c = wrapper.country,
                    Email__c = wrapper.email,
                    Opening_Hours__c = wrapper.openingHours,
                    Phone__c = wrapper.phone,
                    Street__c = wrapper.street
            );
            workshops.add(workshop);
        }
        return workshops;
    }
    private static List<RESTWrappers.WorkshopRESTWrapper> convertWorkshopToWrapper(Workshop__c workshop) {
        List<RESTWrappers.WorkshopRESTWrapper> wrappers = new List<RESTWrappers.WorkshopRESTWrapper>();
            RESTWrappers.WorkshopRESTWrapper workshopRESTWrapper = new RESTWrappers.WorkshopRESTWrapper();
            workshopRESTWrapper.name = workshop.Name;
            workshopRESTWrapper.city = workshop.City__c;
            workshopRESTWrapper.country = workshop.Country__c;
            workshopRESTWrapper.phone = workshop.Phone__c;
            workshopRESTWrapper.openingHours = workshop.Opening_Hours__c;
            workshopRESTWrapper.street = workshop.Street__c;
            workshopRESTWrapper.email = workshop.Email__c;
            workshopRESTWrapper.disableTrigger = false;
        wrappers.add(workshopRESTWrapper);
        return wrappers;
    }

}