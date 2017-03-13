/**
 * This class is use for Security Context of Invoice__c object.
 **/
 
public with sharing class InvoiceSecurityContext extends SecurityContext {
	
    // Field constants for Invoice__c object
    private static final String ALL_SUBSTATUS = 'All_Substatus__c';
    private static final String INVOICE_BALANCE = 'Invoice_Balance__c';
    private static final String INVOICE_STATUS_INDEX = 'Invoice_Status_Index__c';

    // The fields for updating a Invoice__c's Invoice_Status_Index__c field in InvoiceUtil
    private static final Set<String> UPDATE_FIELDS = new Set<String>{
    	INVOICE_STATUS_INDEX 
    };

    // The fields for updating a Invoice__c's All_Substatus__c field in InvoiceUtil
    private static final Set<String> UPDATE_ALL_SUBSTATUS_FIELDS = new Set<String>{
    	ALL_SUBSTATUS 
    };

    // The fields for updating a Invoice__c's Invoice_Balance__c field in InvoiceUtil
    private static final Set<String> UPDATE_BALANCE_FIELDS = new Set<String>{
    	INVOICE_BALANCE 
    };

    /**
     * Constructor of class that assign variables based on parameters
     *
     * @param Set<String> fields - That contains Object's Fields
     * @param ACTION actionToPerform - That contains Action Name (Create/Update/Delete/Undelete)
     **/
    private InvoiceSecurityContext(Set<String> fields, ACTION actionToPerform) {
        this.fieldsToCheck = fields;
        this.objectAction = actionToPerform;
    }
    
    /**
     * The update context for Invoice__c's Invoice_Status_Index__c field in InvoiceUtil
     **/
    public static final InvoiceSecurityContext UPDATE_CONTEXT = new InvoiceSecurityContext(UPDATE_FIELDS, ACTION.OBJ_UPDATE);
    
    /**
     * The update context for Invoice__c's All_Substatus__c field in InvoiceUtil
     **/
    public static final InvoiceSecurityContext UPDATE_ALL_SUBSTATUS_CONTEXT = new InvoiceSecurityContext(UPDATE_ALL_SUBSTATUS_FIELDS, ACTION.OBJ_UPDATE);

    /**
     * The update context for Invoice__c's Invoice_Balance__c field in InvoiceUtil
     **/
    public static final InvoiceSecurityContext UPDATE_BALANCE_CONTEXT = new InvoiceSecurityContext(UPDATE_BALANCE_FIELDS, ACTION.OBJ_UPDATE);

    /**
     * Override getObjectType method of SecurityContext class
     **/
    public override System.Type getObjectType() {
        return Invoice__c.class;
    }
    
    /**
     * Override deleteActionAllowed method of SecurityContext class
     **/
    public override Boolean deleteActionAllowed() { 	
        return Invoice__c.sObjectType.getDescribe().isDeletable();
    }
}