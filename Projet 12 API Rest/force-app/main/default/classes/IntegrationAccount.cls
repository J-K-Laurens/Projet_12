@RestResource(urlMapping='/Accounts/*')
global with sharing class IntegrationAccount {
    
    @HttpGet
    global static Account getAccounts() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account result =  [SELECT Id,Name,Website FROM Account WHERE Id = :accountId];               
        return result;
    }

    @HttpPost
    global static ID createAccount(String name,String website, Double externalId){
        // Email Verification
        
            Account thisAccount = new Account();
            thisAccount.name = name;
            thisAccount.Website = Website;
            thisAccount.External_ID__c = externalId;
            
            insert thisAccount;
            return thisAccount.Id;
        
    }

    @HttpPatch
    global static Account updateAccount(){
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id=:accountId];
        // Deserialize the JSON string into name-value pairs
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestbody.toString());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()){
        // Set the field and value on the Account sObject
            thisAccount.put(fieldName,params.get(fieldName));
        }
        update thisAccount;
        return thisAccount;
    }

}