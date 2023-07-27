/**
 * Created by hubert.bogusz on 13.04.2022.
 */

public with sharing class checkRecursive {
    static Boolean flag = true;
    public static boolean runOnce() {
        return flag && !(flag = false);
    }
}