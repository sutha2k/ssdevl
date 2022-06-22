/**
 * @author Sutharsan Pushparajah
 * @date 19/08/2019 - SSDL V1.0
 * @description Interface 001 - Signature of methods accessible by datamanager 
 */
public interface ITF001_DataManager{
    WRP002_QueryBuilder query(WRP002_QueryBuilder queryBuilder);
    List<SObject> query(String afterSelect, String afterWhere, String finalStatements, Map<String, Object> simpleFilters, Map<String, List<Object>> listFilters);
    List<SObject> queryBy(String fieldsToQuery, String fieldNameToFilter, List<Object> filterParams);
    Map<String, Schema.SObjectField> getFieldsMap();
    String buildSelectClause(Map<String, Schema.SObjectField> fieldsMap);
    String getAllFields();
    List<Database.SaveResult> insertList(List<SObject> sObjectList, Boolean allOrNone);
    List<Database.UpsertResult> upsertList(List<SObject> sObjectList, Schema.SObjectField externalIdField);
    List<Database.SaveResult> updateList(List<SObject> sObjectList, Boolean allOrNone);
    List<Database.DeleteResult> deleteList(List<SObject> sObjectList, Boolean allOrNone);
    List<WRP000_DMLResult.DmlResultMatcher> buildDmlResultsMatcher(List<SObject> sObjectList, List<Database.SaveResult> lsr, List<Database.UpsertResult> lur, List<Database.DeleteResult> ldr);
}