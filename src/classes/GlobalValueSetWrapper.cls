/**
 * Created by hubert.bogusz on 09.05.2022.
 */

public class GlobalValueSetWrapper {
    public Metadata metadata;

    public class Metadata {
        public List<CustomValue> customValue;
    }
    public class CustomValue {
        public String label;
        public String valueName;
    }
    public static List<String> getPicklistValues(HttpResponse response) {
        List<String> picklistValues = new List<String>();
        GlobalValueSetWrapper wrapper = (GlobalValueSetWrapper) System.JSON.deserialize(response.getBody(), GlobalValueSetWrapper.class);
        for (GlobalValueSetWrapper.customValue value : wrapper.metadata.customValue) {
            picklistValues.add(value.valueName);
        }
        system.debug('Piclist Values: ' + picklistValues);
        return picklistValues;
    }
}