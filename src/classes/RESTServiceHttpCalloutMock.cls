@isTest
global class RESTServiceHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"street": "Staszica","postalCode": "20-400","phone": "81 532 50 41","openingDate": "1998-12-11","name": "Public University Hospital No. 1 in Lublin","id": "a057R000013jLXbQAM","externalId": null,"email": "puhospital@hospital.pl","country": "Poland","city": "Lublin"},' +
                '{"street": "Aleje Racławickie", "postalCode": "20-049", "phone": "26 118 32 00","openingDate": "1984-04-21", "name": "1 Military Clinical Hospital in Lublin SPZOZ", "id": "a057R000013jLSlQAM","externalId": null, "email": "militaryhos@hospital.pl", "country": "Poland", "city": "Lublin"}]');
        response.setStatusCode(200);
        return response;
    }
}