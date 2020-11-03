/**
 * @author Sutharsan Pushparajah
 * @date 23/11/2016 - First version
 * @date 05/07/2019 - SSDL V1.0
 * @description WRP000_DMLResult - Wrapper representing the common results for dml update,upsert,insert,delete on one sObject
 */
public inherited sharing class WRP000_DMLResult{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 23/11/2016
     * @description Wrapper of a Database.Error representing an Error  dml update,upsert,insert,delete
     */
    public inherited sharing class DmlError{
        public String message;
        public System.StatusCode statusCode;
        public List<String> fields;
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 05/07/2019
     * @description Wrapper of result to match dml result with the corresponding record
     */
    public inherited sharing class DmlResultMatcher{
        public SObject theObject;
        public Boolean isSuccess;
        public Database.SaveResult saveResult;
        public Database.UpsertResult upsertResult;
        public Database.DeleteResult deleteResult;
        public List<Database.Error> dbErrorList;
        
        /**
         * @author Sutharsan Pushparajah
         * @date 05/07/2019
         * @description Constructor for SaveResult
         * @param theObject the SObject record on which a dml operation has been proceeded
         * @param saveResult the result of the dml operation
         */
        public DmlResultMatcher(SObject theObject, Database.SaveResult saveResult){
            this.theObject = theObject;
            this.isSuccess = saveResult.isSuccess();
            this.saveResult = saveResult;
            this.dbErrorList = saveResult.getErrors();
        }
        
        /**
         * @author Sutharsan Pushparajah
         * @date 05/07/2019
         * @description Constructor for UpsertResult
         * @param theObject the SObject record on which a dml operation has been proceeded
         * @param upsertResult the result of the dml operation
         */
        public DmlResultMatcher(SObject theObject, Database.UpsertResult upsertResult){
            this.theObject = theObject;
            this.isSuccess = upsertResult.isSuccess();
            this.upsertResult = upsertResult;
            this.dbErrorList = upsertResult.getErrors();
        }
        
        /**
         * @author Sutharsan Pushparajah
         * @date 05/07/2019
         * @description Constructor for DeleteResult
         * @param theObject the SObject record on which a dml operation has been proceeded
         * @param upsertResult the result of the dml operation
         */
        public DmlResultMatcher(SObject theObject, Database.DeleteResult deleteResult){
            this.theObject = theObject;
            this.isSuccess = deleteResult.isSuccess();
            this.deleteResult = deleteResult;
            this.dbErrorList = deleteResult.getErrors();
        }
        
        /**
         * @author Sutharsan Pushparajah
         * @date 23/11/2016
         * @description Convert a list of Database.Error into a list of DmlError
         * @return List<DmlError> A list of DmlError
         */
        public List<DmlError> convertErrors(){
            List<DmlError> dmlErrorList = new List<DmlError>();
            
            for (Database.Error dbError : this.dbErrorList) {
                DmlError dmlErr = new DmlError();
                dmlErr.message = dbError.getMessage();
                dmlErr.statusCode = dbError.getStatusCode();
                dmlErr.fields = dbError.getFields();
                dmlErrorList.add(dmlErr);
            }
    
            return dmlErrorList;
        }
    }
    
    /* List of record on which a dml operation has been proceeded */
    public List<SObject> sObjectList;
    /* List of saveResult */
    public List<Database.SaveResult> saveResultList;
    /* List of upsertResult */
    public List<Database.UpsertResult> upsertResultList;
    /* List of deleteResult */
    public List<Database.DeleteResult> deleteResultList;

    /**
    * @author Sutharsan Pushparajah
    * @date 05/07/2019
    * @description Constructor for DMLResult
    * @param sObjectList List of SObject record on which a dml operation has been proceeded
    * @param lsr the result of the insert/update dml operation
    * @param lur the result of the upsert dml operation
    * @param ldr the result of the delete dml operation
    */
    public WRP000_DMLResult(List<SObject> sObjectList, List<Database.SaveResult> lsr, List<Database.UpsertResult> lur, List<Database.DeleteResult> ldr){
        this.sObjectList = sObjectList;
        this.saveResultList = lsr;
        this.upsertResultList = lur;
        this.deleteResultList = ldr;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 05/07/2019
     * @description Merge a list of sOjects with a list of SaveResults or UpsertResult or DeleteResult into a list of DmlResultMatcher
     * @return List<DmlResultMatcher> List of record and their dml result
     */
    public List<DmlResultMatcher> build(){
        List<DmlResultMatcher> resultList = new List<DmlResultMatcher>();
        
        for (Integer i =0; i < this.sObjectList.size(); i++) {
            if (this.saveResultList != null){
                resultList.add(new DmlResultMatcher(this.sObjectList[i], this.saveResultList[i]));
            } else if (this.upsertResultList != null){
                resultList.add(new DmlResultMatcher(this.sObjectList[i], this.upsertResultList[i]));
            } else if (this.deleteResultList != null){
                resultList.add(new DmlResultMatcher(this.sObjectList[i], this.deleteResultList[i]));
            }
        }

        return resultList;
    }  
}