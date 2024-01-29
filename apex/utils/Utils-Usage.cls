Account newAccount = new Account(Name='New Account');
Utils.createRecord(newAccount);

Opportunity newOpportunity = new Opportunity(Name='New Opportunity', StageName='Prospecting', CloseDate=Date.today() + 30);
Utils.insertRecord(newOpportunity);
