import LightningDatatable from 'lightning/datatable';
import datatableTypeIcon from './datatableTypeIcon.html';
import datatableTypeIconStandard from './datatableTypeIconStandard.html';
import datatableTypeIconSecond from './datatableTypeIconSecond.html';

export default class CustomDatatable extends LightningDatatable {


    static customTypes = {
        icon: {
            template: datatableTypeIcon,
            typeAttributes: ['description', 'iconName'],
            standardCellLayout: true
        },
        iconStandard: {
            template: datatableTypeIconStandard,
            typeAttributes: ['description', 'iconName'],
            standardCellLayout: true
        },
        iconSecond: {
             template: datatableTypeIconSecond,
             typeAttributes: ['description', 'iconName'],
             standardCellLayout: true
         }
    };

    renderedCallback(){
                let result = this.template.querySelector(".slds-table_header-fixed_container");
//                result.classList.remove("slds-table_header-fixed_container");
                let factory = this.template.querySelector("lightning-primitive-header-factory");
    }
}