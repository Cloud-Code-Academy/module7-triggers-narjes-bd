trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after undelete ) {
    switch on Trigger.operationType {
        
        when BEFORE_UPDATE {
            //Question 5 
            for (Opportunity opportunity : Trigger.new) {
                if (opportunity.Amount <=  5000) {
                    opportunity.addError('Opportunity amount must be greater than 5000');
                }
            }

            // Question 7 
            set<Id> accountIds = new Set<Id>();
            for (Opportunity opportunity : Trigger.new) {
                accountIds.add(opportunity.AccountId);
            }
            Map<Id,Contact> accountIdToCeoContact = new Map<Id,Contact>();

            for (contact con: [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO']) {
                accountIdToCeoContact.put(con.AccountId, con);
            }
            for (Opportunity opportunity : Trigger.new) {
                Contact ceo =accountIdToCeoContact.get(opportunity.AccountId);
                if (ceo != null) {
                    opportunity.Primary_Contact__c = ceo.Id;
                }
            }

        }

        // Question 6
        when BEFORE_DELETE {
            Set<Id> relatedAccountsId = new Set<Id>();
            for (Opportunity opp : Trigger.old) {
                    relatedAccountsId.add(opp.AccountId);
            }
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :relatedAccountsId]);

            for (Opportunity opp : Trigger.old) {
                Account acc= accountMap.get(opp.AccountId);
                if (opp.StageName == 'Closed Won' && acc.Industry == 'Banking')  {
                    opp.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
}
}
}
