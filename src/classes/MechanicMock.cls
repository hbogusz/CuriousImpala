/**
 * Created by hubert.bogusz on 05.05.2022.
 */

global class MechanicMock implements WebServiceMock {
    public static final String METHOD_ADD = 'add';
    public static final String METHOD_SEARCH = 'search';
    public static final String METHOD_DELETE = 'delete';
    public static final String METHOD_UPDATE = 'update';
    public static String ADD_RESPONSE ;
    public static String DELETE_RESPONSE = 'Mechanic deleted';
    public static String UPDATE_RESPONSE = 'Mechanic updated';

    private String method;

    public MechanicMock(String method) {
        this.method = method;
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        if(method == METHOD_ADD){
            soapSforceComSchemasClassSoapwebser.createMechanicResponse_element addResponse = new soapSforceComSchemasClassSoapwebser.createMechanicResponse_element();
            soapSforceComSchemasClassSoapwebser.WEBResponse webResponse = new soapSforceComSchemasClassSoapwebser.WEBResponse();
            ADD_RESPONSE = 'Mechanic created';
            webResponse.response = ADD_RESPONSE;
            addResponse.result = webResponse;
            response.put('response_x', addResponse);
        }
        if(method == METHOD_SEARCH){
            soapSforceComSchemasClassSoapwebser.queryMechanicsResponse_element queryResponse = new soapSforceComSchemasClassSoapwebser.queryMechanicsResponse_element();
            soapSforceComSchemasClassSoapwebser.MechanicWrapper[] mechanicWrappers = new List <soapSforceComSchemasClassSoapwebser.MechanicWrapper>();
            soapSforceComSchemasClassSoapwebser.MechanicWrapper mechanic1 = new soapSforceComSchemasClassSoapwebser.MechanicWrapper();
            mechanic1.lastName='test';
            mechanic1.firstName='first';
            mechanic1.country='Poland';
            soapSforceComSchemasClassSoapwebser.MechanicWrapper mechanic2 = new soapSforceComSchemasClassSoapwebser.MechanicWrapper();
            mechanic2.lastName='test';
            mechanic2.firstName='second';
            mechanic2.country='Poland';
            mechanicWrappers.add(mechanic1);
            mechanicWrappers.add(mechanic2);
            queryResponse.result = mechanicWrappers;
            response.put('response_x', queryResponse);
        }
        if(method == METHOD_DELETE){
            soapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_element deleteResponse = new soapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_element();
            soapSforceComSchemasClassSoapwebser.WEBResponse webResponse = new soapSforceComSchemasClassSoapwebser.WEBResponse();
            DELETE_RESPONSE = 'Mechanic deleted';
            webResponse.response = DELETE_RESPONSE;
            deleteResponse.result = webResponse;
            response.put('response_x', deleteResponse);
        }
        if(method == METHOD_UPDATE){
            soapSforceComSchemasClassSoapwebser.updateMechanicResponse_element updateResponse = new soapSforceComSchemasClassSoapwebser.updateMechanicResponse_element();
            soapSforceComSchemasClassSoapwebser.WEBResponse webResponse = new soapSforceComSchemasClassSoapwebser.WEBResponse();
            UPDATE_RESPONSE = 'Mechanic updated';
            webResponse.response = UPDATE_RESPONSE;
            updateResponse.result = webResponse;
            response.put('response_x', updateResponse);
        }
    }
}