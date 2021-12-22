@RestResource(urlMapping='/Contacts/*')
global with sharing class IntegrationContact {
    
    @HttpGet
    global static Contact getContacts() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact result =  [SELECT Id,Name,Email FROM Contact WHERE Id = :contactId];               
        return result;
    }

    @HttpPost
    global static ID createContact(String lastName,String firstName,String email,String phone){
        // Email Verification
        List<Contact> contacts =[SELECT Id FROM Contact WHERE Email=:email];
        // If already exist, return Id of this contact
        if(contacts.size()!=0){
            return contacts[0].Id;
        // Else, creation of a new one
        }else{
            Contact thisContact = new Contact();
            thisContact.LastName = lastName;
            thisContact.FirstName = firstName;
            thisContact.Email = email;
            thisContact.Phone = phone;
            
            insert thisContact;
            return thisContact.Id;
        }
    }

    @HttpDelete
    global static void deleteContact(){
        RestRequest request = restContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id,Active__c FROM Contact WHERE Id=:contactId];
        // Don't delete It, just deactivated It
        thisContact.Active__c = false;
        update thisContact;
    }

    @HttpPatch
    global static Contact updateContact(){
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id=:contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestbody.toString());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()){
        // Set the field and value on the Contact sObject
            thisContact.put(fieldName,params.get(fieldName));
        }
        update thisContact;
        return thisContact;
    }

}