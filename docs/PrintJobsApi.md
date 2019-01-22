# Lulu::PrintJobsApi

All URIs are relative to *https://api.lulu.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**print_jobs_costs**](PrintJobsApi.md#print_jobs_costs) | **GET** /print-jobs/{id}/costs/ | Retrieve Print-Job Costs
[**print_jobs_create**](PrintJobsApi.md#print_jobs_create) | **POST** /print-jobs/ | Create a new Print-Job
[**print_jobs_list**](PrintJobsApi.md#print_jobs_list) | **GET** /print-jobs/ | Retrieve a list of Print-Jobs
[**print_jobs_read**](PrintJobsApi.md#print_jobs_read) | **GET** /print-jobs/{id}/ | Retrieve a single Print-Job
[**print_jobs_statistics**](PrintJobsApi.md#print_jobs_statistics) | **GET** /print-jobs/statistics/ | Retrieve the number of Print-Jobs in each status
[**print_jobs_status_read**](PrintJobsApi.md#print_jobs_status_read) | **GET** /print-jobs/{id}/status/ | Retrieve Print-Job Status


# **print_jobs_costs**
> InlineResponse2001 print_jobs_costs(id)

Retrieve Print-Job Costs

Sub-resource to retrieve only the costs of a Print-Job

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobsApi.new
id = 'id_example' # String | Id of the resource

begin
  #Retrieve Print-Job Costs
  result = api_instance.print_jobs_costs(id)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobsApi->print_jobs_costs: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the resource | 

### Return type

[**InlineResponse2001**](InlineResponse2001.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **print_jobs_create**
> InlineResponse2011 print_jobs_create(opts)

Create a new Print-Job

Print-Jobs are the core resource of the Print API. A Printjob consists of line items, shipping information and some additional metadata.  ## Elements of a Print-Job ### Line Items A line item represents a book that should be printed or in short a **printable**. Printables consist of cover and interior files as well as a `pod_package_id`. The `pod_package_id` represents the manufacturing options; see the [\"Select a product\"](#section/Select-a-Product) section for details. Each printable can be identified by an immutable `printable_id`. The `printable_id` can be used for re-orders so that the files don't have to be transferred again.  ### Shipping Information & Metadata Print-Jobs have to contain a `shipping_address` as well as a `shipping_level`. Lulu offers five different service levels that differ in speed and traceability.  ### Additional Metadata A few additional metadata fields can be specified in the Print-Job as well: * `contact_email` for questions related to the Print-Job itself * `production_delay` allows you to specify a delay (between 60 minutes and a full day) before the Print-Job goes to production. * `external_id` allows you to link the Print-Job to an internal order number or other reference.  ## File Handling and Normalization Interior and cover files have to be specified with a URL from which Lulu can download the files. Using encoded [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication#URL_encoding) in the URL is ok. All files processed by Lulu will be validated and normalized before sending them to production. If problems with the file occur, the PrintJob will be rejected or cancelled and an error message will be displayed.  ## Automation and Payment After a Print-Job has been created successfully, it will remain in an `UNPAID` state until it is paid for through the developer portal. However, you can automate the process by putting a credit card on file. Then, the Print-Job will automatically transition to the `PRODUCTION_DELAY` status and your card will charged when the Print-Job is sent to production. 

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobsApi.new
opts = {
  inline_object1: Lulu::InlineObject1.new # InlineObject1 | 
}

begin
  #Create a new Print-Job
  result = api_instance.print_jobs_create(opts)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobsApi->print_jobs_create: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inline_object1** | [**InlineObject1**](InlineObject1.md)|  | [optional] 

### Return type

[**InlineResponse2011**](InlineResponse2011.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **print_jobs_list**
> Object print_jobs_list(opts)

Retrieve a list of Print-Jobs

Use this request to show a list of Print-Jobs. The list is paginated and can be filtered by various attributes that are given as query parameters.  Timestamps like `created_after`, `created_before`, `modified_after`, and `modified_before` can be entered as [ISO8601 datetime strings](https://www.w3.org/TR/NOTE-datetime). Internally, the Lulu API uses [Coordinated Universal Time (UTC)](https://en.wikipedia.org/wiki/Coordinated_Universal_Time). The following formats are valid:  * `2017-11-09` (date only)  * `2017-11-09T09:30` (datetime with minute precision)  * `2017-11-09T09:30:08` (datetime with second precision)  * `2017-11-09T09:30:08Z` (UTC datetime)  * `2017-11-09T09:30:08+06:00` (datetime with offset)  To filter Print-Jobs by status you can use any valid status string (`CREATED`, `REJECTED`, `UNPAID`, `PAYMENT_IN_PROGRESS`, `PRODUCTION_READY`, `PRODUCTION_DELAYED`, `IN_PRODUCTION`, `ERROR`, `SHIPPED`, `CANCELED`). `PAYMENT_IN_PROGRESS` and `PRODUCTION_READY` are rather short-lived states that exist only for a few minutes at max; filtering by these status will rarely yield any results. 

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobsApi.new
opts = {
  page: 56, # Integer | Result page, default: 1
  page_size: 56, # Integer | The default is 100.
  created_after: 'created_after_example', # String | Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  created_before: 'created_before_example', # String | Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  modified_after: 'modified_after_example', # String | Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  modified_before: 'modified_before_example', # String | Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  id: 'id_example', # String | Filter by id
  order_id: 'order_id_example', # String | Filter by order_id
  exclude_line_items: true, # BOOLEAN | Leave the list of line_items out of the Print-Jobs in the response.
  search: 'search_example', # String | Search across the fields 'id', 'external_id', 'order_id', 'status', 'line_item_id', 'line_item_external_id', 'line_item_title', 'line_item_tracking_id' and 'shipping_address'
  ordering: 'ordering_example' # String | Which field to use when ordering the results.
}

begin
  #Retrieve a list of Print-Jobs
  result = api_instance.print_jobs_list(opts)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobsApi->print_jobs_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| Result page, default: 1 | [optional] 
 **page_size** | **Integer**| The default is 100. | [optional] 
 **created_after** | **String**| Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **created_before** | **String**| Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **modified_after** | **String**| Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **modified_before** | **String**| Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **id** | **String**| Filter by id | [optional] 
 **order_id** | **String**| Filter by order_id | [optional] 
 **exclude_line_items** | **BOOLEAN**| Leave the list of line_items out of the Print-Jobs in the response. | [optional] 
 **search** | **String**| Search across the fields &#39;id&#39;, &#39;external_id&#39;, &#39;order_id&#39;, &#39;status&#39;, &#39;line_item_id&#39;, &#39;line_item_external_id&#39;, &#39;line_item_title&#39;, &#39;line_item_tracking_id&#39; and &#39;shipping_address&#39; | [optional] 
 **ordering** | **String**| Which field to use when ordering the results. | [optional] 

### Return type

**Object**

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **print_jobs_read**
> InlineResponse200 print_jobs_read(id)

Retrieve a single Print-Job

Retrieve a single Print-Job by id.

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobsApi.new
id = 'id_example' # String | Id of the resource

begin
  #Retrieve a single Print-Job
  result = api_instance.print_jobs_read(id)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobsApi->print_jobs_read: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the resource | 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **print_jobs_statistics**
> Object print_jobs_statistics(opts)

Retrieve the number of Print-Jobs in each status

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobsApi.new
opts = {
  page: 56, # Integer | Result page, default: 1
  page_size: 56, # Integer | The default is 100.
  created_after: 'created_after_example', # String | Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  created_before: 'created_before_example', # String | Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  modified_after: 'modified_after_example', # String | Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  modified_before: 'modified_before_example', # String | Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
  id: 'id_example', # String | Filter by id
  ordering: 'ordering_example' # String | Which field to use when ordering the results.
}

begin
  #Retrieve the number of Print-Jobs in each status
  result = api_instance.print_jobs_statistics(opts)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobsApi->print_jobs_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| Result page, default: 1 | [optional] 
 **page_size** | **Integer**| The default is 100. | [optional] 
 **created_after** | **String**| Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **created_before** | **String**| Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **modified_after** | **String**| Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **modified_before** | **String**| Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp. | [optional] 
 **id** | **String**| Filter by id | [optional] 
 **ordering** | **String**| Which field to use when ordering the results. | [optional] 

### Return type

**Object**

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **print_jobs_status_read**
> InlineResponse2002 print_jobs_status_read(id)

Retrieve Print-Job Status

Sub-resource that represents the status of a Print-Job

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::PrintJobsApi.new
id = 'id_example' # String | Id of the resource

begin
  #Retrieve Print-Job Status
  result = api_instance.print_jobs_status_read(id)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling PrintJobsApi->print_jobs_status_read: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the resource | 

### Return type

[**InlineResponse2002**](InlineResponse2002.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



