public class StringArrayTest {
    public static List<String> generateStringArray(Integer numberOfStrings){
        List<String> generatedStringArray = new List <String>();
        for(Integer n = 0; n < numberOfStrings; n++){
                generatedStringArray.add('Test ' + n); 
        }
        return generatedStringArray;
    }
}