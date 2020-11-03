/**
 * @author Sutharsan Pushparajah
 * @date 19/02/2020 - SSDL V1.0
 * @description PIC001_Void - Utility to do void operation
 */
public inherited sharing class PIC001_Void{

    /**
     * @author Sutharsan Pushparajah
     * @date 19/02/2020 - SSDL V1.0
     * @description method called by process builder to simulate a blank action
     * @return N/A
     */
    @InvocableMethod(label='Void' description='Void')
    public static void doVoid(){
        return;
    }
}