/**
 * @author Sutharsan Pushparajah
 * @date 23/08/2019 - SSDL V1.0
 * @description Test class for DM000_SObject
 */
@isTest
private class DM000_SObject_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/08/2019
     * @description Testing creating an instance of datamanager
     */
    @isTest
    private static void testConstructor(){
        Test.startTest();
        
        ITF001_DataManager datamanager;
        Boolean hasErrors = false;
        String message;
        
        //USE CASE 01 - BOTH SObjectName and EntityClassName are not provided
        try {
            datamanager = new DM001_SObjectInstance(null, null);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('SObjectName and Entity Class Name must be provided, actual=null - null', message);
        
        //USE CASE 02 - Only SObjectName is provided
        message = null;
        hasErrors = false;
        String sObjectName = SObjectType.SampleForTest__c.Name;
        
        try {
            datamanager = new DM001_SObjectInstance(sObjectName, null);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('SObjectName and Entity Class Name must be provided, actual='+sObjectName+' - null', message);
        
        //USE CASE 03 - Only EntityClassName is provided
        message = null;
        hasErrors = false;
        String entityClassName = 'DM000_SObject_TEST';
        
        try {
            datamanager = new DM001_SObjectInstance(null, entityClassName);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('SObjectName and Entity Class Name must be provided, actual=null - '+entityClassName, message);
        
        //USE CASE 04 - BOTH SObjectName and EntityClassName are provided
        message = null;
        hasErrors = false;
        
        datamanager = new DM001_SObjectInstance(sObjectName, entityClassName);
        System.assertNotequals(null, datamanager);
        
        Schema.DescribeSObjectResult describer = ((DM001_SObjectInstance)datamanager).getDescribeResult();
        System.assertNotEquals(null, describer);
        System.assertEquals(sObjectName, describer.getName());   
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/08/2019
     * @description Testing assignment of binded variables
     */
    @isTest
    private static void testBindedvariables(){
        Test.startTest();
        
        ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.SampleForTest__c.Name, 'DM000_SObject_TEST');
        
        Boolean hasErrors = true;
        String message;
        String variableName;
        
        //USE CASE 01 - check simple binded variables
        try {
            for (Integer i=0;i<11;i++){
                variableName = ((DM001_SObjectInstance)datamanager).assignBindedVariable(i);
                System.assertEquals('bindedVariable'+(i+1), variableName);
            }
        } catch(Exception exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Too many bindedVariables, max is 10', message);
        System.assertEquals(0, ((DM001_SObjectInstance)datamanager).bindedVariable1);
        System.assertEquals(1, ((DM001_SObjectInstance)datamanager).bindedVariable2);
        System.assertEquals(2, ((DM001_SObjectInstance)datamanager).bindedVariable3);
        System.assertEquals(3, ((DM001_SObjectInstance)datamanager).bindedVariable4);
        System.assertEquals(4, ((DM001_SObjectInstance)datamanager).bindedVariable5);
        System.assertEquals(5, ((DM001_SObjectInstance)datamanager).bindedVariable6);
        System.assertEquals(6, ((DM001_SObjectInstance)datamanager).bindedVariable7);
        System.assertEquals(7, ((DM001_SObjectInstance)datamanager).bindedVariable8);
        System.assertEquals(8, ((DM001_SObjectInstance)datamanager).bindedVariable9);
        System.assertEquals(9, ((DM001_SObjectInstance)datamanager).bindedVariable10);
        
        //USE CASE 02 - check list binded variables
        try {
            for (Integer i=0;i<11;i++){
                variableName = ((DM001_SObjectInstance)datamanager).assignBindedListVariable(new List<Object>{i});
                System.assertEquals('bindedListVariable'+(i+1), variableName);
            }
        } catch(Exception exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Too many bindedVariables, max is 10', message);
        System.assertEquals(0, ((DM001_SObjectInstance)datamanager).bindedListVariable1.get(0));
        System.assertEquals(1, ((DM001_SObjectInstance)datamanager).bindedListVariable2.get(0));
        System.assertEquals(2, ((DM001_SObjectInstance)datamanager).bindedListVariable3.get(0));
        System.assertEquals(3, ((DM001_SObjectInstance)datamanager).bindedListVariable4.get(0));
        System.assertEquals(4, ((DM001_SObjectInstance)datamanager).bindedListVariable5.get(0));
        System.assertEquals(5, ((DM001_SObjectInstance)datamanager).bindedListVariable6.get(0));
        System.assertEquals(6, ((DM001_SObjectInstance)datamanager).bindedListVariable7.get(0));
        System.assertEquals(7, ((DM001_SObjectInstance)datamanager).bindedListVariable8.get(0));
        System.assertEquals(8, ((DM001_SObjectInstance)datamanager).bindedListVariable9.get(0));
        System.assertEquals(9, ((DM001_SObjectInstance)datamanager).bindedListVariable10.get(0));
        
        //USE CASE 03 - clearing binded variables
        ((DM001_SObjectInstance)datamanager).clearBindedVariables();
        System.assertEquals(1, ((DM001_SObjectInstance)datamanager).nextBindedVariableCounter);
        System.assertEquals(1, ((DM001_SObjectInstance)datamanager).nextBindedListVariableCounter);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable1);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable2);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable3);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable4);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable5);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable6);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable7);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable8);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable9);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedVariable10);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable1);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable2);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable3);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable4);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable5);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable6);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable7);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable8);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable9);
        System.assertEquals(null, ((DM001_SObjectInstance)datamanager).bindedListVariable10);
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/08/2019
     * @description retrieve fields from SObject
     */
    @isTest
    private static void testGetFieldsMap(){
        Test.startTest();
        
        ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.SampleForTest__c.Name, 'DM000_SObject_TEST');
        
        //USE CASE 01 - Check if fields have been retrieved for the current SObject
        Map<String, Schema.SObjectField> fieldsMap = datamanager.getFieldsMap();
        
        System.assertNotEquals(null, fieldsMap);
        System.assertNotEquals(null, fieldsMap.get(String.valueOf(SampleForTest__c.Id)));
        System.assertNotEquals(null, fieldsMap.get(String.valueOf(SampleForTest__c.Name)));
        System.assertNotEquals(null, fieldsMap.get(String.valueOf(SampleForTest__c.ExternalId__c)));
        
        //USE CASE 02 - Check the generation of the select clause from fields map
        String selectQuery = datamanager.buildSelectClause(fieldsMap);
        
        System.assertNotEquals(null, selectQuery);
        System.assertEquals(true, selectQuery.contains(','));
        
        for (String key : fieldsMap.keySet()){
            System.assertEquals(true, selectQuery.contains(key));
        }
        
        String allFields = datamanager.getAllFields();
        System.assertEquals(selectQuery, allFields);
        
        Test.stopTest();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/08/2019
     * @description test soql query
     */
    @isTest
    private static void testQuery(){
        ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.SampleForTest__c.Name, 'DM000_SObject_TEST');
        List<Database.SaveResult> saveResults;
        List<Database.UpsertResult> upsertResults;
        List<Database.deleteResult> deleteResults;
        
        Test.startTest();
        
        SampleForTest__c sample01 = new SampleForTest__c(ExternalId__c = 'DM000_TEST-01');
        SampleForTest__c sample02 = new SampleForTest__c(ExternalId__c = 'DM000_TEST-02');
        
        List<SampleForTest__c> sampleList = new List<SampleForTest__c>{sample01, sample02};
        
        
        //USE CASE 01 - Insert SObject
        saveResults = datamanager.insertList(null, null);
        System.assertEquals(0, saveResults.size());
        
        saveResults = datamanager.insertList(sampleList, true);
        System.assertEquals(2, saveResults.size());
        List<WRP000_DMLResult.DmlResultMatcher> matcherList = datamanager.buildDmlResultsMatcher(sampleList, saveResults, null, null);
        System.assertNotEquals(null, matcherList);
        System.assertEquals(2, matcherList.size());
        System.assertEquals(sample01.Id, matcherList.get(0).theObject.Id);
        System.assertEquals(sample02.Id, matcherList.get(1).theObject.Id);
        
        //USE CASE 02 - Update SObject
        saveResults = datamanager.updateList(null, true);
        System.assertEquals(0, saveResults.size());
        
        saveResults = datamanager.updateList(sampleList, true);
        System.assertEquals(2, saveResults.size());
        matcherList = datamanager.buildDmlResultsMatcher(sampleList, saveResults, null, null);
        System.assertNotEquals(null, matcherList);
        System.assertEquals(2, matcherList.size());
        System.assertEquals(sample01.Id, matcherList.get(0).theObject.Id);
        System.assertEquals(sample02.Id, matcherList.get(1).theObject.Id);
        
        //USE CASE 03 - Upsert SObject
        Boolean hasErrors = false;
       
        upsertResults = datamanager.upsertList(null, null);
        System.assertEquals(0, upsertResults.size());
        
        try{
            upsertResults = datamanager.upsertList(sampleList, null);
        } catch(Exception exp){
            hasErrors = true;
        }
        
        System.assertEquals(true, hasErrors);
        
        upsertResults = datamanager.upsertList(null, SampleForTest__c.Fields.ExternalId__c);
        System.assertEquals(0, upsertResults.size());
        
        upsertResults = datamanager.upsertList(sampleList, SampleForTest__c.Fields.ExternalId__c);
        System.assertEquals(2, upsertResults.size());
        matcherList = datamanager.buildDmlResultsMatcher(sampleList, null, upsertResults, null);
        System.assertNotEquals(null, matcherList);
        System.assertEquals(2, matcherList.size());
        System.assertEquals(sample01.Id, matcherList.get(0).theObject.Id);
        System.assertEquals(sample02.Id, matcherList.get(1).theObject.Id);
        
        //USE CASE 04 - Query
        hasErrors = false;
        String message;
        
        try{
            datamanager.query(null);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Missing select args, actual=null', message);
        
        hasErrors = false;
        message = null;
        WRP002_QueryBuilder queryBuilder00 = new WRP002_QueryBuilder(null, 'ExternalId__c = :extId', 'LIMIT 1', new Map<String, Object>{'extId' => 'DM000_TEST-01'}, null);
        
        try{
            queryBuilder00 = datamanager.query(queryBuilder00);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Missing select args, actual=null', message);
        
        WRP002_QueryBuilder queryBuilder01 = new WRP002_QueryBuilder('Id, Name, ExternalId__c', 'ExternalId__c = :extId', 'LIMIT 1', new Map<String, Object>{'extId' => 'DM000_TEST-01'}, null);
        queryBuilder01 = datamanager.query(queryBuilder01);
        System.assertNotEquals(null, queryBuilder01.results);
        System.assertEquals(null, queryBuilder01.aggregateResults);
        System.assertEquals(1, queryBuilder01.results.size());
        List<SampleForTest__c> queryResults = queryBuilder01.results;
        System.assertEquals('DM000_TEST-01', queryResults.get(0).ExternalId__c);
        
        WRP002_QueryBuilder queryBuilder02 = new WRP002_QueryBuilder('Id, Name, ExternalId__c', 'ExternalId__c in :extId', null, null, new Map<String, List<Object>>{'extId' => new List<String>{'DM000_TEST-01', 'DM000_TEST-02'}});
        queryBuilder02 = datamanager.query(queryBuilder02);
        System.assertNotEquals(null, queryBuilder02.results);
        System.assertEquals(null, queryBuilder02.aggregateResults);
        System.assertEquals(2, queryBuilder02.results.size());
        queryResults = queryBuilder02.results;
        System.assertEquals('DM000_TEST-01', queryResults.get(0).ExternalId__c);
        System.assertEquals('DM000_TEST-02', queryResults.get(1).ExternalId__c);
        
        WRP002_QueryBuilder queryBuilder03 = new WRP002_QueryBuilder('count(Id) mycount', null, null);
        queryBuilder03.isAggregateResults = true;
        queryBuilder03 = datamanager.query(queryBuilder03);
        System.assertEquals(null, queryBuilder03.results);
        System.assertNotEquals(null, queryBuilder03.aggregateResults);
        System.assertEquals(1, queryBuilder03.aggregateResults.size());
        System.assertEquals(2, queryBuilder03.aggregateResults.get(0).get('mycount'));
        
        //USE CASE 05 - QueryBy
        hasErrors = false;
        message = null;
        
        try {
            datamanager.queryBy(null, null, null);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Missing where args, actual=null', message);
        
        hasErrors = false;
        message = null;
        
        try {
            datamanager.queryBy(null, String.valueOf(SampleForTest__c.ExternalId__c), null);
        } catch(DM000_SObject.DataManagerException exp){
            hasErrors = true;
            message = exp.getMessage();
        }
        
        System.assertEquals(true, hasErrors);
        System.assertEquals('Missing where args, actual=NO PARAMS', message);
        
        queryResults = datamanager.queryBy('Id, Name, ExternalId__c', String.valueOf(SampleForTest__c.ExternalId__c), new List<String>{'DM000_TEST-01', 'DM000_TEST-02'});
        System.assertEquals(2, queryResults.size());
        
        //USE CASE 06 - Delete SObject
        deleteResults = datamanager.deleteList(null, true);
        System.assertEquals(0, deleteResults.size());
        
        deleteResults = datamanager.deleteList(sampleList, true);
        System.assertEquals(2, deleteResults.size());
        matcherList = datamanager.buildDmlResultsMatcher(sampleList, null, null, deleteResults);
        System.assertNotEquals(null, matcherList);
        System.assertEquals(2, matcherList.size());
        
        Test.stopTest();
    }
}