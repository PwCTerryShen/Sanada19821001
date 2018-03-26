public with sharing class GoodsController {
        
        public List<GOODS__c>goodsList{get;set;}
	    public List<CategoryWrapper>categoriesList{get;set;}
    
        public List<SelectOption> goodsTypes = new List<SelectOption>();
                
        public GOODS__c goods{get;set;}
        
        public Boolean isStatus{get;set;}
        
        public String goodsName{get;set;}
        
        public String goodsType{get;set;}
        
        public String goodsPriceStart{get;set;}
     
        public String goodsPriceEnd{get;set;}
     
        public String goodsDescribe{get;set;}  
     
    	public string goodsSql;

    	//分页用
    	public ApexPages.StandardSetController con {
        	get {
            if(con == null) {                
                con = new ApexPages.StandardSetController(Database.getQueryLocator(goodsSql));
                // sets the number of records in each page set
                con.setPageSize(2);
            }
            return con;
        	}
        	set;
    	}
    
        public GoodsController() {
            goodsList = new List<GOODS__c>();
            refreshData();
        }
    
        public List<selectOption> getTypeNames() {
            goodsTypes.clear();
         	goodsTypes.add(new SelectOption('请选择','请选择'));
         	goodsTypes.add(new SelectOption('001','电脑'));
         	goodsTypes.add(new SelectOption('002','汽车'));
            return goodsTypes;
        }
        
        
        //刷新数据作用
        public void refreshData() {
            Boolean isStatus = true;
            goodsList.clear();
            goodsSql = 'SELECT GoodsBrand__c,GoodsDescribe__c,GoodsName__c, GoodsType__c, GoodsPrice__c,Id FROM Goods__c where IsDeleted = false limit 100';
            categoriesList = new List<categoryWrapper>();
            for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
				categoriesList.add(new CategoryWrapper(tempe1));    
                goodsList.add(tempe1);
            }
        }

        public void save() {
            try {
                upsert goodsList;
            } catch(DmlException e) {
                ApexPages.addMessages(e);
            }
        }
        
        public void deleteGoods() {
            Id id = ApexPages.currentPage().getParameters().get('goodsId');
            Database.delete(id);
            refreshData();
        }
        
        public void add() {
            if(goodsList == null) {
                goodsList = new List<GOODS__c>();
            }
            GOODS__c goods2 = new GOODS__c();
            goods2.GoodsName__c = goodsName;
            goods2.GoodsDescribe__c = goodsDescribe;
            goods2.GoodsType__c = goodsType;
            goods2.GoodsPrice__c = goodsPriceStart;

            System.debug('-----------goodsList------------------'+goodsList);
            if(goodsList.size() == 0) {
                goodsList.add(goods2);
            } else {
                goodsList.add(0,goods2);
            }
        }
        
        public void query() {
     
            goodsSql = 'SELECT GoodsBrand__c,'+
                               'GoodsDescribe__c,GoodsName__c , GoodsType__c, GoodsPrice__c,'+
                                ' Id FROM GOODS__c where IsDeleted = false ';
            if(goodsName.length() >0 ) {
                goodsName = '%' + goodsName + '%';
                goodsSql += ' and GoodsName__c like :goodsName ';
            }      
            if(goodsType.length() >0 && !goodsType.equals('请选择')) {
                goodsType = '%' + goodsType + '%';
                goodsSql += ' and GoodsType__c like :goodsType';
            }
            goodsSql += ' limit 100';
            goodsList.clear();
            for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
				categoriesList.add(new CategoryWrapper(tempe1));    
                goodsList.add(tempe1);
            }
            
            goodsName = goodsName.remove('%');
            goodsType = goodsType.remove('%');
        }
    
    // displays the selected items
     public PageReference process() {
         for (CategoryWrapper cw : categoriesList) {
             if (cw.checked)
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.goods.GOODSNAME__c));
         }
         return null;
     }
    
	// indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // returns the first page of records
     public void first() {
         con.first();
         for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
             categoriesList.add(new CategoryWrapper(tempe1));    
             goodsList.add(tempe1);
         }
     }
    
     // returns the last page of records
     public void last() {
         con.last();
         for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
             categoriesList.add(new CategoryWrapper(tempe1));    
             goodsList.add(tempe1);
         }
     }
    
     // returns the previous page of records
     public void previous() {
         goodsList.clear();
         con.previous();
         for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
             categoriesList.add(new CategoryWrapper(tempe1));    
             goodsList.add(tempe1);
         }
     }
    
     // returns the next page of records
     public void next() {
         goodsList.clear();
         con.next();
         for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
             categoriesList.add(new CategoryWrapper(tempe1));    
             goodsList.add(tempe1);
         }
     }
    
     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
 

    
     public void skip1() {
         goodsList.clear();
         con.setPageNumber(pageNumber+1);
         for (GOODS__c tempe1 : (List<GOODS__c>)con.getRecords()){
             goodsList.add(tempe1);          
         }
     }
    
}