/**
 * Created by hubert.bogusz on 28.04.2022.
 */

public with sharing class SearchMechanicHandler {
    public MechanicWrapper searchMechanicWrapper { get; set; }
    public MechanicWrapper mechanicWrapper { get; set; }
    public MechanicWrapper mechanicWrapperToEdit { get; set; }
    public List <MechanicWrapper> mechanics { get; set; }
    public List <soapSforceComSchemasClassSoapwebser.MechanicWrapper> mechanicWrappers { get; set; }
    public List<String> conditions = new List<String>();
    public boolean isDisabled { get; set; }
    public boolean isEditClicked { get; set; }
    public boolean isDeleteClicked { get; set; }
    public boolean isNewClicked { get; set; }
    public boolean hasPrevious { get; set; }
    public boolean hasNext { get; set; }
    public PageReference pageReference { get; set; }
    public Id mechanicId { get; set; }
    public Integer pageSize { get; set; }
    public Integer counter { get; set; }
    public soapSforceComSchemasClassSoapwebser.WEBMechanicIdRequest mechanicIdRequest { get; set; }
    public List<SelectOption> countryOptions {set;}
    public String successClass  { get; set; }
    public String errorClass  { get; set; }
    public String warningClass  { get; set; }
    public String errorContent { get; set; }
    public String warningContent { get; set; }
    public static String sessionIdFromCache { get; set; }

    public soapSforceComSchemasClassSoapwebser.SOAPWebService soapService;
    public soapSforceComSchemasClassSoapwebser.SessionHeader_element sessionHeader;
    public partnerSoapSforceCom.LoginResult loginResult;
    public partnerSoapSforceCom.Soap partnerSoap;
    public Target_Org__c credentials = Target_Org__c.getInstance();
    public Cache.OrgPartition orgPartition = Cache.Org.getPartition('local.SessionCache');


    public SearchMechanicHandler() {
        successClass = ' slds-hidden ';
        errorClass = ' slds-hidden ';
        warningClass = ' slds-hidden ';
        mechanicWrapper = new MechanicWrapper();
        searchMechanicWrapper = new MechanicWrapper();
        mechanicWrapperToEdit = new MechanicWrapper();
        mechanicIdRequest = new soapSforceComSchemasClassSoapwebser.WEBMechanicIdRequest();
        mechanics = new List<MechanicWrapper>();
        isDisabled = true;
        isDeleteClicked = false;
        isEditClicked = false;
        isNewClicked = false;

        this.soapService = new soapSforceComSchemasClassSoapwebser.SOAPWebService();
        this.sessionHeader = new soapSforceComSchemasClassSoapwebser.SessionHeader_element();
        this.partnerSoap = new partnerSoapSforceCom.Soap();

        if (String.isBlank(sessionIdFromCache)) {
            sessionIdFromCache = (String) orgPartition.get('sessionId');
        }
        if (sessionIdFromCache != null) {
            try {
                this.SessionHeader.sessionId = sessionIdFromCache;
                this.soapService.SessionHeader = sessionHeader;
            } catch (Exception e) {
                login();
                errorContent = e.getMessage();
                showErrorToast();
            }
        } else {
            login();
        }

        mechanicWrappers = new List<soapSforceComSchemasClassSoapwebser.MechanicWrapper>();
        pageReference = ApexPages.currentPage();
        counter = 0;
        pageSize = 5;

    }

    public void login() {
        loginResult = partnerSoap.login(credentials.Username__c, credentials.Password__c);
        String sessionId = loginResult.sessionId;
        sessionHeader.sessionId = sessionId;
        soapService.SessionHeader = sessionHeader;
        orgPartition.put('sessionId', sessionId);
    }


    public PageReference searchMechanics() {
        hideToasts();
        counter=0;
        isDisabled = false;
        if (mechanics.size() > 0) {
            mechanics.clear();
        }
        String query = 'SELECT Id, Name, First_Name__c, Country__c, Email__c, Private_Phone__c, City__c, Street__c, Date_Of_Birth__c FROM Mechanic__c ';
        conditions.clear();

        if (String.isNotBlank(searchMechanicWrapper.firstName)) {
            conditions.add('First_Name__c LIKE \'' + searchMechanicWrapper.firstName + '%\'');
        }
        if (String.isNotBlank(searchMechanicWrapper.lastName)) {
            conditions.add('Name LIKE \'' + searchMechanicWrapper.lastName + '%\'');
        }
        if (String.isNotBlank(searchMechanicWrapper.email)) {
            conditions.add('Email__c LIKE \'' + searchMechanicWrapper.email + '%\'');
        }
        if (String.isNotBlank(searchMechanicWrapper.country)) {
            conditions.add('Country__c LIKE \'' + searchMechanicWrapper.country + '%\'');
        }
        if (conditions.size() > 0) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }


        mechanicWrappers = soapService.queryMechanics(query);
        System.debug('mechanicWrappers' + mechanicWrappers);
        if (mechanicWrappers == null) {
            warningContent = 'There\'s no records with provided criteria';
            showWarningToast();
        } else {
            spreadMechanics();
            checkButtons();
            }
        return null;
    }

    public void spreadMechanics() {
        if(mechanics.size() > 0){
            mechanics.clear();
        }
        for (Integer i=counter; i < pageSize+counter ; i++) {
            mechanics.add(mechanicToWrapper(mechanicWrappers.get(i)));
            if (i == mechanicWrappers.size() - 1) {
                break;
            }
        }
    }

    public PageReference refreshPageSize() {
        spreadMechanics();
        checkButtons();
        return null;
    }

    public void createMechanic() {
        hideToasts();
        if (String.isBlank(mechanicWrapper.lastName)) {
            errorContent = 'Last Name can\'t be empty';
            showErrorToast();
        } else {
            try {
                soapService.createMechanic(wrapperToMechanic(mechanicWrapper));
                mechanicWrapper = new MechanicWrapper();
                hideNewModal();
                searchMechanics();
                showSuccessToast();
            } catch (Exception e) {
                errorContent = e.getMessage();
                showErrorToast();
            }
        }
    }

    public void editMechanic() {
        hideToasts();
        mechanicIdRequest.mechanicId = mechanicId;
        if (String.isBlank(mechanicWrapperToEdit.lastName)) {
            errorContent = 'Last Name can\'t be empty';
            showErrorToast();
        } else {
            try {
                mechanicIdRequest.mechanicId = mechanicId;
                soapService.updateMechanic(wrapperToMechanic(mechanicWrapperToEdit), mechanicIdRequest);
                hideEditModal();
                searchMechanics();
                showSuccessToast();
            } catch (Exception e) {
                errorContent = e.getMessage();
                showErrorToast();
            }
        }
    }

    public void deleteMechanic() {
        hideToasts();
        try{
            mechanicIdRequest.mechanicId = mechanicId;
            soapService.deleteMechanicById(mechanicIdRequest);
            hideDeleteModal();
            searchMechanics();
            showSuccessToast();
        } catch (Exception e) {
            errorContent = e.getMessage();
            showErrorToast();
        }
    }


    public void showNewModal() {
        mechanicWrapper = new MechanicWrapper();
        isNewClicked = true;
    }
    public void hideNewModal() {
        isNewClicked = false;
        hideToasts();
    }
    public void showDeleteModal(){
        System.debug('Mechanic:' + mechanicId);
        isDeleteClicked = true;
    }
    public void hideDeleteModal(){
        isDeleteClicked = false;
        hideToasts();
    }
    public void showEditModal(){
        for (MechanicWrapper wrapper : mechanics){
            if (wrapper.Id == mechanicId) {
                mechanicWrapperToEdit = wrapper;
            }
        }
        System.debug('Mechanic:' + mechanicId);
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
        if (searchMechanicWrapper != null) {
            searchMechanicWrapper = new MechanicWrapper();
        }
        if (mechanics != null) {
            mechanics.clear();
        }
        isDisabled = true;
    }

    public void checkIfFieldsEmpty() {
        if (mechanics.size() > 0 || String.isNotBlank(mechanicWrapper.firstName)
                || String.isNotBlank(mechanicWrapper.lastName) || String.isNotBlank(mechanicWrapper.email) || String.isNotBlank(mechanicWrapper.country)) {
            isDisabled = false;
        } else {
            isDisabled = true;
        }
    }

    public List<SelectOption> getCountryOptions () {
        List<SelectOption> options = new List<SelectOption>();
        List <String> countries = soapService.getCountryGlobalSet();
        for(String country : countries) {
            options.add(new SelectOption(country,country));
        }
        return options;
    }
    public void checkButtons(){
        if (mechanicWrappers.size() > pageSize && counter != ((Integer) Math.ceil(Double.valueOf(mechanicWrappers.size())/Double.valueOf(pageSize)) - 1) * pageSize) {
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
        counter = ((Integer) Math.ceil(Double.valueOf(mechanicWrappers.size())/Double.valueOf(pageSize)) - 1) * pageSize ;
        refreshPageSize();
    }


    public static MechanicWrapper mechanicToWrapper(soapSforceComSchemasClassSoapwebser.MechanicWrapper mechanic) {
        MechanicWrapper mechanicWrapper = new MechanicWrapper();
        mechanicWrapper.Id =  mechanic.mechanicId;
        mechanicWrapper.firstName = mechanic.firstName;
        mechanicWrapper.lastName = mechanic.lastName;
        mechanicWrapper.email = mechanic.email;
        mechanicWrapper.dateOfBirth = mechanic.dateOfBirth;
        mechanicWrapper.city = mechanic.city;
        mechanicWrapper.country = mechanic.country;
        mechanicWrapper.street = mechanic.street;
        mechanicWrapper.phone = mechanic.phone;
        return mechanicWrapper;
    }

    public static soapSforceComSchemasClassSoapwebser.MechanicWrapper wrapperToMechanic(MechanicWrapper mechanicWrapper) {
        soapSforceComSchemasClassSoapwebser.MechanicWrapper mechanic = new soapSforceComSchemasClassSoapwebser.MechanicWrapper();
        mechanic.lastName = mechanicWrapper.lastName;
        mechanic.firstName = mechanicWrapper.firstName;
        mechanic.email = mechanicWrapper.email;
        mechanic.dateOfBirth = mechanicWrapper.dateOfBirth;
        mechanic.city = mechanicWrapper.city;
        mechanic.country = mechanicWrapper.country;
        mechanic.street = mechanicWrapper.street;
        mechanic.phone = mechanicWrapper.phone;
        return mechanic;
    }

    public class MechanicWrapper {
        public String Id { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String email { get; set; }
        public String dateOfBirth { get; set; }
        public String city { get; set; }
        public String country { get; set; }
        public String street { get; set; }
        public String phone { get; set; }
    }


}