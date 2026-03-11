trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after undelete ) {

switch on Trigger.operationType {
    when BEFORE_INSERT {
        For (Account account : Trigger.new) {
            If (account.type == null) {
                account.Type = 'Prospect';
            }
            if (
                account.ShippingStreet != null ||
                account.ShippingCity != null ||
                account.ShippingState != null ||
                account.ShippingPostalCode != null ||
                account.ShippingCountry != null
        ) {
                account.BillingStreet     = account.ShippingStreet;
                account.BillingCity       = account.ShippingCity;
                account.BillingState      = account.ShippingState;
                account.BillingPostalCode = account.ShippingPostalCode;
                account.BillingCountry    = account.ShippingCountry;
        }
            If (account.Phone != null && account.Fax != null && account.Website != null ) {
                account.rating= 'Hot';
            }
        }
    }

}
} 
