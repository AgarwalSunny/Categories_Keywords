@isTest
private class mODVObjectSetup_TGN_TEST{
    @isTest(SeeAllData=true)
    private static void ObjectDetails_TGN_TEST(){
        Database.SaveResult dsr;
        Docify_Object_Mapping__c drDocify_Object_Mapping_c;
        Test.startTest();
        mODVObjectSetup.ObjectDetails();
        Test.stopTest();
    }
    @isTest
    private static void getObjectName_TGN_TEST(){
        Test.startTest();
        mODVObjectSetup.getObjectName();
        Test.stopTest();
    }
    @isTest
    private static void getObjectLookup_TGN_TEST(){
        Test.startTest();
        mODVObjectSetup.getObjectLookup('a');
        mODVObjectSetup.getObjectLookup('');
        Test.stopTest();
    }
    @isTest
    private static void disablerecord_TGN_TEST(){
        Test.startTest();
        mODVObjectSetup.disablerecord(new List<Docify_Object_Mapping__c>{new Docify_Object_Mapping__c()});
        mODVObjectSetup.disablerecord(null);
        Test.stopTest();
    }
    @isTest
    private static void putRecords_TGN_TEST(){
        Test.startTest();
        mODVObjectSetup.putRecords('a','a');
        mODVObjectSetup.putRecords('','');
        Test.stopTest();
    }
    @isTest
    private static void mODVObjectSetup_TGN_TEST(){
        mODVObjectSetup obj = new mODVObjectSetup();
    }
}