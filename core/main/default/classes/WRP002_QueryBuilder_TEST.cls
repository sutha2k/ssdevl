/**
 * @author Sutharsan Pushparajah
 * @date 22/08/2019 - SSDL V1.0
 * @description Test class for WRP002_QueryBuilder
 */
@isTest
private class WRP002_QueryBuilder_TEST{

    /**
     * @author Sutharsan Pushparajah
     * @date 22/08/2019
     * @description Testing instanciation of the constructor
     */
    @isTest
    private static void testConstructor(){
        
        WRP002_QueryBuilder query01 = new WRP002_QueryBuilder('Id, Name', 'Id=:Id', 'Limit 1');
        WRP002_QueryBuilder query02 = new WRP002_QueryBuilder('Id, Name', 'Id=:Id', 'Limit 1', new Map<String, Object>{'Id'=>'123456'}, null);
        WRP002_QueryBuilder query03 = new WRP002_QueryBuilder('Id, Name', 'Id in:Id', 'Order by Name asc', null, new Map<String, List<Object>>{'Id'=> new List<Object>{'123456', '56789'}});
        
        Test.startTest();
        
        System.assertEquals('Id, Name', query01.afterSelect);
        System.assertEquals('Id=:Id', query01.afterWhere);
        System.assertEquals('Limit 1', query01.finalStatements);
        System.assertEquals(null, query01.simpleFilters);
        System.assertEquals(null, query01.listFilters);
        System.assertEquals(false, query01.isAggregateResults);
        System.assertEquals(null, query01.results);
        System.assertEquals(null, query01.aggregateResults);
        
        System.assertEquals('Id, Name', query02.afterSelect);
        System.assertEquals('Id=:Id', query02.afterWhere);
        System.assertEquals('Limit 1', query02.finalStatements);
        System.assertNotEquals(null, query02.simpleFilters);
        
        Map<String, Object> simpleFilters = query02.simpleFilters;
        System.assertEquals('123456', simpleFilters.get('Id'));
        
        System.assertEquals(null, query02.listFilters);
        System.assertEquals(false, query02.isAggregateResults);
        System.assertEquals(null, query02.results);
        System.assertEquals(null, query02.aggregateResults);
        
        System.assertEquals('Id, Name', query03.afterSelect);
        System.assertEquals('Id in:Id', query03.afterWhere);
        System.assertEquals('Order by Name asc', query03.finalStatements);
        System.assertEquals(null, query03.simpleFilters);
        System.assertNotEquals(null, query03.listFilters);
        
        Map<String, List<Object>> listFilters = query03.listFilters;
        System.assertEquals('123456', listFilters.get('Id').get(0));
        System.assertEquals('56789', listFilters.get('Id').get(1));
        
        System.assertEquals(false, query03.isAggregateResults);
        System.assertEquals(null, query03.results);
        System.assertEquals(null, query03.aggregateResults);

        Test.stopTest();
    }
}