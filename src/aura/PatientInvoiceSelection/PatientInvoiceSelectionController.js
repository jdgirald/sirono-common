({
	doInit: function(component, event, helper) {
        var invoiceId = component.get('v.invoiceId');
		var isEstimate = component.get('v.isEstimateType');
		if (invoiceId == null) {
			helper.init(component);
		} else if(!isEstimate) {
            var filtes = component.find('filtes');
            $A.util.toggleClass(filtes, 'slds-hide');
			helper.getInvoice(component, invoiceId);
		}else{
			var sort = component.find('sort');
            $A.util.toggleClass(sort, 'slds-hide');
			helper.getEstimate(component, invoiceId);
		}
    },
    selectAllInvoices : function(component, event, helper) {
		console.log('SELECT ALL INVOICES');
        var areAllInvoicesSelected = component.get('v.AreAllInvoicesSelected');
        $A.get("e.c:SelectInvoicesEvent").setParams({"SelectAll" : !areAllInvoicesSelected}).fire();
        component.set('v.AreAllInvoicesSelected', !areAllInvoicesSelected);
    },

    refreshAllInvoicesSelected : function(component, event, helper) {
        console.log('Refresh All Invoices Selected');
		var areAllinvoicesSelected = true;
        component.get('v.invoices').forEach(function(item, i, arr) {
            areAllinvoicesSelected = areAllinvoicesSelected && item.get('v.activated');
        });
        component.set('v.AreAllInvoicesSelected', areAllinvoicesSelected);
    },

    filterInvoices : function(component, event, helper) {
        if(event.target.id){
            component.set('v.groupFilter', event.target.id);
            helper.getAllInvoices(component);
        }

    },

	checkSize  : function(component, event, helper){
		console.log('Size', component.get('v.invoices').length);
	},

	reInitData : function(component, event, helper){
		
		var activeTab = event.getParam('tabName');
		component.set('v.selectedTab', activeTab);
		var invoiceId = component.get('v.invoiceId');
		var isEstimate = event.getParam('isEstimateType');
		component.set('v.isEstimateType', isEstimate)
		if (invoiceId == null || activeTab == 'CreatePaymentPlan') {
			helper.getAllInvoices(component);
		} else if(!isEstimate) {
            var filtes = component.find('filtes');
            $A.util.addClass(filtes, 'slds-hide');
			helper.getInvoice(component, invoiceId);
		}else{
			var sort = component.find('sort');
            $A.util.addClass(sort, 'slds-hide');
			helper.getEstimate(component, invoiceId);
		}
	},
	patientsVisibility : function(component, Event, helper) {
		var blockSelect = component.find('patientList');
		$A.util.toggleClass(blockSelect, 'slds-is-open');
	},
	patientSelect : function(component, event, helper) {
		$A.util.toggleClass(event.currentTarget, 'slds-is-selected');
		var patientId = event.currentTarget.dataset.patientId;
		var patientSetOld = component.get('v.patientSet');
		var patientLabel = '';
		var selectCounter = 0;
		for(var i = 0; i < patientSetOld.length; i++) {		
			if(patientSetOld[i].id == patientId) {
				patientSetOld[i].isSelected = $A.util.hasClass(event.currentTarget, 'slds-is-selected');
			}	
			if(patientSetOld[i].isSelected) {
				selectCounter += 1;
				patientLabel += patientSetOld[i].name + ", ";
			}
		}
		patientLabel = patientLabel.substring(0, patientLabel.length - 2);
		if(selectCounter != patientSetOld.length) {
			if(selectCounter == 0) {
				component.set('v.patientLabel', 'Not Selected');
			} else {
				component.set('v.patientLabel', patientLabel);
			}
		} else {
			component.set('v.patientLabel', 'All Patients');
		}

		helper.getAllInvoices(component);
	}

})