trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after undelete ) {

switch on Trigger.operationType {
    when BEFORE_INSERT {
        For (Account account : Trigger.new) {
            If (account.type == null) {
                account.Type = 'Prospect';
            }
        }
    }
    
}
} 
