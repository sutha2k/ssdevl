/**
 * @author Sutharsan Pushparajah
 * @date 28/11/2016 - First version
 * @date 26/08/2019 - SSDL V1.0
 * @description Apex APU001_Crypto Crypto Utilities
 */
public inherited sharing class APU001_Crypto{
     
    /** 
     * @author Sutharsan Pushparajah
     * @date 28/11/2016
     * @description generate a GUID based on AES 128
     * @return String the generated GUID
     */
    public static String generateGUID(){

        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.subString(0,8)+'-'+h.subString(8,12)+'-'+h.subString(12,16)+'-'+h.subString(16,20)+'-'+h.substring(20);

        return guid;
    }
 }