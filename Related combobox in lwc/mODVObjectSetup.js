/* eslint-disable no-alert */
import { LightningElement,track,wire } from 'lwc';
import { refreshApex } from '@salesforce/apex'; // for refresh Apex
import ObjectDetails from '@salesforce/apex/mODVObjectSetup.ObjectDetails';       /*  using Apex Controller */
import getObjectName from '@salesforce/apex/mODVObjectSetup.getObjectName';        /*  using Apex Controller */   
import disablerecord from '@salesforce/apex/mODVObjectSetup.disablerecord';        /*  using Apex Controller */      
import getObjectLookup from '@salesforce/apex/mODVObjectSetup.getObjectLookup';     /*  using Apex Controller */    
import putRecords from '@salesforce/apex/mODVObjectSetup.putRecords';               /*  using Apex Controller */   
export default class MODVObjectSetup extends LightningElement {

@track error;
disablesObj = [];     // Array of selected records
mobjectList = [];    // using in datatable 
mobjectListLength;    // using to get the no. of records
@track isModalOpen = false;   //True when 'addObject' button click
@track selectedLabel;      //using in lightning-combox-1's value
@track objectNamed = [];   //using in lightning-combobox-1
@track selectedField;       //using in lightning-combobox-2's value
@track optionsObjLookup = [];   //using in lightning-combobox-2
modvHeaderObj = 'MODV Objects (0)';  //Show no.of records in lightning-datatable

// columns for lightning-datatable
@track mObjectcolumns = [
  {label: 'Object API Name', fieldName: 'Object_API_Name__c'},
  {label: 'Field API Name', fieldName: 'Field_API_Name__c'}
];

// using wire method to get 'getObjectName' data for lightning-combobox-1
@wire(getObjectName)
Objects(result) {
if (result.data) {
      this.objectNamed = [];
      var i;
    for (i = 0; i < result.data.length; i++) {
            var nobject = {
            label : result.data[i],
            value : result.data[i]
          };
          this.objectNamed.push(nobject);
        }
  } else if (result.error) {
    this.error = result.error;
    this.data = undefined;
}
};

// using wire method to get 'ObjectDetails' data for lightning-datatable
@wire(ObjectDetails)
wiredAccounts({data,error}){
  if (data) {
  this.mobjectList = data;
  this.mobjectListLength = data.length;
  this.modvHeaderObj = 'MODV Objects  ( '+this.mobjectListLength+' )' ;
  } else if (error) {
    this.error = error;
  }
};

//onrowselection event to select records to remove from lightning-datatable
handleObjectAction(event) {
const selectedRows = event.detail.selectedRows;
this.disablesObj=new Array();
for (let i = 0; i < selectedRows.length; i++) {
  this.disablesObj.push(selectedRows[i]);
} 
};

//To remove selected records from lightning-datatable
disabledObject(){
if(this.disablesObj.length <=0){
  alert('Please select row first');
}
else{
  disablerecord({oIds: this.disablesObj })
  .then(result => {
      alert('record deleted!! ,Refresh the Page');
      refreshApex(this.mobjectList);
  }).catch(error => {
  alert('Some error occured');
})
}
};

//To open Modal-box
addObject(event){
this.isModalOpen = true;
};

//To close Modal-box
closeModal(event){
this.isModalOpen = false;
};

//put lightning-combobox-1's value in selectedLabel 
GetObject(event){
this.selectedLabel = event.detail.value;
};

// using wire method to get related lookup field of a selectedObject
@wire(getObjectLookup,{selectedObject: '$selectedLabel'})
objectsLookupValue(result) {
if (result.data) {
  this.optionsObjLookup = [];
    var i;
  for (i = 0; i < result.data.length; i++) {
        var nobjectLookup = {
          label : result.data[i],
          value : result.data[i]
      };
      this.optionsObjLookup.push(nobjectLookup);
    }
} else if (result.error) {
  this.error = result.error;
  this.data = undefined;
  }
};

//put lightning-combobox-2's value in selectedField 
GetObjectLookupField(event){
  this.selectedField = event.detail.value;
};

//event to pass the parameter in apex's method
submitDetails(event){
if( this.selectedLabel !=undefined && this.selectedLabel != '' && this.selectedField != undefined && this.selectedField != ''){
putRecords({objectApi : this.selectedLabel,fieldApi : this.selectedField})
.then(result => {         
      refreshApex(this.mobjectList);
  alert('record added to MODV successfully');
}) 
}else{
  alert('Please Select');
}
}
}