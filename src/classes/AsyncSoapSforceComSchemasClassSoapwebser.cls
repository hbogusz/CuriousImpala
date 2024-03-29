//Generated by wsdl2apex

public class AsyncSoapSforceComSchemasClassSoapwebser {
    public class getCountryGlobalSetResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String[] getValue() {
            soapSforceComSchemasClassSoapwebser.getCountryGlobalSetResponse_element response = (soapSforceComSchemasClassSoapwebser.getCountryGlobalSetResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class updateMechanicResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.WEBResponse getValue() {
            soapSforceComSchemasClassSoapwebser.updateMechanicResponse_element response = (soapSforceComSchemasClassSoapwebser.updateMechanicResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class queryMechanicsResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.MechanicWrapper[] getValue() {
            soapSforceComSchemasClassSoapwebser.queryMechanicsResponse_element response = (soapSforceComSchemasClassSoapwebser.queryMechanicsResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class createMechanicResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.WEBResponse getValue() {
            soapSforceComSchemasClassSoapwebser.createMechanicResponse_element response = (soapSforceComSchemasClassSoapwebser.createMechanicResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class deleteMechanicByIdResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.WEBResponse getValue() {
            soapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_element response = (soapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class loadMechanicByIdResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.WEBResponseMechanic getValue() {
            soapSforceComSchemasClassSoapwebser.loadMechanicByIdResponse_element response = (soapSforceComSchemasClassSoapwebser.loadMechanicByIdResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncSOAPWebService {
        public String endpoint_x = 'https://eu44.salesforce.com/services/Soap/class/SOAPWebService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public soapSforceComSchemasClassSoapwebser.SessionHeader_element SessionHeader;
        public soapSforceComSchemasClassSoapwebser.DebuggingHeader_element DebuggingHeader;
        public soapSforceComSchemasClassSoapwebser.DebuggingInfo_element DebuggingInfo;
        public soapSforceComSchemasClassSoapwebser.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public soapSforceComSchemasClassSoapwebser.CallOptions_element CallOptions;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/SOAPWebService';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/SOAPWebService';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/SOAPWebService';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/SOAPWebService';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/SOAPWebService';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/SOAPWebService', 'soapSforceComSchemasClassSoapwebser'};
        public AsyncSoapSforceComSchemasClassSoapwebser.getCountryGlobalSetResponse_elementFuture beginGetCountryGlobalSet(System.Continuation continuation) {
            soapSforceComSchemasClassSoapwebser.getCountryGlobalSet_element request_x = new soapSforceComSchemasClassSoapwebser.getCountryGlobalSet_element();
            return (AsyncSoapSforceComSchemasClassSoapwebser.getCountryGlobalSetResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.getCountryGlobalSetResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'getCountryGlobalSet',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'getCountryGlobalSetResponse',
              'soapSforceComSchemasClassSoapwebser.getCountryGlobalSetResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.updateMechanicResponse_elementFuture beginUpdateMechanic(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.MechanicWrapper mechanicWrapper,soapSforceComSchemasClassSoapwebser.WEBMechanicIdRequest webMechanicIdRequest) {
            soapSforceComSchemasClassSoapwebser.updateMechanic_element request_x = new soapSforceComSchemasClassSoapwebser.updateMechanic_element();
            request_x.mechanicWrapper = mechanicWrapper;
            request_x.webMechanicIdRequest = webMechanicIdRequest;
            return (AsyncSoapSforceComSchemasClassSoapwebser.updateMechanicResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.updateMechanicResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'updateMechanic',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'updateMechanicResponse',
              'soapSforceComSchemasClassSoapwebser.updateMechanicResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.queryMechanicsResponse_elementFuture beginQueryMechanics(System.Continuation continuation,String query) {
            soapSforceComSchemasClassSoapwebser.queryMechanics_element request_x = new soapSforceComSchemasClassSoapwebser.queryMechanics_element();
            request_x.query = query;
            return (AsyncSoapSforceComSchemasClassSoapwebser.queryMechanicsResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.queryMechanicsResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'queryMechanics',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'queryMechanicsResponse',
              'soapSforceComSchemasClassSoapwebser.queryMechanicsResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.createMechanicResponse_elementFuture beginCreateMechanic(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.MechanicWrapper mechanicWrapper) {
            soapSforceComSchemasClassSoapwebser.createMechanic_element request_x = new soapSforceComSchemasClassSoapwebser.createMechanic_element();
            request_x.mechanicWrapper = mechanicWrapper;
            return (AsyncSoapSforceComSchemasClassSoapwebser.createMechanicResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.createMechanicResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'createMechanic',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'createMechanicResponse',
              'soapSforceComSchemasClassSoapwebser.createMechanicResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_elementFuture beginDeleteMechanicById(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.WEBMechanicIdRequest webMechanicIdRequest) {
            soapSforceComSchemasClassSoapwebser.deleteMechanicById_element request_x = new soapSforceComSchemasClassSoapwebser.deleteMechanicById_element();
            request_x.webMechanicIdRequest = webMechanicIdRequest;
            return (AsyncSoapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'deleteMechanicById',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'deleteMechanicByIdResponse',
              'soapSforceComSchemasClassSoapwebser.deleteMechanicByIdResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.loadMechanicByIdResponse_elementFuture beginLoadMechanicById(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.WEBMechanicIdRequest webMechanicIdRequest) {
            soapSforceComSchemasClassSoapwebser.loadMechanicById_element request_x = new soapSforceComSchemasClassSoapwebser.loadMechanicById_element();
            request_x.webMechanicIdRequest = webMechanicIdRequest;
            return (AsyncSoapSforceComSchemasClassSoapwebser.loadMechanicByIdResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.loadMechanicByIdResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'loadMechanicById',
              'http://soap.sforce.com/schemas/class/SOAPWebService',
              'loadMechanicByIdResponse',
              'soapSforceComSchemasClassSoapwebser.loadMechanicByIdResponse_element'}
            );
        }
    }
}