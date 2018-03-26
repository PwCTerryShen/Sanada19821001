public without sharing class CompanyHelper {
    
    public static final String BASE_COMPANY_QUERY = 'SELECT Company_Code_Unique__c, Name,' + 
                                                    ' Company_Name__c, Company_Phone__c, Company_Place__c,' +
                                                    ' Company_Type__c, CreatedById, CreatedDate, IsDeleted,' + 
                                                    ' Employees_Number__c, LastModifiedById, LastModifiedDate,' +
                                                    ' OwnerId, Id, SystemModstamp FROM Company_Info__c where IsDeleted = false';
    public static final String BASE_COMPANY_COUNT_QUERY = 'SELECT count() from Company_Info__c where IsDeleted = false';
    public static MyPaginationEnhancement getCompanyList(String companyName,String companyCode,String companyPlace,String companyType,MyPaginationEnhancement pagination) {
        String queryCondition= '';
        String orderBy ='';
        if(companyName != null) {
            queryCondition += ' and Company_Name__c like %\'' + companyName + '%\'';
        }
        if(companyCode != null) {
            queryCondition += ' and Company_Code_Unique__c like %\'' + companyCode + '%\'';
        }
        if(companyPlace != null) {
            queryCondition += ' and Company_Place__c like %\'' + companyPlace + '%\'';
        }
        if(companyType != null) {
            queryCondition += ' and Company_Type__c like %\'' + companyType + '%\'';
        }
        
        orderBy = ' order by createddate';
        
        pagination.getQueryResult(BASE_COMPANY_COUNT_QUERY,BASE_COMPANY_QUERY,queryCondition,null,orderBy);
       // pagination.getQueryResult();
        return pagination;
    }
}