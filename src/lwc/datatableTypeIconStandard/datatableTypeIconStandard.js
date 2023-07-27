import { LightningElement, api } from 'lwc';

export default class DatatableTypeIconStandard extends LightningElement {
    @api iconName;
    @api description;

    renderedCallback(){
        let firstClass = this.template.querySelector(".myClass");

//        console.log(JSON.stringify(firstClass));
//        let result = firstClass.querySelector(".slds-button_icon");
//        console.log(result.classList);
////        console.log(result.classList);

//        let myTag = this.template.querySelector('.myClass[data-id="my-icon"]');
//        console.log(JSON.stringify(myTag));
    }
}