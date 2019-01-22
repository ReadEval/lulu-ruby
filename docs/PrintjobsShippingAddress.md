# Lulu::PrintjobsShippingAddress

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** |  | [optional] 
**organization** | **String** | Name of an organization. Required if no person name is given. | [optional] 
**street1** | **String** | First address line | 
**street2** | **String** | Second address line | [optional] 
**city** | **String** |  | 
**state_code** | **String** | 2 or 3 letter state codes (officially called [ISO-3166-2 subdivision codes](https://en.wikipedia.org/wiki/ISO_3166-2)). They are required for some countries (e.g. US, MX, CA, AU) | [optional] 
**country_code** | **String** | [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) country code | 
**postcode** | **String** | Required for most countries | 
**phone_number** | **String** | Shipping carriers require a phone number for handling delivery issues. If no phone number is given, the default default in the API user profile will be used. Validation Regex Pattern for phone numbers &#x60;^\\+?[\\d\\s\\-./()]{8,20}$&#x60;  | 
**email** | **String** | Shipping carriers require an email address for notifications or handling delivery issues. If no phone number is given, the default email in the user profile will be used.  | 
**is_business** | **BOOLEAN** | Only relevant for US addresses. Some US carriers don&#39;t deliver to business-addresses on Saturday. | [optional] [default to false]


