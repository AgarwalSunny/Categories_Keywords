/*******************************************************************************************
* @Name         mODVObjectSetup 
* @Author       Sunny Agarwal <agarwalsunni434@email.com>
* @Date         05/12/2022
* @Group        Docify_Object_Mapping__c
* @Description  This class contains all service methods related to caching data in Salesforce.  
*				It is segregated as a service to make changing cache partition easy.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Sunny          05/12/2022          Initial Creation                                                      
*******************************************************************************************/
 public with sharing class mODVObjectSetup {
// get all record of "Docify_Object_Mapping__c" custom setting 
@AuraEnabled(cacheable=true)
public static List<Docify_Object_Mapping__c>  ObjectDetails()
{        
List<Docify_Object_Mapping__c> objectMapping = [select Id,Object_API_Name__c,Field_API_Name__c from Docify_Object_Mapping__c];
return objectMapping;
}
 //get all object api name for first combobox 
@AuraEnabled(cacheable=true)
public static List<String> getObjectName(){
List<string> sObjectList = new List<string>();
for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
String name = objTyp.getDescribe().getName();
if((name != 'Map_Objects__c')){
    SobjectList.add(name);
}
}
return sObjectList;
}
 // TO get related lookup field in MFile__c object according to selected object on 1st combobox 
@AuraEnabled(cacheable=true)
public static List<String> getObjectLookup(string selectedObject){
List<string> getObjectField = new List<string>();
String objType = 'MFile__c';
Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
Schema.SObjectType leadSchema = schemaMap.get(objType);
Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
 for (String fieldName : fieldMap.keySet()) {
//get all the fields label for MFile Object
List<Schema.SObjectType> refrences = fieldMap.get(FieldName).getDescribe().getReferenceTo();
String RelatedToObjectName;
for(Schema.SObjectType reference : refrences) {
    RelatedToObjectName = reference.getDescribe().getName();
}
//get data types for each fields
Schema.DisplayType fielddataType = fieldMap.get(FieldName).getDescribe().getType();
if(fielddataType == Schema.DisplayType.Reference) {
        if(selectedObject == RelatedToObjectName){
            getObjectField.add(fieldName);
    }
}
}
return getObjectField;
}
 // TO delete the selected Docify_Object_Mapping__c records
@AuraEnabled
public static void disablerecord(List<Docify_Object_Mapping__c> oIds){
delete oIds;
}
 // TO create 'Docify_Object_Mapping__c' custom setting record 
@AuraEnabled
public static Docify_Object_Mapping__c  putRecords(string objectApi , string fieldApi){
Docify_Object_Mapping__c objectMappingRecord=new Docify_Object_Mapping__c( Name=objectApi, Object_API_Name__c = objectApi, Field_API_Name__c = fieldApi );
insert objectMappingRecord;
return objectMappingRecord;
}     
}