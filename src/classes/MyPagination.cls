public virtual without sharing class MyPagination {
    //默认值，如果不设置每页显示的数量，则默认数量为20
    public static final Integer DEFAULT_PAGE_SIZE=20;
    
    public MyPagination() {
        
    }
    
    public MyPagination(ApexPages.StandardController controller) {
        
    }
    
    public MyPagination(ApexPages.StandardSetController controller) {
        
    }
    
    //结果集    
    private List<sObject> sObjectList;   

    //查询条数的SQL
    private String countStr;

    //查询结果集的SQL
    private String queryStr;

    //查询结果集的条件 where 部分
    private String queryCondition;
    
    //查询结果集的group by部分
    private String groupBy;

    //查询结果集的order by 部分
    private String orderBy;

    //查询结果集的offset部分，offset最大值为2000，salesforce的限制
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
    
    public virtual void setQueryCondition(String countStr,String queryStr){
        setQueryCondition(countStr,queryStr,null,null,null);
    }
    
    public virtual void setQueryCondition(String countStr,String queryStr,String queryCondition){
        setQueryCondition(countStr,queryStr,queryCondition,null,null);
    }

    public virtual void setQueryCondition(String countStr,String queryStr,String queryCondition,String groupBy,String orderBy){
        this.countStr=countStr;
        this.queryStr=queryStr;
        this.queryCondition=queryCondition;
        this.groupBy=groupBy;
        this.orderBy=orderBy;
        buildQuery();
    }

    private void buildQuery(){
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
        queryStr=String.join(queryArgs,' ');
        offset=0;
    }    

    private void initTotalNum(List<String> countArgs){
       String countqueryStr=String.join(countArgs,' ');
       if(String.isNotBlank(countqueryStr)){
               
           totalNumber=Database.countquery(countqueryStr);
       } else {
            totalNumber=0;
       }
       if(totalNumber != null) {
            pageNumber=1;
       }
    } 
    
    public virtual List<sObject> getQueryResult(){       
        if(String.isBlank(queryStr)){
            sObjectList = new List<sObject>();
        }else{
            String querySql=queryStr+' limit '+pageSize+' offset '+offset;  
            sObjectList = Database.query(querySql);
        }  
        return sObjectList;    
    }
    
    public virtual Integer getCountResult(){       
        return totalNumber;
    }
   
    //改变每页显示的数量        
    public virtual void changePageSize(Integer pageSize) {        
        if (pageSize!=null){                    
            this.pageSize=pageSize;                     
        }       
    }    
    
    //是否有下一页
    public Boolean hasNext {
        get {
            return pageSize*pageNumber<totalNumber;               
        }
        set;
    } 
 
     //是否有前一页
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
    
    //每页显示页数
    public Integer pageSize{
        get{
            if(pageSize==null){
                pageSize=DEFAULT_PAGE_SIZE;               
            } 
            return pageSize;          
        }
        set;
    }
    
    
    //结果集总数
    public Integer totalNumber{
        get{
            if(totalNumber==null){
                totalNumber=0;
            }
            return totalNumber;
        }
        set;
    }
    
    
    //总页数
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
    
    //是否有记录集
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
    
    //首页
    public virtual void  first() {
        offset=0;
        pageNumber=1;       
    } 
    
    //尾页
    public virtual  void  last() {
        offset=(totalPage-1)*pageSize;
        pageNumber=totalPage;                       
    } 
    
   
   //上一页
    public virtual void  previous() {
        pageNumber--;
        if(pageNumber<0){
            pageNumber=0;
            offset=0;
        }else{
            offset=(pageNumber-1)*pageSize;
        }          
    } 
   
   //下一页
    public virtual void  next() {             
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
    
    //获取偏移量
    public virtual Integer getOffset(){
            return offset;
    }

    //获取每页显示条数
    public virtual Integer getSize(){
            return pageSize;
    }    
    
    
}