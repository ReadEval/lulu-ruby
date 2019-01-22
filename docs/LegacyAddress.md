# Lulu::LegacyAddress

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** |  | [optional] 
**name** | **String** | Full name of the person, including first and last name. | [optional] 
**organization** | **String** | Name of an organization. Required if no person name is given. | [optional] 
**street1** | **String** | First address line | 
**street2** | **String** | Second address line | [optional] 
**city** | **String** |  | 
**state_code** | **String** | 2 or 3 letter state codes (officially called [ISO-3166-2 subdivision codes](https://en.wikipedia.org/wiki/ISO_3166-2)). They are required for some countries (e.g. US, MX, CA, AU) | [optional] 
**country_code** | **String** | [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) country code | 
**postcode** | **String** | Required for most countries | 
**phone_number** | **String** | Validation Regex Pattern: &#x60;^\\+?[\\d\\s\\-./()]{8,20}$&#x60;  | [optional] 
**email** | **String** |  | [optional] 
**is_business** | **BOOLEAN** | Only relevant for US addresses. Some US carriers don&#39;t deliver to business-addresses on Saturday. | [optional] [default to false]


