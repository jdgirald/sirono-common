/*
 * Copyright (c) 2017-present Sirono LLC, All rights reserved
 */

/**
 * JSONParser for the charge group responses form the Sirono service.
 */

public with sharing class ChargeGroupJSONParser extends AbstractSironoJSONParser {
    public class Patient_data {
        public String mrn;
        public String patient_name;
    }

    public class Invoice {
        public String invoice_date;
        public String due_date;
    }

    public class ChargeGroupJSON {
        public String url;
        public String account_type;
        public String account_number;
        public Boolean active;
        public String status;
        public String extended_status;
        public String pas_specific_origin_code;
        public Integer balance;
        public Invoice invoice;
        public Boolean bad_debt_status;
        public String date_of_service_start;
        public String date_of_service_end;
        public Boolean charges_since_paymentplan;
        public String mapped_location_or_provider;
        public String processed_charges_details;
        public Patient_data patient_data;
        public Guarantor_data guarantor_data;
        public String account_status;
        public String account_sub_status;
        public String paymentplan;
    }

    public class Guarantor_data {
        public String display_id;
        public String url;
        public String full_name;
    }

    public static ChargeGroupJSON parse(String json) {
        return (ChargeGroupJSON) System.JSON.deserialize(json, ChargeGroupJSON.class);
    }

    public Charge_Group__c asChargeGroup(ChargeGroupJSON cgJson) {
        String gtId = parseSironoId(cgJson.guarantor_data.url, RestClientConstants.GUARANTOR_URL_RESOURCE_TYPE);
        Contact gt = GuarantorDao.getGuarantorBySironoId(gtId);

        String cgId = parseSironoId(cgJson.url, RestClientConstants.CHARGE_GROUP_URL_RESOURCE_TYPE);

        Charge_Group__c cg = new Charge_Group__c(Sirono_ID__c=Decimal.valueOf(cgId), Account_Sub_Status__c = cgJson.account_sub_status,
                Account_Status__c = cgJson.account_status, Guarantor__c = gt.Id);

        if (cgJson.paymentplan != null) {
            String pplanId = parseSironoId(cgJson.paymentplan, RestClientConstants.PPLAN_URL_RESOURCE_TYPE);
            Payment_Plan__c pplan = PaymentPlanService.getPaymentPlanBySironoId(pplanId);
            cg.Payment_Plan__c = pplan.Id;
        }
        return cg;
    }

    public static String testResponse() {
        String json = '{' +
            '' +
            '   "url": "https://toledo.stage.sirono.com/paystaff/api/chargegroups/1113401/",' +
            '' +
            '   "account_type": "HB",' +
            '' +
            '   "account_number": "A1322100179",' +
            '' +
            '   "active": true,' +
            '' +
            '   "status": "Paid",' +
            '' +
            '   "extended_status": "Paid",' +
            '' +
            '   "pas_specific_origin_code": "HBO",' +
            '' +
            '   "balance": 0,' +
            '' +
            '   "invoice": {' +
            '' +
            '      "invoice_date": "2015-08-20",' +
            '' +
            '      "due_date": "2015-09-10"' +
            '' +
            '   },' +
            '' +
            '   "bad_debt_status": false,' +
            '' +
            '   "date_of_service_start": "2013-08-09",' +
            '' +
            '   "date_of_service_end": "2013-08-09",' +
            '' +
            '   "charges_since_paymentplan": false,' +
            '' +
            '   "mapped_location_or_provider": "UT Ruppert Health Center",' +
            '' +
            '   "processed_charges_details": "Paramount has finished processing these charges.",' +
            '' +
            '   "patient_data": {' +
            '' +
            '      "mrn": "A01026426",' +
            '' +
            '      "patient_name": "PEYTON BROWN"' +
            '' +
            '   },' +
            '' +
            '   "guarantor_data": {' +
            '' +
            '      "display_id": "TD157913",' +
            '' +
            '      "url": "https://toledo.stage.sirono.com/paystaff/api/guarantors/157913/",' +
            '' +
            '      "full_name": "Ruth Fiser"' +
            '' +
            '   },' +
            '' +
            '   "services_by_description": {' +
            '' +
            '      "Clinic": {' +
            '' +
            '         "784005775": {' +
            '' +
            '            "code_description": "PED-INITIAL PREV NEW PT 1-4YRS",' +
            '' +
            '            "service_description": "Clinic",' +
            '' +
            '            "charge": -10400,' +
            '' +
            '            "code": "784005775",' +
            '' +
            '            "quantity": 1' +
            '' +
            '         }' +
            '' +
            '      }' +
            '' +
            '   },' +
            '"account_status":"Billed",' +
            '"account_sub_status":"Paid",' +
            '"paymentplan":"https://toledo.stage.sirono.com/paystaff/api/paymentplan/3133/"' +
            '' +
            '}';

        return json;
    }
}