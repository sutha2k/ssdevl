/**
 * @author Sutharsan Pushparajah
 * @date 29/08/2019 - SSDL V1.0
 * @description Test class for APU001_Crypto
 */
@isTest
private class APU001_Crypto_TEST{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 29/08/2019
     * @description Testing the generation of a GUID
     */
    @isTest
    private static void testGenerateGUID(){
        Test.startTest();
        
        String guid01 = APU001_Crypto.generateGUID();
        String guid02 = APU001_Crypto.generateGUID();
        System.assertNotEquals(null, guid01);
        System.assertNotEquals(null, guid02);
        System.assertNotEquals(guid01, guid02);
        System.assertEquals(36, guid01.length());
        System.assertEquals('-', guid01.subString(8,9));
        System.assertEquals('-', guid01.subString(13,14));
        System.assertEquals('-', guid01.subString(18,19));
        System.assertEquals('-', guid01.subString(23,24));
        
        Test.stoptest();
    }
}