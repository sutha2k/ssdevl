/**
 * @author Sutharsan Pushparajah
 * @date 05/07/2019 - SSDL V1.0
 * @description WRP002_QueryBuilder - Construct SOQL queries and get results
 */
public inherited sharing class WRP002_QueryBuilder{
    //INPUT
    public String afterSelect; 
    public String afterWhere;
    public String finalStatements;
    public Map<String, Object> simpleFilters;
    public Map<String, List<Object>> listFilters;
    public Boolean isAggregateResults = false;
    
    //OUTPUT
    public List<SObject> results;
    public List<AggregateResult> aggregateResults;
    
     /**
      * @author Sutharsan Pushparajah
      * @date 21/08/2019
      * @description Constructor to gather query inputs
      * @param afterSelect represents the fields to select
      * @param afterWhere represents all where clauses
      * @param finalStatements represents limit, order by ... clauses
      * @return N/A
      */
    public WRP002_QueryBuilder(String afterSelect, String afterWhere, String finalStatements){
        this.afterSelect = afterSelect;
        this.afterWhere = afterWhere;
        this.finalStatements = finalStatements;
    }
    
     /**
      * @author Sutharsan Pushparajah
      * @date 21/08/2019
      * @description Constructor to gather query inputs
      * @param afterSelect represents the fields to select
      * @param afterWhere represents all where clauses
      * @param finalStatements represents limit, order by ... clauses
      * @param simpleFilters map containing binded variable name as key and value to filter for this binded variable
      * @param listFilters map containing binded variable name as key and list of value to filter for this binded variable
      * @return N/A
      */
    public WRP002_QueryBuilder(String afterSelect, String afterWhere, String finalStatements, Map<String, Object> simpleFilters, Map<String, List<Object>> listFilters){
        this(afterSelect, afterWhere, finalStatements);
        this.simpleFilters = simpleFilters;
        this.listFilters = listFilters;
    }
 }