/*
 * Copyright (c) 2017-present Sirono LLC, All rights reserved
 */

/**
 * This class is use for Security Context of Charge Group object
 **/
public with sharing class ChargeGroupSecurityContext extends SecurityContext {

    // Field constants for Charge_Group__c object
    private static final String ACCOUNT_STATUS = 'Account_Status__c';
    private static final String ACCOUNT_SUB_STATUS = 'Account_Sub_Status__c';
    private static final String PAYMENT_PLAN = 'Payment_Plan__c';

    // Below field(s) are use for Select/Read permission.
    private static final String ACCOUNT_TYPE = 'Account_Type__c';
    private static final String ACTIVE = 'Active__c';
    private static final String BALANCE = 'Balance__c';
    private static final String CREATEDDATE = 'CreatedDate';
    private static final String DATE_OF_SERVICE_END_DATE = 'Date_Of_Service_End_Date__c';
    private static final String DATE_OF_SERVICE_START_DATE = 'Date_Of_Service_Start_Date__c';
    private static final String ENCOUNTER = 'Encounter__c';
    private static final String EXTERNAL_ID = 'External_ID__c';
    private static final String GUARANTOR = 'Guarantor__c';
    private static final String ID = 'Id';
    private static final String INVOICE = 'Invoice__c';
    private static final String LOCATION = 'Location__c';
    private static final String NAME = 'Name';
    private static final String PATIENT = 'Patient__c';
    private static final String PRE_COLLECTION_SENT = 'Pre_Collection_Sent__c';
    private static final String PROVIDER = 'Provider__c';
    private static final String REPORTED_INSURANCE_BALANCE = 'Reported_Insurance_Balance__c';
    private static final String REPORTED_PREBILL_BALANCE = 'Reported_Prebill_Balance__c';
    private static final String REPORTED_SELFPAY_BALANCE = 'Reported_Selfpay_Balance__c';
    private static final String SIRONO_ID = 'Sirono_ID__c';
    private static final String SUB_STATUS_INDEX = 'Sub_Status_Index__c';
    
    // The fields for updating a Charge Group
    private static final Set<String> UPDATE_FIELDS = new Set<String> {
    
        ACCOUNT_STATUS, ACCOUNT_SUB_STATUS, PAYMENT_PLAN
    };

    // The fields for selecting a Charge Group in ChargeGroupDao, CaseCommentTriggerHandler, PaymentPlanJSONParsing,
    // CallListUtilities, TransactionJSONParsing, EncounterUtil, PreCollectionSchedulerBatch, CreateCaseManual, CaseUtil.
    private static final Set<String> SELECT_FIELDS = new Set<String> {
        ID, SIRONO_ID, PRE_COLLECTION_SENT, ACCOUNT_SUB_STATUS, PAYMENT_PLAN, ENCOUNTER,
        NAME, GUARANTOR, CREATEDDATE, PATIENT, DATE_OF_SERVICE_START_DATE
    };

    // The fields for selecting a Charge Group in GuarantorDao, PayStaffWSUtill.
    private static final Set<String> GD_SELECT_FIELDS = new Set<String> {
        ID, NAME, SIRONO_ID, GUARANTOR, EXTERNAL_ID, ACTIVE, REPORTED_INSURANCE_BALANCE,
        REPORTED_PREBILL_BALANCE, REPORTED_SELFPAY_BALANCE, PATIENT, ACCOUNT_TYPE,
        DATE_OF_SERVICE_START_DATE, DATE_OF_SERVICE_END_DATE, BALANCE, INVOICE,
        ACCOUNT_STATUS, PROVIDER, LOCATION, ACCOUNT_SUB_STATUS
    };

    // The fields for selecting a Charge Group in InvoiceUtil, PaymentPlanUtil
    private static final Set<String> IU_SELECT_FIELDS = new Set<String> {
        INVOICE, SUB_STATUS_INDEX, ACTIVE, ACCOUNT_SUB_STATUS, BALANCE, PAYMENT_PLAN, SIRONO_ID
    };

    /**
     * Constructor of class that assign variables based on parameters
     *
     * @param Set<String> fields - That contains Object's Fields
     * @param ACTION actionToPerform - That contains Action Name (Create/Update/Delete/Undelete)
     **/
    private ChargeGroupSecurityContext(Set<String> fields, ACTION actionToPerform) {
        this.fieldsToCheck = fields;
        this.objectAction = actionToPerform;
    }

    /**
     * The update context for Charge Group in AddToPaymentPlan & AddCreditCard.
     **/
    public static final ChargeGroupSecurityContext UPDATE_CONTEXT = new ChargeGroupSecurityContext(UPDATE_FIELDS, ACTION.OBJ_UPDATE);

    /**
     * The select context for Charge Group in ChargeGroupDao, CaseCommentTriggerHandler, PaymentPlanJSONParsing,
     * CallListUtilities, TransactionJSONParsing, EncounterUtil, PreCollectionSchedulerBatch, CreateCaseManual, CaseUtil.
     **/
    public static final ChargeGroupSecurityContext SELECT_CONTEXT = new ChargeGroupSecurityContext(SELECT_FIELDS, ACTION.OBJ_READ);

    /**
     * The select context for Charge Group in GuarantorDao, PayStaffWSUtill.
     **/
    public static final ChargeGroupSecurityContext GD_SELECT_CONTEXT = new ChargeGroupSecurityContext(GD_SELECT_FIELDS, ACTION.OBJ_READ);

    /**
     * The select context for Charge Group in InvoiceUtil, PaymentPlanUtil.
     **/
    public static final ChargeGroupSecurityContext IU_SELECT_CONTEXT = new ChargeGroupSecurityContext(IU_SELECT_FIELDS, ACTION.OBJ_READ);

    /**
     * Override getObjectType method of SecurityContext class.
     **/
    public override System.Type getObjectType() {
        return Charge_Group__c.class;
    }
}