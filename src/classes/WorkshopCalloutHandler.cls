/**
 * Created by hubert.bogusz on 11.05.2022.
 */

public with sharing class WorkshopCalloutHandler {
    public String createResponseStatus { get; set; }

    public LogHandler__c createWorkShop(List<Workshop__c> newWorkshops) {
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = AuthorizeClass.getRequestToken();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setBody(JSON.serialize(convertWorkshopsToWrappers(newWorkshops)));
        HttpResponse httpResponse = http.send(request);
        LogHandler__c log = createLogEntry(request, httpResponse, 'Workshop', 'insert');
        RESTWrappers.WorkshopResponse workshopResponse = (RESTWrappers.WorkshopResponse) JSON.deserialize(httpResponse.getBody(), RESTWrappers.WorkshopResponse.class);
        setExternalID(workshopResponse.addedWorkshops);
        return log;
    }


    public LogHandler__c updateWorkshop(List<Workshop__c> newWorkshops) {
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops/' + newWorkshops.get(0).External_Id__c;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = AuthorizeClass.getRequestToken();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('PATCH');
        request.setEndpoint(endPoint);
        request.setBody(JSON.serialize(convertWorkshopsToWrappers(newWorkshops)));
        HttpResponse httpResponse = http.send(request);
        LogHandler__c log = createLogEntry(request, httpResponse, 'Workshop', 'update');
        RESTWrappers.WorkshopResponse workshopResponse = (RESTWrappers.WorkshopResponse) JSON.deserialize(httpResponse.getBody(), RESTWrappers.WorkshopResponse.class);
        if (workshopResponse.addedWorkshops != null) {
            setExternalID(workshopResponse.addedWorkshops);
        }
        return log;
    }
    public LogHandler__c deleteWorkshop(List<Workshop__c> oldWorkshops) {
        string endPoint = 'https://empathetic-shark-tza12g-dev-ed.my.salesforce.com/services/apexrest/Workshops/' + oldWorkshops.get(0).External_Id__c;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = AuthorizeClass.getRequestToken();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('DELETE');
        request.setEndpoint(endPoint);
        HttpResponse httpResponse = http.send(request);
        LogHandler__c log = createLogEntry(request, httpResponse, 'Workshop', 'delete');
        return log;
    }

    private static void setExternalID(List <Workshop__C> responseWorkshops) {
        List <Id> ids = new List<Id>();
        List<String> externalIds = new List<String>();
        if (responseWorkshops != null) {
            for (Workshop__C workshop : responseWorkshops) {
                ids.add(workshop.Id);
                externalIds.add(workshop.External_Id__c);
            }
            List<Workshop__C> workshops = [
                    SELECT Id,External_Id__c, Name, Country__c, City__C, Street__c, Phone__c, Opening_Hours__c, Email__c
                    FROM Workshop__c
                    WHERE Id IN :externalIds
            ];
            for (Integer i = 0; i < workshops.size(); i++) {
                workshops.get(i).External_Id__c = ids.get(i);
            }
            Switcher__c triggerSwitcher = Switcher__c.getInstance(UserInfo.getProfileId());
            triggerSwitcher.Disabled__c = true;
            update triggerSwitcher;
            update workshops;
            triggerSwitcher.Disabled__c = false;
            update triggerSwitcher;
        }
    }

    private static Workshop__c convertWrapperToWorkshop(RESTWrappers.WorkshopRESTWrapper wrapper) {
        Workshop__c workshop = new Workshop__c(
                Name = wrapper.name,
                City__c = wrapper.city,
                Country__c = wrapper.country,
                Email__c = wrapper.email,
                Phone__c = wrapper.phone,
                Street__c = wrapper.street
        );
        return workshop;
    }

    private static List <RESTWrappers.WorkshopRESTWrapper> convertWorkshopsToWrappers(List<Workshop__c> workshops) {
        List <RESTWrappers.WorkshopRESTWrapper> wrappers = new List<RESTWrappers.WorkshopRESTWrapper>();
        for (Workshop__c workshop : workshops) {
            RESTWrappers.WorkshopRESTWrapper workshopRESTWrapper = new RESTWrappers.WorkshopRESTWrapper();
            workshopRESTWrapper.id = workshop.id;
            workshopRESTWrapper.name = workshop.Name;
            workshopRESTWrapper.city = workshop.City__c;
            workshopRESTWrapper.country = workshop.Country__c;
            workshopRESTWrapper.phone = workshop.Phone__c;
            workshopRESTWrapper.street = workshop.Street__c;
            workshopRESTWrapper.email = workshop.Email__c;
            workshopRESTWrapper.disableTrigger = true;
            wrappers.add(workshopRESTWrapper);
        }

        return wrappers;
    }

    public static LogHandler__c createLogEntry(HttpRequest request, HttpResponse response, String objectName, String operation) {

        LogHandler__c logHandler = new LogHandler__c();
        RESTWrappers.WorkshopResponse workshopResponse = (RESTWrappers.WorkshopResponse) JSON.deserialize(response.getBody(), RESTWrappers.WorkshopResponse.class);
        List<RESTWrappers.WorkshopRESTWrapper> workshopRESTWrappers = (List<RESTWrappers.WorkshopRESTWrapper>) JSON.deserialize(request.getBody(), List<RESTWrappers.WorkshopRESTWrapper>.class);
        logHandler.Request_body__c = request.getBody();
        logHandler.Request_endpoint__c = request.getEndpoint();
        logHandler.Response_status_code__c = String.valueOf(response.getStatusCode());
        logHandler.Response_body__c = String.valueOf(JSON.deserializeUntyped(response.getBody()));
        logHandler.Status__c = response.getStatus();
        logHandler.Create_Date__c = Date.today();
        logHandler.Object__c = objectName;
        logHandler.ObjectId__c = workshopRESTWrappers.get(0).id;
        logHandler.Success__c = workshopResponse.status == 'success' ? true : false;
        logHandler.Operation__c = operation;


        insert logHandler;
        return logHandler;

    }

    public class ResponseWrapper {
        public String status;
        public String errorMessage;
    }
}