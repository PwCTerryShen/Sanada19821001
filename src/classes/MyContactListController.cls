public class MyContactListController {
    
    @AuraEnabled
    public static List<Contact> getContacts(Id recordId) {
    	//System.debug('***********************Result1===='+recordId); 
		//list<Contact> acclst = [Select Id, FirstName, LastName, Email, Phone From Contact Where AccountId = :recordId];  
       	//System.debug('***********************Result2===='+acclst.size()); 
        return [Select Id, FirstName, LastName, Email, Phone From Contact Where AccountId = :recordId];
    }

}