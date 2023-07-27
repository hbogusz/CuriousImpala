/**
 * Created by hubert.bogusz on 04.05.2022.
 */
@isTest
global with sharing class MechanicCalloutMock {
    public static Id newId = Id.valueOf('001xa000003DIlo');

    @isTest static void shouldCreateMechanic() {
        Test.setMock(WebServiceMock.class, new MechanicMock(MechanicMock.METHOD_ADD));
        SearchMechanicHandler.sessionIdFromCache = '123';
        SearchMechanicHandler mechanicHandler = new SearchMechanicHandler();

        mechanicHandler.mechanicWrapper.Id = newId;
        mechanicHandler.mechanicWrapper.country = 'Poland';
        mechanicHandler.mechanicWrapper.email = 'test@tn.pl';
        mechanicHandler.mechanicWrapper.firstName = 'TestUnique';
        mechanicHandler.mechanicWrapper.lastName = 'test';
        mechanicHandler.mechanicWrapper.phone = '123456789';

        SearchMechanicHandler.MechanicWrapper mechanic;

        Test.startTest();
        mechanicHandler.createMechanic();
        Test.stopTest();

        System.assertEquals(MechanicMock.ADD_RESPONSE, 'Mechanic created' );

    }
    @isTest static void shouldReturnMechanics() {
        Test.setMock(WebServiceMock.class, new MechanicMock(MechanicMock.METHOD_SEARCH));
        SearchMechanicHandler.sessionIdFromCache = '123';
        SearchMechanicHandler mechanicHandler = new SearchMechanicHandler();

        Test.startTest();
        mechanicHandler.searchMechanicWrapper.lastName = 'test';
        mechanicHandler.searchMechanics();
        Test.stopTest();

        System.assert(mechanicHandler.mechanics.size() > 0);
    }

    @isTest static void shouldDeleteMechanic() {
        Test.setMock(WebServiceMock.class, new MechanicMock(MechanicMock.METHOD_DELETE));
        SearchMechanicHandler.sessionIdFromCache = '123';
        SearchMechanicHandler mechanicHandler = new SearchMechanicHandler();
        mechanicHandler.mechanicId = newId;

        Test.startTest();
        mechanicHandler.deleteMechanic();
        Test.stopTest();

        System.assertEquals(MechanicMock.DELETE_RESPONSE, 'Mechanic deleted');
    }

    @isTest static void shouldUpdateMechanic() {
        Test.setMock(WebServiceMock.class, new MechanicMock(MechanicMock.METHOD_DELETE));
        SearchMechanicHandler.sessionIdFromCache = '123';
        SearchMechanicHandler mechanicHandler = new SearchMechanicHandler();
        mechanicHandler.mechanicId = newId;

        mechanicHandler.mechanicWrapperToEdit.firstName = 'Test';
        mechanicHandler.mechanicWrapperToEdit.lastName = 'Nowak';
        mechanicHandler.mechanicWrapperToEdit.country = 'Poland';
        mechanicHandler.mechanicWrapperToEdit.email = 'test@test.pl';

        Test.startTest();
        mechanicHandler.editMechanic();
        Test.stopTest();

        System.assertEquals(MechanicMock.UPDATE_RESPONSE, 'Mechanic updated');
    }


}