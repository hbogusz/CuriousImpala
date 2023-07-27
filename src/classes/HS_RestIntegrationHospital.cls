@RestResource(UrlMapping='/TriggerCalloutsHospital/*')
global class HS_RestIntegrationHospital {

    @HttpPost
    global static String createNewHospital() {

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.toString();
        List<responseWrapper> wResps = (List<responseWrapper>) JSON.deserialize(jsonString, List<responseWrapper>.class);
        List<Hospital__c> hospitals = new List<Hospital__c>();

        for (responseWrapper wResp : wResps) {
            Hospital__c hospital = new Hospital__c();
            hospital.Name = wResp.name;
            hospital.Country__c = wResp.Country;
            hospital.External_Id__c = wResp.id;  

            hospitals.add(hospital);
        }

        try {
            System.debug('tryHospital');
            Database.insert(hospitals);
        }catch (DMLException e){
            System.debug(e);
        }


        return 'Success';
    }

    global class responseWrapper {
        global String id { get; set; }
        global String name { get; set; }
        global String Country { get ; set; }
        global String ExternalId {get; set;}
    }


}