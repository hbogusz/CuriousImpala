/**
 * Created by hubert.bogusz on 06.05.2022.
 */

global class CreateMechanicMock implements WebServiceMock {
    public static final String METHOD_ADD = 'add';
    public static final String ADD_RESPONSE = 'Mechanic created';

    private String method;

    public CreateMechanicMock(String method) {
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
            webResponse.response = ADD_RESPONSE;
            addResponse.result = webResponse;
            response.put('response_x', addResponse);
        }
    }
}