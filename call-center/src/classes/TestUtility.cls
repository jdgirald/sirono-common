/*
 * Copyright (c) 2017-present Sirono LLC, All rights reserved
 */

/*
 * Test utilities to create records.
 */
@IsTest
public class TestUtility {
    public static String body = '{"token":"bar"}';
    public static String responsebody = '{"token":"bar"}';
    public static Integer statusCode = 200;
    public static Integer statusCode2 = 200;
    public static String status = 'CREATED';
    public static String errorbody = '' ;
    public static Integer currentDay = 22;
    public static Integer currentMonth = 12;
    public static Integer currentYear = 2017;
    public static String planType = 'auto';
    public static String errorDate = '2016-05-13';
    public static String delinquentDate = '2016-05-13';
    public static final String ACCOUNT_NAME = 'TestAccount';
    public static final String ADMIN_EMAIL = 'bruce.wayne@wayneenterprises.com';
    public static final Decimal PROFILE_POINTER = 999;

    public static String url = 'http://127.0.0.1:8000/paystaff/api/paymentplan/2876/';

    // Enum for JSON body type responses
    public enum JSON_BODY_TYPE {
        PAYMENT_CHARGEGROUPS,
        PAYMENT_EXISTING_PLAN,
        PAYMENT_NON_FIELD,
        PAYMENT_LIST,
        NO_KIND,
        UNAUTHORIZED,
        VALIDATION_EXISTING_PLAN
    }

    // Map of JSON_BODY_TYPE enum to json body response.
    public static Map<JSON_BODY_TYPE, String> JSON_ERROR_BODIES = new Map<JSON_BODY_TYPE, String> {
        JSON_BODY_TYPE.PAYMENT_CHARGEGROUPS => '{"kind":"Payments Exception","errors":{"chargegroups":["Invalid hyperlink - Object does not exist."],"guarantor":["Invalid hyperlink - Object does not exist."]}}',
        JSON_BODY_TYPE.PAYMENT_EXISTING_PLAN => '{"kind":"Payments Exception","errors":{"non_field_errors":["Amount exceeds selected charge groups"]}}',
        JSON_BODY_TYPE.PAYMENT_NON_FIELD => '{"kind":"Payments Exception","errors":{"non_field_errors":["Amount exceeds selected charge groups"]}}',
        JSON_BODY_TYPE.PAYMENT_LIST => '{"kind":"Payments Exception","errors":["Credit card number is invalid.","Merchant account does not support payment instrument."]}',
        JSON_BODY_TYPE.NO_KIND => '{"non_field_errors":["Cannot directly change ChargeGroups on an existing plan"]}',
        JSON_BODY_TYPE.UNAUTHORIZED => '{"kind":"Permission Denied Exception","errors":["Incorrect authentication credentials."]}',
        JSON_BODY_TYPE.VALIDATION_EXISTING_PLAN => '{"kind":"Validation exception","errors":[{"non_field_errors":"Cannot directly change ChargeGroups on an existing plan"}]}'
    };

    private TestUtility() {
        // Utility class
    }

    private static Decimal getUniqueId() {
        return Decimal.valueOf(Math.random());
    }

    // Return Guarantor Contact record
    public static Contact generateGuarantorContact() {
        return generateGuarantorContactByName('Test Guarantor');
    }

    // Return Guarantor Contact record
    public static Contact generateGuarantorContactByName(String gurantorName) {
        Contact guarantorContact = new Contact();
        guarantorContact.RecordTypeId = RecordTypeUtil.guarantorRt;
        guarantorContact.LastName = gurantorName;
        guarantorContact.Profile_Pointer_ID__c = getUniqueId();
        guarantorContact.HomePhone = '111';
        guarantorContact.MobilePhone = '111';
        return guarantorContact;
    }

    // Return Patient Contact record
    public static Contact generatePatientContact() {
        Contact patientContact = new Contact();
        patientContact.RecordTypeId = RecordTypeUtil.patientRt;
        patientContact.LastName = 'Test Patient';
        patientContact.HomePhone = '111';
        patientContact.MobilePhone = '111';
        patientContact.Patient_Id__c = getUniqueId();
        return patientContact;
    }

    // Return ExternalGuarantor Contact record
    public static Contact generateExternalGuarantor() {
        Contact externalGT = new Contact();
        externalGT.RecordTypeId = RecordTypeUtil.externalGtRt;
        externalGT.LastName = 'Test External GT';
        externalGT.External_Guarantor_Id__c = getUniqueId();
        return externalGT;
    }

    // Return charge group record
    public static Charge_Group__c generateChargeGroup(String guarantorContactId,
        String patientContactId,
        Decimal chargeGroupExternalId,
        String paymentplanID) {
        Charge_Group__c chargeGroup = generateChargeGroup(guarantorContactId, patientContactId, chargeGroupExternalId);
        chargeGroup.Payment_Plan__c = paymentplanID;
        return chargeGroup;
    }

    // Return charge group record
    public static Charge_Group__c generateChargeGroupWithExternalId(String guarantorContactId,
        String patientContactId,
        Decimal chargeGroupExternalId) {
        return generateChargeGroup(guarantorContactId, patientContactId, chargeGroupExternalId);
    }

    // Return charge group record with external Id from parameter
    public static Charge_Group__c generateChargeGroup(String guarantorContactId,
        String patientContactId,
        Decimal chargeGroupExternalId) {
        Charge_Group__c cg = new Charge_Group__c();
        cg.Guarantor__c = guarantorContactId;
        cg.Sirono_ID__c = getUniqueId();
        cg.Patient__c = patientContactId;
        cg.External_ID__c = String.valueOf(chargeGroupExternalId);
        cg.Name = 'Sirono';
        cg.Charge_Group_External_ID__c = true;
        cg.Reported_Selfpay_Balance__c = 10;
        cg.Active__c = true;
        cg.Account_Status__c = Constants.ACCT_STATUS_BILLED;
        cg.Account_Sub_Status__c = Constants.ACCT_SUBSTATUS_PREINVOICED;

        return cg;
    }

    // Return transaction record
    public static Transaction__c generateTransaction(Charge_Group__c chargeGroup,
        Decimal amount,
        String method) {
        Transaction__c objTransaction = new Transaction__c();
        objTransaction.Amount__c = amount == null ? 0 : amount;
        objTransaction.Charge_Group__c = chargeGroup.Id;
        objTransaction.Credit_Balance__c = amount < 0;
        objTransaction.Fail_Date__c = null;
        objTransaction.Sirono_ID__c = getUniqueId();
        objTransaction.Notes__c = 'Test txn';
        objTransaction.Post_Date__c = System.today().addDays('Credit'.equals(method) ? 7 : -7);
        return objTransaction;
    }

    // Return Encounter record
    public static Encounter__c generateEncounter(String guarantorId,
        Decimal patientPortion,
        Date serviceDate) {
        Encounter__c encounter = new Encounter__c(Guarantor__c = guarantorId,
            Patient_Portion__c = patientPortion,
            Date_of_Service__c = serviceDate);
        return encounter;
    }

    // Return a new case record
    public static Case generateCase(String rTypeId, String cType, String gId) {
        Case objCase = new Case();
        objCase.RecordTypeId = rTypeId;
        objCase.Status = Constants.CASE_STATUS_NEW;
        objCase.Priority = Constants.CASE_PRIORITY_MEDIUM;
        objCase.Type = cType;
        objCase.Origin = Constants.CASE_ORIGIN_EMAIL;
        objCase.Subject = cType;
        objCase.Description = 'Test';
        objCase.Guarantor_Information__c = gId;
        return objCase;
    }

    // Return a new Statement record
    public static Statement__c generateStatement(String contactId) {
        Statement__c stmt = new Statement__c();
        stmt.Statement_Date__c = System.today();
        stmt.Guarantor__c = contactId;
        return stmt;
    }

    // Return a new campaign record
    public static Campaign generateCampaign(String name) {
        Campaign objCampaign = new Campaign();
        objCampaign.Name = name;
        objCampaign.IsActive = true;
        return objCampaign;
    }

    // Return a new payment plan record
    public static Payment_Plan__c generatePaymentPlan(String guarantorId) {
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Sirono_ID__c = getUniqueId();
        paymentPlan.Guarantor__c = guarantorId;
        return paymentPlan;
    }

    // Return an Active PaymentPlan record
    public static Payment_Plan__c generatePaymentPlan(Contact guarantor) {
        Payment_Plan__c paymentPlan = generatePaymentPlan(guarantor.Id);
        paymentPlan.Active__c = true;
        return paymentPlan;
    }

    // Return a new Invoice record
    public static Invoice__c generateInvoice(String guarantorId, String patientId) {
        Invoice__c invoice = new Invoice__c();
        invoice.Guarantor__c = guarantorId;
        invoice.Due_Date__c = System.today();
        invoice.Date__c = System.today();
        invoice.Sirono_Id__c = getUniqueId();
        invoice.Patient__c = patientId;
        return invoice;
    }

    // Return a new Case Comment
    public static CaseComment generateCaseComment(String parentId) {
        CaseComment cc = new CaseComment();
        cc.CommentBody = 'Test';
        cc.ParentId = parentId;
        return cc;
    }

    // Return payment method record
    public static Payment_Method__c generatePaymentMethod(String guarantorId, String recordTypeID) {
        Payment_Method__c paymentMethod = new Payment_Method__c();
        paymentMethod.Guarantor__c = guarantorId;
        paymentMethod.RecordTypeId = recordTypeID;
        return paymentMethod;
    }

    // return list of charge_group__c records
    public static List<Charge_Group__c> generateChargeGroupList(Id contID) {
        List<Charge_Group__c> lstChargeGroup = new List<Charge_Group__c>();
        for (Integer i = 0; i < 20; i++) {
            Charge_Group__c chargeGroup = new Charge_Group__c();
            chargeGroup.Name = 'xyz' + i;
            chargeGroup.Guarantor__c = contID;
            lstChargeGroup.add(chargeGroup);
        }
        return lstChargeGroup;
    }

    // return CampaignMember record
    public static CampaignMember generateCampaignMember(Id campaignId, Id guarantorContactId) {
        CampaignMember objcampaignMember = new CampaignMember();
        objcampaignMember.CampaignId = campaignId;
        objcampaignMember.ContactId = guarantorContactId;
        objcampaignMember.Status = Constants.SENT;
        return objcampaignMember;
    }

    // return Task record
    public static Task generateTask(Id guarantorContactId) {
        Task objTask = new Task();
        objTask.WhoId = guarantorContactId;
        objTask.Priority = Constants.TASK_PRIORITY_NORMAL;
        objTask.Status = Constants.TASK_STATUS_NEW;
        objTask.CallDisposition = 'Final';
        objTask.Five9__Five9Campaign__c = 'Pre-collection';
        return objTask;
    }

    /**
     * This method is use to Generate Exception.
     *
     * @returns Integer/Exception.
     **/
    public static Integer generateException() {
        // We put try/catch here because of we need to check System Assert for this method.
        // We got this method as a Missing assert in Security Scan Report.
        try {
            return 1 / 0;
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('Divide by 0'), 'Should have failed due to Arithmetic Operation.');
            throw ex;
        }
    }

    public static Decimal generateRandomCurrency() {
        Double randomDouble = Math.random() * 100;
        Decimal randomCurrencyValue = Decimal.valueOf(randomDouble).setScale(2);

        return randomCurrencyValue;
    }
    private static Payment__c generatePayment() {
        Payment__c payment = new Payment__c();
        payment.Deposit_Date__c = System.today();
        return payment;
    }

    public static Payment__c generatePASPayment(String pmtKey) {
        Payment__c pmt = generatePayment();
        pmt.ID__c = pmtKey;
        return pmt;
    }

    public static Payment__c generateSironoPayment(Id guarantorId, Decimal sironoId, Decimal amount) {
        Payment__c payment = generatePayment();
        payment.Guarantor__c = guarantorId;
        payment.Sirono_ID__c = sironoId;
        payment.Amount__c = amount;
        return payment;
    }

    public static Adjustment__c generateAdjustment(Id guarantorId, String aggregateKey, Id externalGuarantorId) {
        return new Adjustment__c(Guarantor__c = guarantorId, Aggregate_Id__c = aggregateKey, External_Guarantor__c = externalGuarantorId);

    }

    // Return a payment transaction
    public static Transaction__c generatePaymentTxn(Charge_Group__c chargeGroup,
        Decimal amount,
        Payment__c pmt) {
        Transaction__c objTransaction = generateTxn(chargeGroup, amount);
        objTransaction.Payment__c = pmt.Id;
        return objTransaction;
    }

    // Return a service transaction
    public static Transaction__c generateServiceTxn(Charge_Group__c chargeGroup,
        Decimal amount,
        Service2__c svc) {
        Transaction__c objTransaction = generateTxn(chargeGroup, amount);
        objTransaction.Post_Date__c = System.today().addDays(-7);
        objTransaction.Service2__c = svc.Id;
        return objTransaction;
    }

    // Return an adjustment transaction
    public static Transaction__c generateAdjTxn(Charge_Group__c chargeGroup,
        Decimal amount,
        Adjustment__c adj) {
        Transaction__c objTransaction = generateTxn(chargeGroup, amount);
        objTransaction.Adjustment2__c = adj.Id;

        // Check system assert.
        System.assertNotEquals(objTransaction, null, 'Should have failed due to Transaction object is null.');

        return objTransaction;
    }

    //Build a skeletal transaction
    private static Transaction__c generateTxn(Charge_Group__c chargeGroup, Decimal amount) {
        Transaction__c txn = new Transaction__c();
        txn.Amount__c = amount == null ? 0 : amount;
        txn.Charge_Group__c = chargeGroup.Id;
        txn.Sirono_ID__c = getUniqueId();
        txn.Post_Date__c = System.today();
        txn.Transaction_Date__c = System.today();
        return txn;
    }

    // Build and return a service record
    public static Service2__c generateService(Contact guarantor, Decimal amount) {
        Service2__c srv = new Service2__c();
        srv.Amount__c = amount;
        srv.Guarantor__c = guarantor.Id;
        return srv;
    }
    
    /**
     * This method is use to create/generate Read Only User.
     *
     * @returns User readOnlyUser - That contains User as a Read Only.
     **/
    public static User generateReadOnlyUser() {
        Profile readOnlyProf = [SELECT Id FROM Profile WHERE Name = :Constants.READ_ONLY_PROFILE];
        User readOnlyUser = new User(Alias = 'readonly', Email = 'readonlyuserr@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = readOnlyProf.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'readonlyuserr@testorg.com');

        // Check system assert.
        System.assertNotEquals(readOnlyUser, null, 'Should have failed due to user is null.');

        return readOnlyUser;
    }

    /**
     * This method is use to create/generate Chatter Only User.
     *
     * @returns User chatterOnlyUser - That contains User as a Chatter Only (Read/Write/Update/Delete rights are not there).
     **/
    public static User generateChatterOnlyUser() {
        Profile chatterOnlyProf = [SELECT Id FROM Profile WHERE Name = :Constants.CHATTER_ONLY_USER_PROFILE];
        User chatterOnlyUser = new User(Alias = 'ctronly', Email = 'chatteronlyuserr@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = chatterOnlyProf.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'chatteronlyuserr@testorg.com');

        // Check system assert.
        System.assertNotEquals(chatterOnlyUser, null, 'Should have failed due to user is null.');

        return chatterOnlyUser;
    }

    /**
     * This method is use to create/generate a User using the given profile.
     *
     * @returns User newUser - That contains User
     **/
    //TODO refactor the other generate user methods to use this
    public static User generateUser(String profileName, Id gtId) {
        Profile prof = [SELECT Id FROM Profile WHERE Name = :profileName];
        String prefix = profileName.deleteWhitespace();
        prefix = prefix.substring(0, Math.min(8, prefix.length()));
        User newUser = new User(Alias = prefix, Email = prefix + '_user@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = prof.Id,
            ContactId = gtId,
            TimeZoneSidKey = 'America/Los_Angeles', Username = prefix + '_user@testorg.com');

        // Check system assert.
        System.assertNotEquals(newUser, null, 'Expected valid user, but is null.');

        return newUser;
    }

    /**
     * Assign the specified PermissionSet to the given User
     *
     **/
    public static void assignPermissionSet(String psName, User newUser) {

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :psName];
        System.assert(ps != null, 'Unable to retrieve permission set: ' + psName);

        insert new PermissionSetAssignment(AssigneeId = newUser.Id, PermissionSetId = ps.Id);
    }

    /**
     * Creates and returns an unpersisted system administrator user.
     *
     * @returns a sys admin user
     */
    public static User getAdminUser() {
        Profile adminProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'System Administrator'
        ];
        User adminUser = new User(
            Alias = 'standt',
            Email = 'admin@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'admin@testorg1212.com'
        );
        return adminUser;
    }

    /**
     * Utilty for getting a Guarantor Portal Community user.
     *
     * @return User - The User object assigned the profile of a user using the Guarantor Portal.
     */
    public static User getGuarantorCommunityUser() {
        String testUsername = UserInfo.getOrganizationId() + '-' + System.now().millisecond() + '-testGTUser@test.io';
        String testAdminUsername = UserInfo.getOrganizationId() + '-' + System.now().millisecond() + '-testAdmin@test.com';

        UserRole portalRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User portalAdminUser = new User(
            UserRoleId = portalRole.Id,
            ProfileId = adminProfile.Id,
            Username = testAdminUsername,
            Alias = 'batman',
            Email = ADMIN_EMAIL,
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Bruce',
            LastName = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );

        Account a = null;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser) {
            //Create portal account owner
            Database.insert(portalAdminUser);
            //Create account
            a = new Account(Name = ACCOUNT_NAME, OwnerId = portalAdminUser.Id);
            Database.insert(a);
        }

        User usr;

        // Sometimes the user hasn't been cleared from the previous test, so if it still exists use it.
        List<User> users = [
            SELECT Alias, Email, EmailEncodingKey, FirstName, LastName, LanguageLocaleKey,
                LocaleSidKey, ProfileId, ContactId,
                TimeZoneSidKey, Username, Contact.Profile_Pointer_ID__c
            FROM User
            WHERE Username = :testUsername
            LIMIT 1
        ];

        if (users.size() > 0) {
            usr = users.get(0);
        } else {

            System.runAs(portalAdminUser) {
                //Create Guarantor Contact record
                Contact gt = TestUtility.generateGuarantorContact();
                gt.Profile_Pointer_ID__c = PROFILE_POINTER;
                gt.AccountId = a.Id;
                gt.OwnerId = portalAdminUser.Id;
                Database.insert(gt);


                System.debug('Create portalUser for contact: ' + gt.Id);
                usr = TestUtility.generateUser(Constants.GUARANTOR_PORTAL_PROFILE, gt.Id);
                usr.Username = testUsername;

                insert usr;

                // Give the user the Guarantor permission sets
                List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
                List<PermissionSet> permissionSets = [
                    SELECT Id
                    FROM PermissionSet
                    WHERE Name IN (:Constants.PERMISSION_SET_GUARANTOR, :Constants.PERMISSION_SET_GUARANTOR_LOCAL)
                ];
                System.assertEquals(2, permissionSets.size(), 'Guarantor permission sets not found.');
                for (PermissionSet permissionSet : permissionSets) {
                    PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(
                        AssigneeId = usr.Id,
                        PermissionSetId = permissionSet.Id
                    );
                    permissionSetAssignments.add(permissionSetAssignment);
                }
                insert permissionSetAssignments;

                usr = null;
                usr = [
                    SELECT Id, Alias, Email, EmailEncodingKey, FirstName, LastName, LanguageLocaleKey,
                        LocaleSidKey, ProfileId, ContactId,
                        TimeZoneSidKey, Username, Contact.Profile_Pointer_ID__c
                    FROM User
                    WHERE Username = :testUsername
                    LIMIT 1
                ];

                System.assertNotEquals(usr, null, 'User with username: ' + testUsername + ' not found');
            }

            System.assertNotEquals(usr, null, 'User with username: ' + testUsername + ' not found');
        }
        return usr;
    }

    /**
     * Get the guarantor associated with the Guarantor Community User.
     *
     * @return Contact - The Guarantor.
     */
    public static Contact getPortalGuarantor() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Profile_Pointer_ID__c = :PROFILE_POINTER];

        System.assert(contacts.size() != 0, 'Could not find the guarantor for the community user.');
        return contacts[0];
    }

    public static void createAllCampaigns() {

        List<Campaign> campaigns = new List<Campaign>();
        for (String caseType : Constants.CASE_CG_SUBSTATUS.keySet()) {
            Set<String> cmpnNames = CampaignMemberDao.getSFCampaignNames(caseType);
            for (String cmpnName : cmpnNames) {
                campaigns.add(TestUtility.generateCampaign(cmpnName));
            }
        }
        insert campaigns;
    }
}