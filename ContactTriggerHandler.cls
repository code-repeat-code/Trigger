/*--------------------Final Trigger On Contact to maintain the sequence number  --------------------*/
public class ContactTriggerHandler {
    List<Contact> conList;//It holds the records on which we have to apply DML
    List<Contact> conListOld;//It holds the old records 
    Set<Contact> setContacts = new Set<Contact>();//It hold the Id's of the Account 
    List<Contact> conListNew = new List<Contact>();//It holds the records of new 
    List<Contact> conWithList;//It holds the records of particular account's contact record
    public static Boolean isFirstTime = true;
    public Map<Integer,Contact> conMap;
    Set<ID> conAcctsIdSet;//This set will hold the ID of Account which is related with the contact
    Set<Id> newConsIdsSet;
    List<Account> conWithAcctsList = new List<Account>();
    public map<Integer,Contact> newConMap;
    public map<Id,Integer> oldConMap;
    public boolean isSameAcct = false;
    /*=============================================BEFORE INSERT CASE ===========================================================*/
    public void beforeInsert(List<Contact> newConTrigger){
        //isFirstTime = false;
        conAcctsIdSet = new Set<Id>();
        for(Contact c : newConTrigger){
            //  System.debug('The c is ' + c);
            conAcctsIdSet.add(c.AccountId);
            
        }
        if(conAcctsIdSet.size()>0){
            conWithAcctsList = [Select Id,(Select Id,AccountId,Sequence_Number__c from Contacts Order By sequence_number__c ASC) from Account where Id IN:conAcctsIdSet];
            conList = new List<Contact>();
            for(Account accts: conWithAcctsList){
                conListOld = new List<Contact>();
                conWithList = new List<Contact>();
                conMap = new Map<Integer,Contact>();
                //conList.clear();
                for(Contact c : newConTrigger){
                    if(c.AccountId == accts.id){
                        conWithList.add(c);
                    }
                }                
                if(accts.contacts.size()>0){
                    for(Contact conRec : accts.contacts){
                        conMap.put((Integer)conRec.Sequence_Number__c,conRec);//fillig the with old values
                    }
                    System.debug('the old cons are ' + accts.contacts);
                    conListOld.addAll(accts.contacts);// 1 2 3      1 2 
                    System.debug('the conMap is 0'+conMap);
                    addRecords(conWithList,accts.id);
                    for(Contact c : conMap.values()){//now our Map is Updated with old and new values with specified and ordered sq no now extract only old contacts from the map to the list and update that list
                        if(conListOld.contains(c)){
                            conList.add(c);
                        }
                    }     
                }    
                else{
                    System.debug('Elsepart');
                    addRecords(conWithList,accts.id);
                }               
            }
            if(conList.size()>0){
                update conList;
            }
            
        } 
        
        
    }
    
    /*=====================================Filling the Map with new and Old values ============================================================*/
    public void addRecords(List<Contact> newContacts,Id accId){
        for(Contact c : newContacts){
            Integer val = (Integer)c.Sequence_Number__c;
            if(accId == c.AccountId && conMap.containsKey(val)){
                for(Integer i = conMap.size()+1;i>val;i--){
                    conMap.get(i-1).Sequence_Number__c = i; // Periodically shifting the seq of each rec by one from last upto current seq num
                    conMap.put(i,conMap.get(i-1));
                }
                conMap.put((Integer)c.Sequence_Number__c,c);
            }
            else{
                // c1-1  c2-2  c3-1   c4-2  c5-1 --->>  c1-1,c2-2 -- c3-1,c1-2,c2-3 --- c3-1,c4-2,c1-3,c2-4 -->>#   (c5-1,c3-2,c4-3,c1-4,c2-5)
                c.Sequence_Number__c = conMap.size()+1;//In starting the size of map is ZERO so initialize the first record by number 1 Bydefault
                conMap.put((Integer)c.Sequence_Number__c , c);//Put that rec in the map and size become 0+1(In first Step)
            }
            System.debug('The Map is ::' + conMap);
        }          
    } 
    
    
    
    
    /*=========================================================== AFTER DELETION CASE =======================================================================================*/
    public void afterDelete(List<Contact> deletedCon){//the record which is recently deleted by which trigger is fired
        //  isFirstTime = false;
        conAcctsIdSet = new Set<Id>();
        for(Contact c : deletedCon){
            conAcctsIdSet.add(c.AccountId);
        }
        System.debug('The Ids set is ' + conAcctsIdSet);
        if(conAcctsIdSet.size()>0){
            conWithAcctsList = [Select Id, (Select Id,AccountId, Sequence_Number__c from Contacts Order By sequence_number__c ASC) from Account where id in :conAcctsIdSet];//Master Accounts to which contacts are associated
            conList = new List<Contact>();
            
            for(Account acc : conWithAcctsList){
                System.debug('Acc is id' + acc.id);
                System.debug('AllSize' + acc.contacts.size());
                for(Contact conRec : acc.Contacts){
                    if(conRec.AccountId == acc.id){
                        conRec.Sequence_Number__c = 1;
                        conList.add(conRec);
                    }
                }
                deleteRecords(conList,acc.Id);   
            }    
        }        
    }    
    public void deleteRecords(List<Contact> cnList,Id accId){//cnList contains all the contacts associated with the current object
        conMap = new Map<Integer,Contact>();
        for(Contact cc : cnList){
            if(cc.AccountId == accId){
                //First fill the map with seq no contacts
                Integer val =(Integer)cc.sequence_Number__c;//fetching the first contact seq number into the val variable
                if(!conMap.containsKey(val)){
                    val = (Integer)cc.sequence_Number__c;
                    conMap.put(val,cc);
                }
                else{
                    while(conMap.containsKey(val)){
                        val++;
                    }
                    cc.sequence_Number__c = val;      
                    conMap.put((Integer)cc.sequence_Number__c,cc);
                }
            } 
        }
        if(conMap.values().size()>0){
            update conMap.values();
        }
    }
    /*============================================ AFTER UNDELETE CASE ==================================================*/
    public void afterUndelete(List<Contact> newConTrigger){
        //isFirstTime = false;
        conAcctsIdSet = new Set<Id>();
        for(Contact c : newConTrigger){
            conAcctsIdSet.add(c.AccountId);
        }
        if(conAcctsIdSet.size()>0){
            conWithAcctsList = [Select Id, (Select Id,AccountId,Sequence_Number__c from Contacts Order By sequence_number__c ASC) from Account where id in :conAcctsIdSet];
            conList = new List<Contact>();
            conWithList = new List<Contact>();
            conWithList = [select Id,sequence_number__c,AccountId from contact where AccountId IN : conAcctsIdSet AND ID IN :newConTrigger];
            for(Account accts : conWithAcctsList ){
                List<Contact> tempList = new List<Contact>();
                for(Contact c  : conWithList){
                    if(c.AccountId == accts.id){
                        tempList.add(c);
                    }
                }
                Integer size = accts.contacts.size() - tempList.size();
                for(Contact c : tempList){
                    c.Sequence_Number__c = size + 1;
                    size++;
                    conList.add(c);
                }  
            }     
        }   
        if(conList.size()>0){
            update conList;
        }
    }
    static public Map<Integer,Contact> conMapUpdate = new Map<Integer,Contact>();
    public Boolean isSame = false;
    public boolean isReparent = true;
    public List<Account> oldContactsList = new List<Account>();
    public Set<Id> oldIds;
    /*===============================================================AFTER TRIGGER================================================================================================*/
    public void beforeUpdate(List<Contact> conNewTrigger, List<Contact> tempOldList,Map<Id,Contact> oMap,Map<Id,Contact> nMap){ 
        for(Contact c : oMap.values()){
            System.debug('---------' + c.AccountID + '-----c.id-------' + c.id);
        }
        for(Contact c : nMap.values()){
            System.debug('New-------' + c.AccountId + '------CID----' + c.id);
        }
        List<Contact> newtriggerList = new List<Contact>();
        conAcctsIdSet = new Set<Id>();
        newConsIdsSet = new Set<Id>();
        oldIds = new Set<Id>();
        for(Contact c : conNewTrigger){
            conAcctsIdSet.add(c.AccountId);
        }
        for(Contact c : tempOldList){
            OldIds.add(c.AccountId);
        }
        if(!conAcctsIdSet.isEmpty()){
            conWithAcctsList = [Select Id, (Select Id,AccountId,Sequence_Number__c from Contacts Order By CreatedDate) from Account where id in :conAcctsIdSet Order BY Id];
            oldContactsList = [Select Id,(Select Id, AccountId, Sequence_Number__c from Contacts  Order By Sequence_Number__C ASC) from Account where id in :OldIds Order By Id];
            for(Account accts : conWithAcctsList){
                conWithList = new List<Contact>();
                oldConMap = new Map<Id,Integer>();
                for(Contact c : conNewTrigger){ //Store the new coming recordsList into the newTriggerList for the particular at a time
                    if(c.AccountId == accts.id){
                        newtriggerList.add(c);
                        conWithList.add(c); 
                        newConsIdsSet.add(c.id);
                    }
                }
                /*First fill the Map witht the old values before updated values*/
                for(Contact cc : accts.contacts){
                    oldConMap.put(cc.id,(Integer)cc.sequence_number__c);
                    conMapUpdate.put((Integer)cc.Sequence_Number__c,cc);
                }
                
                System.debug('The new Account Id ius L: ' + accts.id); 
                for(Account oldAcc : oldContactsList){   
                    if(oldAcc.id == accts.id){// acc1 acc2     acc1  acc2
                        isSame = true;
                        isReparent = false;
                        System.debug('Inside the if old part ----');
                        break;
                        
                    }
                    else{
                        if(isReparent){
                            isSame = false;
                            System.debug('---Inside the Else part ----');
                            addToLast(newtriggerList,accts.contacts);
                            reOrderPrevious(oldAcc.contacts,newConsIdsSet);//It will reOrder the sequence number of previous records
                            break;
                        }
                    }
                }
                //Now Map is filled with the old values Now iterate the updated contacts
                if(isSame){
                    updateRecords(conWithList,conMapUpdate,oldConMap);   
                }
                       
            }
            if(!conMapUpdate.values().isEmpty())
            update conMapUpdate.values();
            System.debug('updated called' + conMapUpdate);
        }
    }
    
    /*==================================== UPDATE RECORDS METHOD TO UPDATE ALL EXISTING RECORD AS PER THE UPDATED RECORDS ==========================*/
    public void updateRecords(List<Contact> conWithList,Map<Integer,Contact> cMap,Map<Id,Integer> oldConMap){  
        System.debug('****************************************************************');
        Set<Id> idsOfNewContacts = new Set<Id>();
        for(Contact c : conWithList){
            idsOfNewContacts.add(c.id);
            Integer updatedSeqNo = (Integer)c.Sequence_Number__c;
            Integer oldSeqNo = oldConMap.get(c.id);
            if(cMap.containskey(updatedSeqNo)){
                if(updatedSeqNo > oldSeqNo && updatedSeqNo <= cMap.size()){
                    for(Integer i = oldSeqNo;i<updatedSeqNo;i++){
                        System.debug('the seq no is ' + cMap.get(i).sequence_Number__C + 'AND con is ' + cMap.get(i).id);
                        cMap.get(i+1).sequence_number__C = i;
                        cMap.put(i,cMap.get(i+1));
                    }
                    cMap.put(updatedSeqNo,c);
                    for(contact keys : cMap.values()){
                        oldConMap.put(keys.id,(Integer)keys.Sequence_Number__c);
                    }
                }
                if(updatedSeqNo <= oldSeqNo && updatedSeqNo > 0){
                    for(Integer i = oldSeqNo;i > updatedSeqNo;i--){
                        cMap.get(i-1).sequence_number__C = i;
                        cMap.put(i,cMap.get(i-1));
                    }
                    cMap.put(updatedSeqNo,c);
                    for(contact keys : cMap.values()){
                        oldConMap.put(keys.id,(Integer)keys.Sequence_Number__c);
                    }
                }      
            }
            else{
                /**NULL NEGATIVE ZERO OUTOFBOUND CASE**/
                for(Integer i = oldSeqNo;i<cMap.size();i++){
                    cMap.get(i+1).Sequence_Number__c = i;
                    cMap.put(i,cMap.get(i+1));
                }
                c.sequence_number__C = cMap.size();
                cMap.put(cMap.size(),c);
                for(contact keys : cMap.values()){
                    oldConMap.put(keys.id,(Integer)keys.Sequence_Number__c);
                }
                
            }      
        }
        /*Separate the new values from the old values from the conMap by using old's Ids*/
        for(Id id : idsOfNewContacts){
            cMap.remove(oldConMap.get(id));
        }
    }  
    /*=============================================REPARENTING CASE METHODS================================================================*/ 
    public void reOrderPrevious(List<Contact> movedConsList,Set<Id> newConsId){
       // isFirstTime = false;
        conList = new List<Contact>();
        List<Contact> tempList = new List<Contact>();
        for(Contact c : movedConsList){//Removing the moved records from the list 
            if(!newConsId.contains(c.id)){
                tempList.add(c);
            }
        }
        Integer sqno = 0;
        for(Contact mcons : tempList){//Reassigning the sequence number for the old records
            mcons.sequence_Number__c = sqno + 1;
            conList.add(mcons);
            sqno++;
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }
    public void addToLast(List<Contact> recsTobeAppended,List<Contact> newAccConRecs){//It will add records to the last position when records parent is changed with other Account
        List<Contact> tempListofCons = new List<Contact>();
        System.debug('the size is s :: '  +  newAccConRecs.size());
        Integer size = newAccConRecs.size();
        System.debug('the siz ei s:: '  + size);
        for(Contact cc : recsTobeAppended){
            cc.Sequence_Number__c = size + 1;
            size++;
        }
        
    }  
}