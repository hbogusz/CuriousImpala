global with sharing class BoostPlugin implements sboost.BoostPlugins.BaseApexPlugin
{
    global Object createInstance(String className) {
        Object instance = null;
        if (String.isNotBlank(className)) {
            Type classType = Type.forName(className);
            instance = classType == null ? null : classType.newInstance();
        }
        return instance;
    }


    global Boolean hasCustomPermission(String permissionName) {
        return FeatureManagement.checkPermission(permissionName);
    }


    global ApexTypeImplementor[] searchForClassImplementation(String searchText, String interfaceName, Integer numberOfRecord) {
        return [SELECT ClassName, ClassNamespacePrefix
        FROM ApexTypeImplementor
        WHERE ClassName LIKE :(searchText + '%') AND IsConcrete=TRUE AND InterfaceName =:interfaceName
        ORDER BY ClassName ASC
        LIMIT :numberOfRecord];
    }
}
