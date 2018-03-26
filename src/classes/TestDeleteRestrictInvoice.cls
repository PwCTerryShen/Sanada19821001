@isTest
private class TestDeleteRestrictInvoice {
    // Invoice generator, with or without a Line Item
    static Invoice__c createNewInvoice(Boolean withLineItem) {
        // Create test Merchandise
            Merchandise__c merchandise = new Merchandise__c(
            Name = 'Test Laptop',
            Quantity__c = 1000,
            Price__c = 500);
        
        insert merchandise;
        
        // Create test Invoice 
        Invoice__c invoice = new Invoice__c();
        insert invoice;
        // Create test Line Item and insert it into the database, if withLineItem == true
        if (withLineItem) {
            Line_Item__c item = new Line_Item__c(
                name = '1',
            Quantity__c = 1,
            Merchandise__c = merchandise.Id,
            Invoice__c = invoice.Id
            );
            insert item;
    	}
    	return invoice;
	}
    
    // Single row Invoice with no Line Items => delete
    static testMethod void verifyInvoiceNoLineItemsDelete(){
        // Create test Invoice and insert it
        Invoice__c invoice = createNewInvoice(false);
        // Delete the Invoice, capture the result
        Database.DeleteResult result = Database.delete(invoice, false);
        // Assert success, because target Invoice doesn't have Line Items
        System.assert(result.isSuccess());
    }
}