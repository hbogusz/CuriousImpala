/**
 * Created by jakub.urbanek on 06.05.2022.
 */
@RestResource(UrlMapping='/RestAuth/*')
global class HS_RestIntegration {

        @HttpGet
        global static List <responseWrapper> fetchHospital() {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            List <responseWrapper> hospitalWrappers = new List<responseWrapper>();
            List <String> conditions = new List<String>();
            String query = ' SELECT Country__c, id, Name FROM Hospital__c ';
            String name = req.params.get('name');
            String country = req.params.get('country');

            if (String.isNotBlank(name)) {
                conditions.add('Name LIKE ' + '\'' + name + '%\'');
            }
            if (String.isNotBlank(country)) {
                conditions.add('Country__c LIKE ' + '\'' + country + '%\'');
            }
            if (conditions.size() > 0) {
                query += 'WHERE ' + conditions[0];
                for (Integer i = 1; i < conditions.size(); i++) {
                    query += ' AND ' + conditions[i];
                }
            }
            List <Hospital__c> hospitals = new List <Hospital__c>();
            hospitals = Database.query(query);

            for(Hospital__c hospital : hospitals){
               responseWrapper hospitalWrapper = new responseWrapper();
                hospitalWrapper.name = hospital.Name;
                hospitalWrapper.id = hospital.id;
                hospitalWrapper.Country = hospital.Country__c;
                hospitalWrappers.add(hospitalWrapper);
            }
            return hospitalWrappers;
        }


    @HttpPost
    global static String createNewHospital(){

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.toString();
        responseWrapper wResp = (responseWrapper) JSON.deserialize(jsonString,responseWrapper.class);

        Hospital__c hospital = new Hospital__c();
        hospital.Name = wResp.name;
        hospital.Country__c = wResp.Country;
        Insert hospital;

        return 'Success';
    }

    @HttpDelete
    global static String deleteHospital(){

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.toString();
        responseWrapper wResp = (responseWrapper) JSON.deserialize(jsonString,responseWrapper.class);

        Hospital__c hospital = new Hospital__c();
        hospital = [SELECT id,Name FROM Hospital__c WHERE id=: wResp.id];

        if(hospital != null){
            delete hospital;
        }

        return 'Success';
    }

    @HttpPut
    global static String updateHospital(){

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.toString();
        responseWrapper wResp = (responseWrapper) JSON.deserialize(jsonString,responseWrapper.class);

        String name = req.params.get('name');
        String country = req.params.get('country');

        Hospital__c hospital = new Hospital__c();
        hospital = [SELECT id,Name FROM Hospital__c WHERE id=: wResp.id];

        hospital.Name = name;
        hospital.Country__c = country;
        if(hospital != null){
            update hospital;
        }

        return 'Success';
    }

        global class responseWrapper{
            global String id {get;set;}
            global String name {get; set;}
            global String Country {get ;set;}
        }

    global class searchWrapper{
        public String name {get; set;}
    }


    }