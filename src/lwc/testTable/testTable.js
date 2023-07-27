import { LightningElement } from 'lwc';

export default class testTable extends LightningElement {

    columns = [
        {
            type: 'icon',
            initialWidth: 40,
            hideLabel: true,
            hideDefaultActions: true,
            typeAttributes: {
                description: { fieldName: 'role' },
                iconName: { fieldName: 'dynamicIcon' }
            },
            cellAttributes: { alignment: 'center' }
        },
        {
            label: 'Name',
            fieldName: 'name',
            type: 'text',
            hideDefaultActions: true,
        },
        {
            label: 'Phone',
            fieldName: 'phone',
            type: 'phone',
            hideDefaultActions: true
        },
        {
            type: 'iconStandard',
            initialWidth: 40,
            hideLabel: true,
            hideDefaultActions: true,
            typeAttributes: {
                description: { fieldName: 'role' },
                iconName: { fieldName: 'dynamicIcon' }
            },
            cellAttributes: { alignment: 'center' }
        },
        {
            type: 'iconSecond',
            initialWidth: 40,
            hideLabel: true,
            hideDefaultActions: true,
            typeAttributes: {
                description: { fieldName: 'role' },
                iconName: { fieldName: 'dynamicIcon' }
            },
            cellAttributes: { alignment: 'center' }
        }
    ];

    data = [
        {
            id: 1,
            dynamicIcon: 'utility:education',
            role: 'Student',
            name: 'Jacek Placek',
            phone: 123456789
        },
        {
            id: 2,
            dynamicIcon: 'utility:retail_execution',
            role: 'Student',
            name: 'Romek Atomek',
            phone: 987654321
        }
    ];
}