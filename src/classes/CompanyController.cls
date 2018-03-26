public with sharing class CompanyController {
    
    public Map<String,String> parameters;
    
    public CompanyController() {
        parameters=ApexPages.currentPage().getParameters();
        init();
    }
    
    public MyPaginationEnhancement pagination = new MyPaginationEnhancement();
    
    public String companyName{get;set;}
    
    public String companyCode{get;set;}
    
    public String companyPlace{get;set;}
    
    public String companyType{get;set;}
    
    public void init() {
        queryByCondition();
    }
    
    public void queryByCondition() {
        CompanyHelper.getCompanyList(companyName,companyCode,companyPlace,companyType,pagination);
        system.debug('====================CurrentPageNumber : ' + pagination.pageNumber);
    }
    
    public MyPaginationEnhancement resultPagination{
        get{
            if(pagination ==null){
               pagination =new MyPaginationEnhancement();
            }
            return pagination;
        }
        set;
    }
    
    public List<Company_Info__c> resultList{
        get{
            if(pagination==null || pagination.resultList==null){
               return new List<Company_Info__c>(); 
            }
            return pagination.resultList;
        }
        set;
    }
    
    public void firstPage() {
       pagination.first();
       queryByCondition();     
    } 
    
    public void lastPage() {
       pagination.last();
       queryByCondition();            
    } 
   
    public void previousPage() {
       pagination.previous();
       queryByCondition();      
    } 
   
    public void nextPage() {
       pagination.next();
       queryByCondition();
    }
}