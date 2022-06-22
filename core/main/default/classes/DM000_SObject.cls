/**
 * @author Sutharsan Pushparajah
 * @date 23/11/2016 - First version
 * @date 16/07/2019 - SSDL V1.0
 * @date 18/02/2021 - Adding new data access protection features
 * @description Datas Manager 000 - Every DM must extends this class to inherit standard behaviour
 */
public inherited sharing abstract class DM000_SObject {
     
    /**
     * @author Sutharsan Pushparajah
     * @date 23/11/2016
     * @description exception thrown in case of error detected in the parameters
     */
    public class DataManagerException extends Exception {}
     
    //SECURE EVERY REQUEST BY USING BINDED VARIABLES
    private static final String NEXT_BINDED_VARIABLE = 'bindedVariable{0}';
    @testVisible
    private Integer nextBindedVariableCounter = 1;
    private static final String NEXT_BINDED_LIST_VARIABLE = 'bindedListVariable{0}';
    @testVisible
    private Integer nextBindedListVariableCounter = 1;
    private static final Integer MAX_BINDED_VARIABLES = 10;
     
    @testVisible
    private Object bindedVariable1;
    @testVisible
    private Object bindedVariable2;
    @testVisible
    private Object bindedVariable3;
    @testVisible
    private Object bindedVariable4;
    @testVisible
    private Object bindedVariable5;
    @testVisible
    private Object bindedVariable6;
    @testVisible
    private Object bindedVariable7;
    @testVisible
    private Object bindedVariable8;
    @testVisible
    private Object bindedVariable9;
    @testVisible
    private Object bindedVariable10;
     
    @testVisible
    private List<Object> bindedListVariable1;
    @testVisible
    private List<Object> bindedListVariable2;
    @testVisible
    private List<Object> bindedListVariable3;
    @testVisible
    private List<Object> bindedListVariable4;
    @testVisible
    private List<Object> bindedListVariable5;
    @testVisible
    private List<Object> bindedListVariable6;
    @testVisible
    private List<Object> bindedListVariable7;
    @testVisible
    private List<Object> bindedListVariable8;
    @testVisible
    private List<Object> bindedListVariable9;
    @testVisible
    private List<Object> bindedListVariable10;
     
    //EVERY EXCEPTION MESSAGES
    private static final String EXCEPTION_SOBJECTNAME_REQUIRED = 'SObjectName and Entity Class Name must be provided, actual={0} - {1}';
    private static final String EXCEPTION_TOO_MANY_BINDED_VARAIABLES = 'Too many bindedVariables, max is '+MAX_BINDED_VARIABLES;
    private static final String EXCEPTION_MALFORMED_SELECT_QUERY = 'Missing select args, actual={0}';
    private static final String EXCEPTION_MALFORMED_WHERE_QUERY = 'Missing where args, actual={0}';
     
    //SECURE EVERY REQUEST BY CHECKING ACCESS LEVEL
    /* Enforce security on soql query */
    private static final String WITH_SECURITY_ENFORCED = 'WITH SECURITY_ENFORCED';
    /* Each DM must provide the sOjectName to manipulate */
    private String sObjectName;
    /* Each DM must provide the entity class Name that instanciate this class */
    private String entityClassName;
    /* Wrapper containing user in context and schema information on recently accessed objects */
    private static WRP001_UserInfo wrpUserInfo;
    /* Schema description of the current SObject */
    @testVisible 
    public Schema.DescribeSObjectResult describeResult;
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @param sObjectName API name of the current SObject
     * @param entityClassName Name of the class that instanciate the datamanager
     * @description Constructor to load contextual information on user and current SObject
     */
    public DM000_SObject(String sObjectName, String entityClassName){
        APU000_Logger.log(LoggingLevel.DEBUG, entityClassName, 'Constructor', String.format('Instanciate dataManager for SObject={0}',new List<Object>{sObjectName}));
         
        if (String.isEmpty(sObjectName) || String.isEmpty(entityClassName)){
           throw new DataManagerException(String.format(EXCEPTION_SOBJECTNAME_REQUIRED ,new List<Object>{sObjectName, entityClassName}));
        }
         
        this.sObjectName = sObjectName;
        this.entityClassName = entityClassName;
        wrpUserInfo = APC002_SObjectInfoCache.getFromCache(UserInfo.getUserId(), sObjectName);
        describeResult = wrpUserInfo.describeSObjectResult.get(sObjectName);
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 23/11/2016
     * @description Method used to reset variables after a soql query
     */
    @testVisible
    private void clearBindedVariables(){
        bindedVariable1 = null;
        bindedVariable2 = null;
        bindedVariable3 = null;
        bindedVariable4 = null;
        bindedVariable5 = null;
        bindedVariable6 = null;
        bindedVariable7 = null;
        bindedVariable8 = null;
        bindedVariable9 = null;
        bindedVariable10 = null;
        nextBindedVariableCounter = 1;

        bindedListVariable1 = null;
        bindedListVariable2 = null;
        bindedListVariable3 = null;
        bindedListVariable4 = null;
        bindedListVariable5 = null;
        bindedListVariable6 = null;
        bindedListVariable7 = null;
        bindedListVariable8 = null;
        bindedListVariable9 = null;
        bindedListVariable10 = null;
        nextBindedListVariableCounter = 1;
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 23/11/2016
     * @description Method used to assign binded variable before a soql query
     * @param valueList the list of binded variable value to set
     * @return String the name of the variable holding the binded value
     */
    @testVisible
    private String assignBindedListVariable(List<Object> valueList){

        if (nextBindedListVariableCounter > MAX_BINDED_VARIABLES){
            throw new DataManagerException(EXCEPTION_TOO_MANY_BINDED_VARAIABLES);
        }

        String variableToReturn = String.format(NEXT_BINDED_LIST_VARIABLE,new List<Object>{nextBindedListVariableCounter});

        switch on nextBindedListVariableCounter{
            when 1 {
                bindedListVariable1 = valueList;
            }
            when 2 {
                bindedListVariable2 = valueList;
            }
            when 3 {
                bindedListVariable3 = valueList;
            }
            when 4 {
                bindedListVariable4 = valueList;
            }
            when 5 {
                bindedListVariable5 = valueList;
            }
            when 6 {
                bindedListVariable6 = valueList;
            }
            when 7 {
                bindedListVariable7 = valueList;
            }
            when 8 {
                bindedListVariable8 = valueList;
            }
            when 9 {
                bindedListVariable9 = valueList;
            }
            when 10 {
                bindedListVariable10 = valueList;
            }
        }

        nextBindedListVariableCounter++;

        return variableToReturn;
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 23/11/2016
     * @description Method used to assign binded variable before a soql query
     * @param value the binded variable value to set
     * @return String the name of the variable holding the binded value
     */
    @testVisible
    private String assignBindedVariable(Object value){

        if (nextBindedVariableCounter > MAX_BINDED_VARIABLES){
            throw new DataManagerException(EXCEPTION_TOO_MANY_BINDED_VARAIABLES);
        }

        String variableToReturn = String.format(NEXT_BINDED_VARIABLE,new List<Object>{nextBindedVariableCounter});

        switch on nextBindedVariableCounter{
            when 1 {
                bindedVariable1 = value;
            }
            when 2 {
                bindedVariable2 = value;
            }
            when 3 {
                bindedVariable3 = value;
            }
            when 4 {
                bindedVariable4 = value;
            }
            when 5 {
                bindedVariable5 = value;
            }
            when 6 {
                bindedVariable6 = value;
            }
            when 7 {
                bindedVariable7 = value;
            }
            when 8 {
                bindedVariable8 = value;
            }
            when 9 {
                bindedVariable9 = value;
            }
            when 10 {
                bindedVariable10 = value;
            }
        }

        nextBindedVariableCounter++;

        return variableToReturn;
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description Get all fields information for the current SObject
     * @return Map<String, Schema.SObjectField> Map containing field name as key and field information as value
     */
    public Map<String, Schema.SObjectField> getFieldsMap(){
        return describeResult.fields.getMap();
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description Build a select clause with fields separated by comma
     * @param fieldsMap Map containing field name as key and field information as value
     * @return String represents the select clause of a soql query
     */
    public String buildSelectClause(Map<String, Schema.SObjectField> fieldsMap){
        return String.join(new List<String>(fieldsMap.keyset()), ',');
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description get all fields for the current SObject
     * @return String represents the select clause of a soql query with all fields
     */
    public String getAllFields(){
        return buildSelectClause(getFieldsMap());
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 24/02/2020
     * @description Assign binded variables to query
     * @param queryBuilder wrapper containing inputs for the query
     * @param soqlQuery soql query that is currently building
     * @return String SOQL query with binded variables
     */
    private String bindVariables(WRP002_QueryBuilder queryBuilder, String soqlQuery){
        
        if (!String.isEmpty(queryBuilder.afterWhere)){
            soqlQuery += ' where '+queryBuilder.afterWhere;
                
            if (queryBuilder.simpleFilters != null && !queryBuilder.simpleFilters.isEmpty()){
                for (String key : queryBuilder.simpleFilters.keySet()){
                    String assignedVariable = assignBindedVariable(queryBuilder.simpleFilters.get(key));
                    soqlQuery = soqlQuery.replace(':'+key,':'+assignedVariable);
                }
            }
                
            if (queryBuilder.listFilters != null && !queryBuilder.listFilters.isEmpty()){
                for (String key : queryBuilder.listFilters.keySet()){
                    String assignedListVariable = assignBindedListVariable(queryBuilder.listFilters.get(key));
                    soqlQuery = soqlQuery.replace(':'+key,':'+assignedListVariable);
                }
            }
        }

        return soqlQuery;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/02/2020
     * @description Assign security parameter and final statements
     * @param queryBuilder wrapper containing inputs for the query
     * @param soqlQuery soql query that is currently building
     * @return String SOQL query with security and final statements
     */
    private String extraQueryFilters(WRP002_QueryBuilder queryBuilder, String soqlQuery){
        if (APU002_Context.isWithSecurityEnforced()){
            soqlQuery += ' '+WITH_SECURITY_ENFORCED;
        }
        
        if (!String.isEmpty(queryBuilder.finalStatements)){
            soqlQuery += ' '+queryBuilder.finalStatements;
        }

        return soqlQuery;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/02/2020
     * @description Assign security parameter and final statements
     * @param queryBuilder wrapper containing inputs for the query
     * @param soqlQuery soql query that is currently building
     * @return N/A
     */
    private void executeQuery(WRP002_QueryBuilder queryBuilder, String soqlQuery){

        if (!APU002_Context.isWithSchemaDescriber() || (describeResult.isAccessible() && describeResult.isQueryAble())){
            APU000_Logger.log(LoggingLevel.DEBUG, entityClassName, 'query', String.format('SOQL={0}',new List<Object>{soqlQuery}));
        
            if (!queryBuilder.isAggregateResults){
                queryBuilder.results = evaluateStripInaccessible(Database.query(String.escapeSingleQuotes(soqlQuery)), AccessType.READABLE);
            } else {
                //StripInaccessible doesn't support aggregated result  
                queryBuilder.aggregateResults = Database.query(String.escapeSingleQuotes(soqlQuery));
            }
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 19/02/2021
     * @description Evaluate StripInaccessible data protection
     * @param sObjectList represents the list of SObject to evaluate
     * @param accessType This parameter determines the type of field-level access check to be performed
     * @return represents the list of SObject processed
     */
    private List<SObject> evaluateStripInaccessible(List<SObject> sObjectList, System.AccessType accessType){

        List<SObject> tempList = new List<SObject>(sObjectList);

        if (APU002_Context.isWithStripInaccessible()){
            SObjectAccessDecision decision = Security.stripInaccessible(accessType, sObjectList);
            tempList = decision.getRecords();
        }

        sObjectList.clear();
        sObjectList.addAll(tempList);

        return sObjectList;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description execute a SOQL query
     * @param queryBuilder wrapper containing inputs for the query
     * @return WRP002_QueryBuilder Wrapper contains query results
     */
    public virtual WRP002_QueryBuilder query(WRP002_QueryBuilder queryBuilder){
        if (queryBuilder == null){
            throw new DataManagerException(String.format(EXCEPTION_MALFORMED_SELECT_QUERY,new List<Object>{'null'}));
        }
         
        if (String.isEmpty(queryBuilder.afterSelect)){
            throw new DataManagerException(String.format(EXCEPTION_MALFORMED_SELECT_QUERY,new List<Object>{queryBuilder.afterSelect}));
        }
         
        String soqlQuery = String.format('select {0} from {1}', new List<Object>{queryBuilder.afterSelect, sObjectName});
        
        soqlQuery = bindVariables(queryBuilder, soqlQuery);
         
        soqlQuery = extraQueryFilters(queryBuilder, soqlQuery);
        
        executeQuery(queryBuilder, soqlQuery);
         
        clearBindedVariables();
         
        return queryBuilder;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @description execute a SOQL query
     * @param afterSelect represents the fields to select
     * @param afterWhere represents all where clauses
     * @param finalStatements represents limit, order by ... clauses
     * @param simpleFilters map containing binded variable name as key and value to filter for this binded variable
     * @param listFilters map containing binded variable name as key and list of value to filter for this binded variable
     * @return List<SObject> query results of SObject records
     */
    public virtual List<SObject> query(String afterSelect, String afterWhere, String finalStatements, Map<String, Object> simpleFilters, Map<String, List<Object>> listFilters){
        WRP002_QueryBuilder queryBuilder = new WRP002_QueryBuilder(afterSelect, afterWhere, finalStatements, simpleFilters, listFilters);
        queryBuilder = query(queryBuilder);
        return queryBuilder.results;
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description execute a SOQL query filtered by a field
     * @param fieldsToQuery represents the fields to select
     * @param fieldNameToFilter represents the field to filter on
     * @param filterParams represents the values to filter on
     * @return Map<Id, SObject> Map of SObject corresponding to query results
     */
    public virtual List<SObject> queryBy(String fieldsToQuery, String fieldNameToFilter, List<Object> filterParams){
        if (String.isEmpty(fieldNameToFilter)){
            throw new DataManagerException(String.format(EXCEPTION_MALFORMED_WHERE_QUERY,new List<Object>{fieldNameToFilter}));
        }
        
        if (filterParams == null || filterParams.isEmpty()){
            throw new DataManagerException(String.format(EXCEPTION_MALFORMED_WHERE_QUERY,new List<Object>{'NO PARAMS'}));
        }
         
        WRP002_QueryBuilder queryBuilder = new WRP002_QueryBuilder(fieldsToQuery, fieldNameToFilter+' in :'+fieldNameToFilter, null, null, new Map<String, List<Object>>{fieldNameToFilter => filterParams});
        queryBuilder = query(queryBuilder);
         
        return queryBuilder.results;
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description execute an insert DML statement on a list of SObject
     * @param sObjectList represents the list of SObject to insert
     * @param allOrNone if true raises an exception on any failure, if false partial success is allowed
     * @return List<Database.SaveResult> results of the insert DML operation
     */
    public virtual List<Database.SaveResult> insertList(List<SObject> sObjectList, Boolean allOrNone){
        if (sObjectList == null ||  sObjectList.isEmpty() || (APU002_Context.isWithSchemaDescriber() && (!describeResult.isAccessible() || !describeResult.isCreateable()))){
            return new List<Database.SaveResult>();
        }

        return Database.insert(evaluateStripInaccessible(sObjectList, AccessType.CREATABLE), allOrNone);
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description execute an upsert DML statement on a list of SObject (do not work with allOrNone mode, you have to rewrite it with the right casting of SObject)
     * @param sObjectList represents the list of SObject to upsert
     * @param externalIdField Field used to make the upsert call
     * @return List<Database.UpsertResult> results of the upsert DML operation
     */
    public virtual List<Database.UpsertResult> upsertList(List<SObject> sObjectList, Schema.SObjectField externalIdField){
        if (sObjectList == null ||  sObjectList.isEmpty() || (APU002_Context.isWithSchemaDescriber() && (!describeResult.isAccessible() || !describeResult.isCreateable() || !describeResult.isUpdateable()))){
            return new List<Database.UpsertResult>();
        }
        
        List<SObject> upsertList = (List<SObject>)Type.ForName('List<'+sObjectName+'>').newInstance();
        upsertList.addAll(sObjectList);

        return Database.upsert(evaluateStripInaccessible(sObjectList, AccessType.UPSERTABLE), externalIdField);
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description execute an update DML statement on a list of SObject
     * @param sObjectList represents the list of SObject to update
     * @param allOrNone if true raises an exception on any failure, if false partial success is allowed
     * @return List<Database.SaveResult> results of the update DML operation
     */
    public virtual List<Database.SaveResult> updateList(List<SObject> sObjectList, Boolean allOrNone){
        if (sObjectList == null ||  sObjectList.isEmpty() || (APU002_Context.isWithSchemaDescriber() && (!describeResult.isAccessible() || !describeResult.isUpdateable()))){
            return new List<Database.SaveResult>();
        }
         
        return Database.update(evaluateStripInaccessible(sObjectList, AccessType.UPDATABLE), allOrNone);
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 20/08/2019
     * @description execute a delete DML statement on a list of SObject
     * @param sObjectList represents the list of SObject to delete
     * @param allOrNone if true raises an exception on any failure, if false partial success is allowed
     * @return List<Database.DeleteResult> results of the delete DML operation
     */
    public virtual List<Database.DeleteResult> deleteList(List<SObject> sObjectList, Boolean allOrNone){
        if (sObjectList == null ||  sObjectList.isEmpty() || (APU002_Context.isWithSchemaDescriber() && (!describeResult.isAccessible() || !describeResult.isDeletable()))){
            return new List<Database.DeleteResult>();
        }
        
        //No StripInaccessible support needed
        return Database.delete(sObjectList, allOrNone);
    }
     
    /**
     * @author Sutharsan Pushparajah
     * @date 21/08/2019
     * @description Match records with dml results to help analyse success and failure
     * @param sObjectList List of SObject record on which a dml operation has been proceeded
     * @param lsr the result of the insert/update dml operation
     * @param lur the result of the upsert dml operation
     * @param ldr the result of the delete dml operation
     * @return List<DmlResultMatcher> each records with their corresponding dml result
     */
    public virtual List<WRP000_DMLResult.DmlResultMatcher> buildDmlResultsMatcher(List<SObject> sObjectList, List<Database.SaveResult> lsr, List<Database.UpsertResult> lur, List<Database.DeleteResult> ldr){
        WRP000_DMLResult dmlResult = new WRP000_DMLResult(sObjectList, lsr, lur, ldr);
        return dmlResult.build();
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/02/2020
     * @description Describe current SObject
     * @return Schema.DescribeSObjectResult Describe current SObject
     */
    public virtual Schema.DescribeSObjectResult getDescribeResult(){
        return describeResult;
    }
}