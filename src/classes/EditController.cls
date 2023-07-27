/**
 * Created by hubert.bogusz on 12.04.2022.
 */

public with sharing class EditController {
    public ApexPages.StandardController sController;
    public String queryString { get; set; }

    public EditController(ApexPages.StandardController standardController) {
        sController = standardController;
    }
    public PageReference saveAndNew() {
        try {
            Schema.DescribeSObjectResult describeResult = sController.getRecord().getSObjectType().getDescribe();
            PageReference pageReference = new PageReference('/' + describeResult.getKeyPrefix() + '/e?' + queryString);
            pageReference.setRedirect(true);
            PageReference pr = sController.save();
            if (ApexPages.hasMessages()) {
                return pr;
            } else {
                return pageReference;
            }
        }
        catch (exception e) {
            ApexPages.addMessages(e);
            System.Debug('Exception');
            return null;
        }
    }
}