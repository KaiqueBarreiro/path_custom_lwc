import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';
import LEAD from '@salesforce/schema/Lead';
import getMessagesHover from '@salesforce/apex/PathCustomController.getMessageByStatus';
import getFields from '@salesforce/apex/PathCustomController.getFieldsByStatus';
import getGuidance from '@salesforce/apex/PathCustomController.getGuidanceByStatus';
import ID_FIELD from "@salesforce/schema/Lead.Id";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const FIELDS = [
    ID_FIELD,
    STATUS_FIELD
];

export default class LeadPath extends NavigationMixin(LightningElement)  {

    @api recordId;

    @track options = [];
    
    @track fields = [];

    @track currentStatus;

    @track selectedValue;

    @track showSpinner = false;

    @track showDetails = true;

    @track showKeyFields = true;
    
    @track showGuidance = true;

    @track showEditField = false;

    @track disableDetails = false;

    @track guidanceForSuccess;

    @wire(getObjectInfo, { objectApiName: LEAD })
    lead;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    record;
    
    @wire(getPicklistValues, { recordTypeId: '$lead.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    status({data, error}){
        if ( data ) {
            
            getMessagesHover({
                sobjectName: 'Lead'
            })
                .then(result => {
                    
                    this.selectedValue = this.record.data.fields.Status.value + '';

                    var isComplete = true;

                    data.values.forEach ( ( picklist, index)=>{

                        var classList;

                        if ( isComplete ) {
                            classList = 'slds-path__item slds-is-complete';
                        }

                        if ( picklist.label === this.selectedValue) {
                            classList = 'slds-path__item slds-is-current slds-is-active';
                            isComplete = false;
                            this.currentStatus = picklist.label
                        } else if ( !isComplete ) {
                            classList = 'slds-path__item slds-is-incomplete';
                        }

                        this.options.push({
                            key: picklist.label,
                            value: result[picklist.label],
                            classList: classList,
                            id: picklist.label + '0'
                        });

                    });

                    this.getFieldsByStatus();

                    this.getGuidanceByStatus();
                })
                .catch(error => {
                    console.log('error', error)
                });
                
        }

    }

    statusSelected (evt) {

        var selectedValue = evt.currentTarget.dataset.value;
        
        var elements = this.template.querySelectorAll('li');
        
        this.setClassList ( elements, selectedValue );

        this.selectedValue = selectedValue;
        
        this.getFieldsByStatus();

        this.getGuidanceByStatus();

    }

    hasInfoKeyFieldsOrGuidance() {
       
        if ( this.fields == null && this.guidanceForSuccess == null ) {
            this.showDetails = false;
            this.disableDetails = true;
        } else {
            this.showDetails = true;
            this.disableDetails = false;
        }

    }

    getFieldsByStatus() {

        getFields({
            sobjectName: 'Lead'
        })
        .then(result => {

            this.fields = result[this.selectedValue];
            
            this.showKeyFields = true;

            if ( this.fields == null ) this.showKeyFields = false;

        }).catch(error => {
           console.log('error getFields', error); 
        });
        
    }

    getGuidanceByStatus() {

        getGuidance({
            sobjectName: 'Lead'
        })
        .then(result => {
           
            this.guidanceForSuccess = result[this.selectedValue];
            
            this.showGuidance = true;
            
            if ( this.guidanceForSuccess == null ) this.showGuidance = false;
            
        }).catch(error => {
           console.log('error getFields', error); 
        });
        
    }
    
    setClassList (elements, status) {

        var isComplete = true;

        for (var i = 0; i < elements.length; ++i) {

            var classList;

            if ( isComplete ) {
                classList = 'slds-path__item slds-is-complete';
            }

            if ( this.currentStatus === elements[i].dataset.value) {
                classList = 'slds-path__item slds-is-current';
                isComplete = false;
            } else if ( !isComplete ) {
                classList = 'slds-path__item slds-is-incomplete';
            }

            if ( status === elements[i].dataset.value ) {
                classList = 'slds-path__item slds-is-active';
            }
            
            elements[i].className = classList;

        }

    }

    mouseOver (evt) {
        var dataId = evt.target.getAttribute('id') + '';
        const rect = this.template.querySelector("#" + dataId).getBoundingClientRect(); 
        var divId = "#" + dataId.split('-')[0] + '0-' + dataId.split('-')[1];
        this.template.querySelector( divId ).style.left = rect.left -10 + "px";
        this.template.querySelector( divId ).style.width = rect.right - rect.left + "px";
        this.template.querySelector( divId ).style.top = rect.top - 90 + "px"; 
        this.template.querySelector( divId ).style.display = "block";
    }

    mouseOut (evt) {
        var dataId = evt.target.getAttribute('id') + '';
        var divId = "#" + dataId.split('-')[0] + '0-' + dataId.split('-')[1];
        this.template.querySelector( divId ).style.display = "none";
    }

    handleEdit() {

        if ( this.showEditField ) {
            this.showEditField = false;
        } else {
            this.showEditField = true;
        }

    }

    handleShowDetails() {

        if ( this.showDetails ) {
            this.showDetails = false;
        } else {
            this.showDetails = true;
        }

    }

    handleMarkAsSelected() {
        
        if ( this.selectedValue == 'Qualified' ) {
        
            this.callConvertLead ( this.recordId );

            return;

        }

        this.showSpinner = true;

        const fields = {};
        
        fields.Id = this.recordId;
        fields.Status = this.selectedValue;
        
        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                
                this.currentStatus = this.selectedValue;

                var elements = this.template.querySelectorAll('li');

                this.setClassList ( elements, this.selectedValue );

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Status Updated!',
                        variant: 'success'
                    })
                );

            })
            .catch(
                error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating status!',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                }
            );

        this.showSpinner = false;

    }

    callConvertLead( leadId ) {
          
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'runtime_sales_lead__convertDesktopConsole'
            },
            state: {
                leadConvert__leadId: leadId,
                actionName: 'new'
            }
        });
         
    }

}