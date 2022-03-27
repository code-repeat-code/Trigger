trigger ContactTrigger on Contact (before delete,before insert,before update,after delete,after insert,after update,after undelete) {
    ContactTriggerHandler triggerHandler = new ContactTriggerHandler();
    if(Trigger.isBefore){
        if(Trigger.isInsert && ContactTriggerHandler.isFirstTime){
            ContactTriggerHandler.isFirstTime = false;
            triggerHandler.beforeInsert(trigger.New);//It validates the seqeunce number field
            ContactTriggerHandler.isFirstTime = true;
        }
        if(Trigger.isUpdate  && ContactTriggerHandler.isFirstTime ){
            ContactTriggerHandler.isFirstTime = false;
            triggerHandler.beforeUpdate(trigger.new,trigger.old,trigger.oldMap,trigger.NewMap);
            ContactTriggerHandler.isFirstTime = true;
        }      
    }
    
    if(Trigger.isAfter){
        if(Trigger.isDelete  && ContactTriggerHandler.isFirstTime){
            ContactTriggerHandler.isFirstTime = false;
            triggerHandler.afterDelete(trigger.old);
            ContactTriggerHandler.isFirstTime = true;
        }
        if(Trigger.isUndelete && ContactTriggerHandler.isFirstTime){
            ContactTriggerHandler.isFirstTime = false;
            triggerHandler.afterUndelete(trigger.New);
            ContactTriggerHandler.isFirstTime = true;
        }
        
    }
   
}