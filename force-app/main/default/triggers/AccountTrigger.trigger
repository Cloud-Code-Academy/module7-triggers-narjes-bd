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
    when AFTER_INSERT {
        List <Contact> defaultContactsToInsert =new List<Contact>();
        For (Account account : Trigger.new) {
            Contact defaultContact = new Contact();
            defaultContact.LastName = 'DefaultContact';
            defaultContact.AccountId = account.Id;
            defaultContact.Email= 'default@email.com';
            DefaultContactsToInsert.add(defaultContact);
            }
        insert defaultContactsToInsert;

    }

} 
} 
