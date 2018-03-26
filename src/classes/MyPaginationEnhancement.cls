public without sharing class MyPaginationEnhancement{
    
    public static final Integer DEFAULT_PAGE_SIZE=20;

    public MyPaginationEnhancement() {
    }
    
    public MyPaginationEnhancement(ApexPages.StandardSetController controller) {                  
    }
    
    public MyPaginationEnhancement(ApexPages.StandardController controller) {      
    }
    
    private List<sObject> sObjectList;

    private String countStr;

    private String queryStr;

    private String queryCondition;
    
    private String groupBy;

    private String orderBy;

    private Integer offset=0;
    
    public List<sObject> resultList{
        get {
            if(sObjectList == null){
                return new List<sObject>();
            }
            return sObjectList;            
        }
        set;
    }
    
    public List<sObject> getQueryResult(String countStr,String queryStr,String queryCondition){
        setQueryCondition(countStr,queryStr,queryCondition,null,null);
        buildAndQuery();        
        return sObjectList;
    }
    
    public List<sObject> getQueryResult(String countStr,String queryStr,String queryCondition,String groupBy,String orderBy){
        setQueryCondition(countStr,queryStr,queryCondition,groupBy,orderBy);
        buildAndQuery();
        return sObjectList;
    }
    
    public List<sObject> updateQueryResult(String queryStr,String queryCondition,String groupBy,String orderBy){
        String querySql = queryStr;
        if(queryCondition!=null){
            querySql += queryCondition;
        }
        if(groupBy!=null){
            querySql +=groupBy;
        }
        if(orderBy!=null){
            querySql +=orderBy;
        }
        sObjectList = Database.query(querySql);
        return sObjectList;
    }

    private void setQueryCondition(String countStr,String queryStr,String queryCondition,String groupBy,String orderBy){
        this.countStr=countStr;
        this.queryStr=queryStr;
        this.queryCondition=queryCondition;
        this.groupBy=groupBy;
        this.orderBy=orderBy;
    }
    
    private void buildAndQuery(){
        List<String> queryArgs = new List<String>();
        List<String> countArgs= new List<String>();
        if(String.isNotBlank(countStr)){
            countArgs.add(countStr);
        }
        if(String.isNotBlank(queryStr)){
            queryArgs.add(queryStr);
        }
        if(String.isNotBlank(queryCondition)){
            queryArgs.add(queryCondition);
            countArgs.add(queryCondition);
        }
        if(String.isNotBlank(groupBy)){
            queryArgs.add(groupBy);
            countArgs.add(groupBy);
        }        
        if(String.isNotBlank(orderBy)){
            queryArgs.add(orderBy);
        }
        initTotalNum(countArgs);        
        queryResult(queryArgs);
    }    

    private void initTotalNum(List<String> countArgs){
       String countqueryStr=String.join(countArgs,' ');
       
       if(String.isNotBlank(countqueryStr)){
               
           totalNumber=Database.countquery(countqueryStr);
       } else {
            totalNumber=0;
       }
       
       if(totalNumber !=0 && pageNumber==0){
           pageNumber = 1;
       }
    }     
    
    private List<sObject> queryResult(List<String> queryArgs){
        queryStr=String.join(queryArgs,' ');       
        if(String.isBlank(queryStr)){
            sObjectList = new List<sObject>();            
        }else{
            String querySql=queryStr+' limit '+pageSize+' offset '+offset;            
            
            sObjectList = Database.query(querySql);
        }
        return sObjectList;
    }
            
    public void changePageSize(Integer pageSize) {        
        if (pageSize!=null){                    
            this.pageSize=pageSize;                     
        }       
    }    
    
    public Boolean hasNext {
        get {
            return pageSize*pageNumber<totalNumber;               
        }
        set;
    } 
 
    public Boolean hasPrevious {
        get {
            return pageSize*(pageNumber-1)>0;            
        }
        set;
    } 
   
    public Integer pageNumber {
        get {
            if(pageNumber==null){
                pageNumber=0;
            }
            return pageNumber;                 
        }
        set;
    }
    
    public Integer pageSize{
        get{
            if(pageSize==null){
                pageSize=DEFAULT_PAGE_SIZE;               
            } 
            return pageSize;          
        }
        set;
    }
    
    public Integer totalNumber{
        get{
            if(totalNumber==null){
                totalNumber=0;
            }
            return totalNumber;
        }
        set;
    }
    
    public Integer totalPage{
        get{
            if(totalNumber==0 || math.mod(totalNumber,pageSize)!=0){                       
                return totalNumber/pageSize+1;                        
            }else{
                return totalNumber/pageSize;
            }          
        }
        set;
    }
    
    public Boolean hasRecord{
        get {
            if(totalNumber!=0){
                return true;
            }else{
                return false;
            }           
        }
        set;
    } 
    
    public void  first() {
        offset=0;
        pageNumber=1;       
    } 
    
    public void  last() {
        offset=(totalPage-1)*pageSize;
        pageNumber=totalPage;                       
    } 
   
    public void  previous() {
        pageNumber--;
        if(pageNumber<0){
            pageNumber=0;
            offset=0;
        }else{
            offset=(pageNumber-1)*pageSize;
        }          
    } 
   
    public void  next() {             
        pageNumber++;       
        if(pageNumber>totalPage){
            pageNumber=totalPage;
        }      
        offset=(pageNumber-1)*pageSize;        
    }
    
     //指定页
    public virtual void specifiedPage(Integer pageNumber) {
        this.pageNumber = pageNumber;
        if(pageNumber < 0) {
            pageNumber = 0;
            offset = 0;
        } else {
            offset = (pageNumber - 1) * pageSize;
        }
    }
    
    public Integer getOffset(){
            return offset;
    }

    public Integer getSize(){
            return pageSize;
    }    

}