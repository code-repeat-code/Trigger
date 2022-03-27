@isTest
    public class ContactTriggerHandlerTest {
        /*------------------Test SetUp method to create the test records for all methods ---------------------------------------*/
        static List<Contact> conList;
        @TestSetup static void setupData(){
            ContactTriggerHandler obj = new ContactTriggerHandler();
            conList = new List<Contact>();
            List<Account> accList = new List<Account>();
            accList.add(new Account(Name = 'testAcc1'));
            accList.add(new Account(Name = 'testAcc2'));
            accList.add(new Account(Name = 'Acc3'));
            accList.add(new Account(Name = 'Acc4'));
            insert accList;
            for(Integer i = 1;i<=10;i++){
                conList.add(new Contact(LastName = 'Con' + i,AccountID  = accList[0].id,Sequence_Number__c = i));
                conList.add(new Contact(LastName = 'Test' + i,AccountID =accList[1].id,sequence_number__c = i ));
            } 
            insert conList;
            
            //Create a Account Which has No records 
           
        }
        /*-----------WHEN Database is Empty And No sequence_Number is given at Insertion time ---------------------*/
        @isTest static void testbeforeInsert1(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            /*Input the Records When Database is Empty and No sequence Number is Given to the inserting records*/
            for(Integer i = 1;i<=5;i++){
                conList.add(new Contact(LastName = 'EmptyFirstCase' + i,AccountID = accList1[2].id));
                conList.add(new Contact(LastName = 'ForAcc4' + i,AccountID = accList1[3].id));
            }
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[2].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[3].id];
            System.assertEquals(1,tempList1[0].sequence_number__c);//For Account Acc2 The seq num at the first position
            System.assertEquals(3, tempList2[2].sequence_number__c);//For Account Acc3 the Seq No 
            
            
        }
        /*-------------------------When Database is Empty and Seqeunce Number is given at the time of Insertion -------------------------*/
        @isTest static void testbeforeInsert2(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            for(Integer i = 1;i<=5;i++){
                conList.add(new Contact(LastName = 'EmptyFirstCase' + i,AccountID = accList1[2].id,sequence_Number__c = i));
                conList.add(new Contact(LastName = 'ForAcc4' + i,AccountID = accList1[3].id,sequence_Number__c = i));
            }
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[2].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[3].id];
            System.assertEquals(4,tempList1[3].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(5, tempList2[4].sequence_number__c);//For Account Acc3 the Seq No 
            
        }
         /*-------------------------When Database is Empty and  Negative Seqeunce Number is given at the time of Insertion -------------------------*/
        @isTest static void testbeforeInsert3(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            for(Integer i = 1;i<=5;i++){
                conList.add(new Contact(LastName = 'EmptyFirstCase' + i,AccountID = accList1[2].id,sequence_Number__c = -1));
                conList.add(new Contact(LastName = 'ForAcc4' + i,AccountID = accList1[3].id,sequence_Number__c = -1));
            }
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[2].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[3].id];
            System.assertEquals(1,tempList1[0].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(1, tempList2[0].sequence_number__c);//For Account Acc3 the Seq No 
            
        }
          /*-------------------------When Database is Empty and  Seqeunce Number is given in Descending Order at the time of Insertion -------------------------*/
        @isTest static void testbeforeInsert4(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            for(Integer i = 10;i>=1;i--){
                conList.add(new Contact(LastName = 'EmptyFirstCase' + i,AccountID = accList1[2].id,sequence_Number__c = i));
                conList.add(new Contact(LastName = 'ForAcc4' + i,AccountID = accList1[3].id,sequence_Number__c = i));
            }
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[2].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[3].id];
            System.assertEquals(2,tempList1[0].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(10, tempList2[4].sequence_number__c);//For Account Acc3 the Seq No    
        }
          /*-------------------------When Database is Empty and Random Seqeunce Number is given at the time of Insertion -------------------------*/
        @isTest static void testbeforeInsert5(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            conList.add(new Contact(LastName = 'EmptyFirstCase1',AccountID = accList1[2].id,sequence_Number__c = 12));
            conList.add(new Contact(LastName = 'ForAcc41',AccountID = accList1[3].id,sequence_Number__c = 10));
            conList.add(new Contact(LastName = 'EmptyFirstCase2',AccountID = accList1[2].id,sequence_Number__c = 3));
            conList.add(new Contact(LastName = 'ForAcc42',AccountID = accList1[3].id,sequence_Number__c = 9));
            conList.add(new Contact(LastName = 'EmptyFirstCase3',AccountID = accList1[2].id,sequence_Number__c = 5));
            conList.add(new Contact(LastName = 'ForAcc43',AccountID = accList1[3].id,sequence_Number__c = 28));
            conList.add(new Contact(LastName = 'EmptyFirstCase4',AccountID = accList1[2].id,sequence_Number__c = 1));
            conList.add(new Contact(LastName = 'ForAcc44',AccountID = accList1[3].id,sequence_Number__c = 1));
            conList.add(new Contact(LastName = 'EmptyFirstCase5',AccountID = accList1[2].id,sequence_Number__c = 1));
            conList.add(new Contact(LastName = 'ForAcc45',AccountID = accList1[3].id,sequence_Number__c = 7));
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[2].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[3].id]; 
            System.assertEquals(5,tempList1[2].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(1, tempList2[3].sequence_number__c);//For Account Acc3 Seq No    
        }
         /*-------------------------When Database is Empty and 0 Seqeunce Number is given at the time of Insertion -------------------------*/
        @isTest static void testbeforeInsert6(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            for(Integer i = 1;i<=10;i++){
                conList.add(new Contact(LastName = 'EmptyFirstCase' + i,AccountID = accList1[2].id,sequence_Number__c = 0));
                conList.add(new Contact(LastName = 'ForAcc4' + i,AccountID = accList1[3].id,sequence_Number__c = 0));
            }
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[2].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[3].id]; 
            System.assertEquals(5,tempList1[4].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(9, tempList2[8].sequence_number__c);//For Account Acc3 Seq No    
        } 
        /*-------------------------When Database has Records before and a Sequence number is inserted into the middle position ------------------------*/
        @isTest static void testbeforeInsert7(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            conList.add(new Contact(LastName = 'ContTest' ,AccountID = accList1[0].id,sequence_Number__c = 1));
            conList.add(new Contact(LastName = 'ConAcctest' ,AccountID = accList1[1].id,sequence_Number__c = 9));
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id]; 
            System.assertEquals(2,tempList1[0].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(11, tempList2[9].sequence_number__c);//For Account Acc3 Seq No    
        }   
        /*-------------------------When Database has Records before and Negative and IOut Of Bound  Sequence number is inserted into the first position ------------------------*/
        @isTest static void testbeforeInsert8(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            conList.add(new Contact(LastName = 'ContTest' ,AccountID = accList1[0].id,sequence_Number__c = -1));
            conList.add(new Contact(LastName = 'ConAcctest' ,AccountID = accList1[1].id,sequence_Number__c = 123));
            test.startTest();
            insert conList;
            test.stopTest();
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id];
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id]; 
            System.assertEquals(11,tempList1[10].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(11, tempList2[10].sequence_number__c);//For Account Acc3 Seq No    
        }  
        
        /*====================================== DELETION TEST CASES ==================================================================*/
        
        
        /*------------------------- When the first record is deletd from  both the accounts ------------------------*/
        @isTest static void testAfterDelete1(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            Delete [Select Id from Contact where AccountID = :accList1[0].id AND Sequence_Number__C = 1];
            Delete [Select Id from Contact where AccountID = :accList1[1].id AND Sequence_Number__C = 1];
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id ];// 1 2 3 ...10
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id ];// 1 2 3 ...10
            System.assertEquals(1,tempList1[0].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(1, tempList2[0].sequence_number__c);//For Account Acc3 Seq No    
        
        } 
        /*------------------------- When the Random record is Deleted of the Contact ------------------------*/
        @isTest static void testAfterDelete2(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            //Delete the elements from any random index from the contact's records list
            Delete [Select Id from Contact where AccountID = :accList1[0].id AND Sequence_Number__C = 4];
            Delete [Select Id from Contact where AccountID = :accList1[1].id AND Sequence_Number__C = 5];
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id];// 1 2 3 ...10
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id];// 1 2 3 ...10
            System.assertEquals(4,tempList1[3].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(5, tempList2[4].sequence_number__c);//For Account Acc3 Seq No    
        
        } 
        /*------------------------- When more than one record is deleted at a time  ------------------------*/
        @isTest static void testAfterDelete3(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            //Delete the elements from any random index from the contact's records list
            Delete [Select Id from Contact where AccountID = :accList1[0].id AND Sequence_Number__C <= 7];
            Delete [Select Id from Contact where AccountID = :accList1[1].id AND Sequence_Number__C <= 8];
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id];// 1 2 3 ...10
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id];// 1 2 3 ...10
            System.assertEquals(3,tempList1[2].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(2, tempList2[tempList2.size()-1].sequence_number__c);//For Account Acc3 Seq No    
        
        } 
        /*====================================== UNDELETE TEST CASES ==================================================================*/
       
        /*------------------------------When two records are undelted for both the accounts -------------------------------------------*/
        @isTest static void testAfterUndelete1(){
            test.startTest();
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            //First Delete the Records then undelete them to cross verify
            Contact con1 = [Select Id from Contact where AccountID = :accList1[0].id AND Sequence_Number__C = 1];
            Delete con1;
            Contact con2 = [Select Id from Contact where AccountID = :accList1[1].id AND Sequence_Number__C = 1];
            Delete con2;
            List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id];// 1 2 3 ...10
            List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id];// 1 2 3 ...10
            System.assertEquals(9,tempList1[tempList1.size()-1].sequence_number__c);//For Account Acc2 The seq num 
            System.assertEquals(9, tempList2[tempList2.size()-1].sequence_number__c);//For Account Acc3 Seq No    
            undelete con1;
            undelete con2;
            /*Now again use assertion after undelete the both seq nos*/
            List<Contact> tempList11 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id Order By Sequence_Number__c];// 1 2 3 ...10
            List<Contact> tempList22 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id Order By Sequence_Number__c];// 1 2 3 ...10
            
            System.assertEquals(10, tempList11[tempList11.size()-1].sequence_number__c);
            System.assertEquals(10, tempList22[tempList22.size()-1].sequence_number__c);
            test.stopTest();    
        
        } 
     /*------------------------------When more than two records are Undeleted at a time -------------------------------------------*/
     @isTest static void testAfterUndelete2(){
        test.startTest();
        List<Account> accList1 = [Select Id from Account];
        conList = new List<Contact>();
        //First Delete the Records then undelete them to cross verify
        List<Contact> con1 = [Select Id from Contact where AccountID = :accList1[0].id AND Sequence_Number__C >= 4];
        Delete con1;
        List<Contact> con2 = [Select Id from Contact where AccountID = :accList1[1].id AND Sequence_Number__C <= 2];
        Delete con2;
        List<Contact> tempList1 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id];// 1 2 3 ...10
        List<Contact> tempList2 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id];// 1 2 3 ...10
        System.assertEquals(1,tempList1[0].sequence_number__c);//For Account Acc2 The seq num 
        System.assertEquals(8, tempList2[tempList2.size()-1].sequence_number__c);//For Account Acc3 Seq No    
        undelete con1;
        undelete con2;
        /*Now again use assertion after undelete the both seq nos*/
        List<Contact> tempList11 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[0].id Order By Sequence_Number__c];// 1 2 3 ...10
        List<Contact> tempList22 = [Select Id,LastName,Sequence_Number__c from Contact where AccountId = :accList1[1].id Order By Sequence_Number__c];// 1 2 3 ...10
        
        System.assertEquals(10, tempList11[tempList11.size()-1].sequence_number__c);
        System.assertEquals(10, tempList22[tempList22.size()-1].sequence_number__c);
        test.stopTest();    
    
    } 
         /*====================================== UPDATION TEST CASES ==================================================================*/
       
       
         /*------------------------------When one record is updated for two accounts-------------------------------------------*/
        @isTest static void testBeforeUpdate1(){
            List<Account> accList1 = [Select Id from Account];
            List<Contact> con1 = [Select Id,Sequence_Number__c from Contact where (AccountId = :accList1[0].id OR AccountId = :accList1[1].id) ORDER BY Sequence_number__C limit 2];// 1 2 3 ...10
            System.assertEquals(1, con1[0].sequence_number__C);//fetch Id of this contact 
            Id conId1 = con1[0].id;
            System.assertEquals(1, con1[1].sequence_number__C);
            Id conId2 = con1[1].id;
            for(Contact c : con1){
                c.sequence_number__c = 8;
            }
            update con1;
            List<Contact> conList =  [Select Id,Sequence_number__c from Contact where Id = :conId1 OR Id = :conId2];
            System.assertEquals(8, conList[0].sequence_number__c);
            System.assertEquals(8, conList[1].sequence_number__C);
           
        } 
        
        /*------------------------------When Multiple records are updated for two accounts-------------------------------------------*/
        @isTest static void testBeforeUpdate2(){
            List<Account> accList1 = [Select Id from Account];
            List<Contact> con1 = [Select Id,Sequence_Number__c from Contact where (AccountId = :accList1[0].id OR AccountId = :accList1[1].id) Order By Sequence_number__C];// 1 2 3 ...10
            System.assertEquals(10, con1[con1.size()-1].sequence_number__C);
            System.assertEquals(10, con1[con1.size()-1].sequence_number__C);
            for(Contact c : con1){
                c.sequence_number__c = 1;
            }
            update con1;
            List<Contact> conList = [Select Id,Sequence_Number__c from Contact where (AccountId = :accList1[0].id OR AccountId = :accList1[1].id) ];// 1
            System.assertEquals(1, con1[con1.size()-1].sequence_number__C);
            System.assertEquals(1, con1[con1.size()-1].sequence_number__C);
            
        } 
    
        
         /*------------------------------When Updated Seq no is Smaller than Old Seq No-------------------------------------------*/
        @isTest static void testBeforeUpdate3(){
            List<Account> accList1 = [Select Id from Account];
            List<Contact> con1 = [Select Id,Sequence_Number__c from Contact where (AccountId = :accList1[0].id OR AccountId = :accList1[1].id) ORDER BY Sequence_number__C  DESC limit 2];// 1 2 3 ...10
            System.assertEquals(10, con1[0].sequence_number__C);//fetch Id of this contact 
            Id conId1 = con1[0].id;
            System.assertEquals(10, con1[1].sequence_number__C);
            Id conId2 = con1[1].id;
            for(Contact c : con1){
                c.sequence_number__c = 1;
            }
            update con1;
            List<Contact> conList =  [Select Id,Sequence_number__c from Contact where Id = :conId1 OR Id = :conId2];
            System.assertEquals(1, conList[0].sequence_number__c);
            System.assertEquals(1, conList[1].sequence_number__C);
           
        } 
          /*------------------------------When Updated Seq no Null Negative Or Out Of Bound -------------------------------------------*/
        @isTest static void testBeforeUpdate4(){
            List<Account> accList1 = [Select Id from Account];
            List<Contact> con1 = [Select Id,Sequence_Number__c from Contact where (AccountId = :accList1[0].id OR AccountId = :accList1[1].id) ORDER BY Sequence_number__C  limit 2];// 1 2 3 ...10
            System.assertEquals(1, con1[0].sequence_number__C);//fetch Id of this contact 
            Id conId1 = con1[0].id;
            System.assertEquals(1, con1[1].sequence_number__C);
            Id conId2 = con1[1].id;
            for(Contact c : con1){
                c.sequence_number__c = -1;
            }
            update con1;
            List<Contact> conList =  [Select Id,Sequence_number__c from Contact where Id = :conId1 OR Id = :conId2];
            System.assertEquals(10, conList[0].sequence_number__c);
            System.assertEquals(10, conList[1].sequence_number__C);
           
        }
         /*------------------------------   Reparenting Case  -------------------------------------------*/
        @isTest static void testBeforeUpdateReparent1(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            //Contacts of First Account 
            conList = [Select Id,Sequence_Number__C from Contact where AccountId = :accList1[0].id];
            System.assertEquals(10,conList.size());
            for(Contact c : conList){
                c.AccountId = accList1[1].id;
            }
            update conList;
            conList = [Select Id from Contact where AccountId = :accList1[1].id];
            System.assertEquals(20, conList.size());
        }
        
          /*------------------------------   Reparenting Case  2  -------------------------------------------*/
        @isTest static void testBeforeUpdateReparent2(){
            List<Account> accList1 = [Select Id from Account];
            conList = new List<Contact>();
            //Contacts of First Account 
            conList = [Select Id,Sequence_Number__C from Contact where (AccountId = :accList1[0].id) Order By Sequence_Number__C limit 1]; 
            System.assertEquals(1,conList[0].sequence_number__C);
            for(Contact c : conList){
                c.AccountId = accList1[1].id;
            }
            update conList;
            conList = [Select Id,sequence_number__C from Contact where AccountId = :accList1[0].id Order BY Sequence_Number__c];
            System.assertEquals(1, conList[0].sequence_number__C);
            conList = [Select Id,sequence_number__C from Contact where AccountId = :accList1[1].id Order BY Sequence_Number__c DESC limit 1];
            System.assertEquals(11, conList[0].sequence_number__C);
        }
        
        
    }