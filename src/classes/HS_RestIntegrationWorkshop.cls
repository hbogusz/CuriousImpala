@RestResource(UrlMapping='/TriggerCalloutsWorkshop/*')
global class HS_RestIntegrationWorkshop {
    private static final String ERROR = 'error';
    private static final String SUCCESS = 'success';

    @HttpPost
    global static RESTWrappers.WorkshopResponse createNewWorkshops() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.toString();
        List<RESTWrappers.WorkshopRESTWrapper> wResps = (List<RESTWrappers.WorkshopRESTWrapper>) JSON.deserialize(jsonString, List<RESTWrappers.WorkshopRESTWrapper>.class);
        List<Workshop__c> workshops = new List<Workshop__c>();

        workshops = convertWrappersToWorkshops(wResps);

        RESTWrappers.WorkshopResponse response = new RESTWrappers.WorkshopResponse();

        Switcher__c triggerSwitcher = Switcher__c.getInstance(UserInfo.getProfileId());
        triggerSwitcher.Disabled__c = wResps.get(0).disableTrigger;

        try {
            update triggerSwitcher;
            Database.insert(workshops);
            response.status = SUCCESS;
            response.addedWorkshops = workshops;     
            triggerSwitcher.Disabled__c = false;
            update triggerSwitcher;
        }catch (DMLException e){
            response.status = ERROR;
            response.errorMessage = e.getMessage();
        }

        return response;
    }


    @HttpGet
    global static List <responseWrapper> getWorkshops() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List <responseWrapper> workshopWrappers = new List<responseWrapper>();
        String query = ' SELECT Country__c, id, Name FROM Workshops ';


        List <Workshop__c> workshops = new List <Workshop__c>();
        workshops = Database.query(query);

        for (Workshop__c workshop : workshops) {
            responseWrapper workshopWrapper = new responseWrapper();
            workshopWrapper.name = workshop.Name;
            workshopWrapper.id = workshop.id;
            workshopWrapper.Country = workshop.Country__c;
            workshopWrappers.add(workshopWrapper);
        }
        return workshopWrappers;
    }
    
     @HttpPatch
        global static RESTWrappers.WorkshopResponse updateWorkshop(){
        RestRequest request = RestContext.request;
        String workshopId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        String requestString = request.requestBody.toString();
        
        List<RESTWrappers.WorkshopRESTWrapper> workshopRESTWrappers = (List<RESTWrappers.WorkshopRESTWrapper>) JSON.deserialize(requestString, List<RESTWrappers.WorkshopRESTWrapper>.class);
        RESTWrappers.WorkshopResponse response = new RESTWrappers.WorkshopResponse();
        List<Workshop__c> workshopsToUpdate = new List<Workshop__c>();

        workshopsToUpdate = [
        SELECT Id, External_Id__c, Name,Phone__c,Email__c, Country__c, City__c, Street__c
        FROM Workshop__c
        WHERE Id=:workshopId        
        ];
        
        Switcher__c triggerSwitcher = Switcher__c.getInstance(UserInfo.getProfileId());
        triggerSwitcher.Disabled__c = workshopRESTWrappers.get(0).disableTrigger;
        update triggerSwitcher;
        
        if (workshopsToUpdate.isEmpty()){
          for (RESTWrappers.WorkshopRESTWrapper wrapper: workshopRESTWrappers ) {
            Workshop__c workshop = new Workshop__c();
            workshop.Name = wrapper.name;
            workshop.Phone__c = wrapper.phone;
            workshop.Email__c = wrapper.email;
            workshop.Country__c = wrapper.Country;
            workshop.External_Id__c = wrapper.id; 
            workshopsToUpdate.add(workshop);
        }
          try {     
            insert workshopsToUpdate;
            response.status = SUCCESS;
            response.addedWorkshops = workshopsToUpdate; 
        } catch (Exception e) {
            response.status = ERROR;
            response.errorMessage += e.getMessage();
        }
                 
        } else {
        
        for (Workshop__c workshop : workshopsToUpdate){
        RESTWrappers.WorkshopRESTWrapper wrapperUpdated = workshopRESTWrappers.get(0);
        workshop.Name = wrapperUpdated.name;
        workshop.Phone__c = wrapperUpdated.phone;
        workshop.Email__c = wrapperUpdated.email;
        workshop.Country__c = wrapperUpdated.country;
        } 

       try {     
            update workshopsToUpdate;
            response.status = SUCCESS;
        } catch (Exception e) {
            response.status = ERROR;
            response.errorMessage += e.getMessage();
        }
        }
        triggerSwitcher.Disabled__c = false;
        update triggerSwitcher;
        return response;
    }
    
        @HttpDelete
    global static RESTWrappers.WorkshopResponse deleteWorkshop(){
        RESTWrappers.WorkshopResponse response = new RESTWrappers.WorkshopResponse();
        RestRequest request = RestContext.request;
        String workshopId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        List <Workshop__c> workshopsToDelete = new List <Workshop__c>();

        workshopsToDelete = [
                SELECT Id
                FROM Workshop__c
                WHERE Id = :workshopId
        ];
        
        if(!workshopsToDelete.isEmpty()){
        try {
            delete workshopsToDelete;
            response.status = SUCCESS;           
        } catch (Exception e) {
            response.status = ERROR;
            response.errorMessage += e.getMessage();
        }
        } else {
        response.status = ERROR;
        response.errorMessage = 'No workshops with this ID';
        }
        return response;
    }

    private static List<Workshop__c> convertWrappersToWorkshops(List<RESTWrappers.WorkshopRESTWrapper> wrappers){
        List<Workshop__c> workshops = new List<Workshop__c>();
        for (RESTWrappers.WorkshopRESTWrapper wrapper : wrappers){
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


    global class responseWrapper {
        global String id { get; set; }
        global String name { get; set; }
        global String Country { get ; set; }
        global String ExternalId {get; set;}
        global boolean disableTrigger {get; set;}
    }
}