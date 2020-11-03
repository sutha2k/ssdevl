/**
 * @author Sutharsan Pushparajah
 * @date 22/08/2019 - SSDL V1.0
 * @description Test class for WRP000_DMLResult
 */
@isTest
private class WRP000_DMLResult_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing insert, upsert, update, delete in order to analyse the dml results
     */
    @isTest
    private static void testBuild(){
    
        //Creating 2 records sharing the same external id so that 1 will succeed and 1 will fail
        List<SObject> insertList = new List<SObject>();
        
        SampleForTest__c sample01 = new SampleForTest__c();
        sample01.ExternalId__c = '01';
        
        SampleForTest__c sample02 = new SampleForTest__c();
        sample02.ExternalId__c = '01';
        
        SampleForTest__c sample03 = new SampleForTest__c();
        sample03.ExternalId__c = '03';
        
        insertList.add(sample01);
        insertList.add(sample02);
    
        Test.startTest();
        
        List<Database.SaveResult> saveResults;
        List<Database.UpsertResult> upsertResults;
        List<Database.DeleteResult> deleteResults;
        Boolean hasErrors = false;
        
        //USE CASE 01 ALLorNone (0 SUCCESS)
        try {
            saveResults = database.insert(insertList, true);
        } catch (Exception exp){
            hasErrors = true;
        }
        
        System.assertEquals(true, hasErrors);
        
        //USE CASE 02 partial insert (1 SUCCESS , 1 FAILURE)
        Integer expectedResultMatcher = 2;
        saveResults = database.insert(insertList, false);
    
        WRP000_DMLResult dmlResult = new WRP000_DMLResult(insertList, saveResults, upsertResults, deleteResults);
        List<WRP000_DMLResult.DmlResultMatcher> dmlResultsMatcher = dmlResult.build();
        
        System.assertEquals(expectedResultMatcher, dmlResultsMatcher.size());
        
        WRP000_DMLResult.DmlResultMatcher matcher01 = dmlResultsMatcher.get(0);
        WRP000_DMLResult.DmlResultMatcher matcher02 = dmlResultsMatcher.get(1);
        
        System.assertEquals(sample01.id, matcher01.theObject.Id);
        System.assertEquals(true, matcher01.isSuccess);
        System.assertNotEquals(null, matcher01.saveResult);
        System.assertEquals(null, matcher01.upsertResult);
        System.assertEquals(null, matcher01.deleteResult);
        System.assertEquals(0, matcher01.dbErrorList.size());
        
        System.assertEquals(sample02, matcher02.theObject);
        System.assertEquals(false, matcher02.isSuccess);
        System.assertNotEquals(null, matcher02.saveResult);
        System.assertEquals(null, matcher02.upsertResult);
        System.assertEquals(null, matcher02.deleteResult);
        System.assertEquals(1, matcher02.dbErrorList.size());
        
        List<WRP000_DMLResult.DmlError> errors = matcher02.convertErrors();
        System.assertEquals(1, errors.size());
        WRP000_DMLResult.DmlError dmlErr = errors.get(0);
        System.assertNotEquals(null, dmlErr.message);
        System.assertNotEquals(null, dmlErr.statusCode);
        System.assertNotEquals(null, dmlErr.fields);
 
        //USE CASE 03 UPDATE 
        List<SampleForTest__c> updateList = new List<SampleForTest__c>();
        updateList.add(sample01);
        
        saveResults = Database.update(updateList, false);
        dmlResult = new WRP000_DMLResult(updateList, saveResults, null, null);
        dmlResultsMatcher = dmlResult.build();
        
        System.assertEquals(1, dmlResultsMatcher.size());
        
        matcher01 = dmlResultsMatcher.get(0);
        
        System.assertEquals(sample01.id, matcher01.theObject.Id);
        System.assertEquals(true, matcher01.isSuccess);
        System.assertNotEquals(null, matcher01.saveResult);
        System.assertEquals(null, matcher01.upsertResult);
        System.assertEquals(null, matcher01.deleteResult);
        System.assertEquals(0, matcher01.dbErrorList.size());
 
        //USE CASE 04 upsert
        List<SampleForTest__c> upsertList = new List<SampleForTest__c>();
        upsertList.add(sample02);
        upsertList.add(sample03);
        upsertResults = database.upsert(upsertList, SampleForTest__c.Fields.ExternalId__c, false);
    
        dmlResult = new WRP000_DMLResult(upsertList, null, upsertResults, deleteResults);
        dmlResultsMatcher = dmlResult.build();
        
        System.assertEquals(expectedResultMatcher, dmlResultsMatcher.size());
        
        matcher01 = dmlResultsMatcher.get(0);
        matcher02 = dmlResultsMatcher.get(1);
        
        System.assertEquals(sample01.id, sample02.id);
        System.assertEquals(sample02.id, matcher01.theObject.Id);
        System.assertEquals(true, matcher01.isSuccess);
        System.assertEquals(null, matcher01.saveResult);
        System.assertNotEquals(null, matcher01.upsertResult);
        System.assertEquals(null, matcher01.deleteResult);
        System.assertEquals(0, matcher01.dbErrorList.size());
        
        System.assertEquals(sample03.Id, matcher02.theObject.Id);
        System.assertEquals(true, matcher02.isSuccess);
        System.assertEquals(null, matcher02.saveResult);
        System.assertNotEquals(null, matcher02.upsertResult);
        System.assertEquals(null, matcher02.deleteResult);
        System.assertEquals(0, matcher02.dbErrorList.size());
        
        //USE CASE 05 delete
        deleteResults = Database.delete(upsertList, false);
        dmlResult = new WRP000_DMLResult(upsertList, null, null, deleteResults);
        dmlResultsMatcher = dmlResult.build();
        
        System.assertEquals(expectedResultMatcher, dmlResultsMatcher.size());
        
        matcher01 = dmlResultsMatcher.get(0);
        matcher02 = dmlResultsMatcher.get(1);
        
        System.assertEquals(sample02.id, matcher01.theObject.Id);
        System.assertEquals(true, matcher01.isSuccess);
        System.assertEquals(null, matcher01.saveResult);
        System.assertEquals(null, matcher01.upsertResult);
        System.assertNotEquals(null, matcher01.deleteResult);
        System.assertEquals(0, matcher01.dbErrorList.size());
        
        System.assertEquals(sample03.Id, matcher02.theObject.Id);
        System.assertEquals(true, matcher02.isSuccess);
        System.assertEquals(null, matcher02.saveResult);
        System.assertEquals(null, matcher02.upsertResult);
        System.assertNotEquals(null, matcher02.deleteResult);
        System.assertEquals(0, matcher02.dbErrorList.size());
        
        List<SampleForTest__c> deletedList = [select Id, ExternalId__c from SampleForTest__c where ExternalId__c in ('01','02','03')];
        System.assertEquals(0, deletedList.size());
        
        Test.stopTest();
    } 
}