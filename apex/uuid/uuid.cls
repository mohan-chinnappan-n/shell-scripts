/* 
This code shows how to use Uuid from Jon uuid

 ref: https://github.com/jongpie/ApexUUID/blob/main/apex-uuid/classes/Uuid.cls
     https://github.com/jongpie/ApexUUID/blob/main/apex-uuid/classes/Uuid_Tests.cls
--------------------------------------------------------------------------

run:

sf mohanc tooling execute -u username -a uuid.cls

*/


String randomUuid = new Uuid().getValue(); 
// Prints the UUID string that was randomly generated
System.Debug(randomUuid);

// when you want to create a field value unique value 

Account acct = new Account();
acct.Name = randomUuid + '-Green';
Insert acct;
// acct.Name will be something like this: 4df36f32-1d10-46c6-8d0d-5c4fc595e437-Green


//----------- Avoid the following methods to create unique value --------------
// The accuracy depends on the underlying machine
// Clock skews in the machines may generate duplicates value when multiple machines are used in parallel
//-----------------------------------------------------------------------------

// ref: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_datetime.htm#apex_System_Datetime_millisecond

Long ctm = System.now().millisecond(); 
System.debug(ctm);

Account acct2 = new Account();
acct2.Name = ctm + '-Green';
Insert acct2;
// acct2.Name will be something like this: 868-Green 


//--------------------------------------------
Long ms = System.now().getTime(); 
System.debug(ms);

Account acct3 = new Account();
acct3.Name = ms + '-Green';
Insert acct3;
// acct3.Name will be something like this: 1708069329919-Green 




/* 
--------------------------------------------------------------------------
NOTE:
From Spring 24 release we have released UUID
--------------------------------------------------------------------------
*/

/*  Uncomment the following lines for Spring 24

UUID randomUuid = UUID.randomUUID(ctm);
// Prints the UUID string that was randomly generated
System.Debug(randomUuid);

*/

/* when you want to create a field value unique value 

Account acct = new Account();
acct.Name = randomUuid + '-Green';
Insert acct;

*/
