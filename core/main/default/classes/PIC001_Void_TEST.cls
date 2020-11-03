/**
 * @author Sutharsan Pushparajah
 * @date 19/02/2020 - SSDL V1.0
 * @description Test class for PIC001_Void
 */
@isTest
private class PIC001_Void_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/02/2020
     * @description Testing logging results
     */
    @isTest
    private static void testVoid(){
        Test.startTest();
        Boolean hasErrors = false;
        
        try{
            PIC001_Void.doVoid();
        } catch (Exception exp){
            hasErrors = true;
        }
        
        System.assertEquals(false, hasErrors);
        
        Test.stopTest();
    }
}