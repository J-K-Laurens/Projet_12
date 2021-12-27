@RestResource(urlMapping='/Contracts/*')
global with sharing class IntegrationContract {

    @HttpPost
    global static Id createContract(String accountId, String status,Integer contractTerm) {
        Contract thisContract = new Contract(AccountId=accountId,Status=status,ContractTerm=contractTerm);
        insert thisContract;
        //Return Contract ID
        return thisContract.Id;
    }

    @HttpPatch
    global static Contract updateContract(){
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        Contract thisContract = [SELECT FIELDS(STANDARD) FROM Contract WHERE Id=:contractId LIMIT 1];
        // Deserialize the JSON string into name-value pairs
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestbody.toString());
        // Set the field and value on the Contact sObject
        for(String fieldName : params.keySet()){
            thisContract.put(fieldName,params.get(fieldName));
        }
        update thisContract;
        return thisContract;
    }

    
}