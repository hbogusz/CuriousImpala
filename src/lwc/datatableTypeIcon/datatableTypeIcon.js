import { LightningElement, api, track} from 'lwc';

export default class DatatableTypeIcon extends LightningElement {
    @api description;
    @api iconName;
    @api fieldValue;

    shouldBeShown;

    get className() {
        if(this.shouldBeShown){
            return 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left popover-position slds-rise-from-ground';
        } else {
            return 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left popover-position slds-hidden';
        }
    }

    showPopover() {
        this.shouldBeShown = true;
    }

    hidePopover() {
        this.shouldBeShown = false;
    }
}