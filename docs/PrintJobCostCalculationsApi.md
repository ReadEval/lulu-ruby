# Lulu::PrintJobCostCalculationsApi

All URIs are relative to *https://api.lulu.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**print_job_cost_calculations_create**](PrintJobCostCalculationsApi.md#print_job_cost_calculations_create) | **POST** /print-job-cost-calculations/ | Create a Print-Job cost calculation


# **print_job_cost_calculations_create**
> InlineResponse201 print_job_cost_calculations_create(opts)

Create a Print-Job cost calculation

This endpoint allows you to calculate product and shipping cost without creating a Print-Job. This is typically used in an offer or checkout situation. The address is required to calculate sales tax / VAT and shipping cost. 

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobCostCalculationsApi.new
opts = {
  inline_object: Lulu::InlineObject.new # InlineObject | 
}

begin
  #Create a Print-Job cost calculation
  result = api_instance.print_job_cost_calculations_create(opts)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobCostCalculationsApi->print_job_cost_calculations_create: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inline_object** | [**InlineObject**](InlineObject.md)|  | [optional] 

### Return type

[**InlineResponse201**](InlineResponse201.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



