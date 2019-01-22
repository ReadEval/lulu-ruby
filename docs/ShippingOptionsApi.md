# Lulu::ShippingOptionsApi

All URIs are relative to *https://api.lulu.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deprecated_shipping_options_list**](ShippingOptionsApi.md#deprecated_shipping_options_list) | **GET** /shipping-options/ | Retrieve List of Shipping Options
[**shipping_options_list**](ShippingOptionsApi.md#shipping_options_list) | **GET** /print-shipping-options/ | Retrieve List of Shipping Options


# **deprecated_shipping_options_list**
> deprecated_shipping_options_list

Retrieve List of Shipping Options

Use <a href=\"#operation/shipping-options_list\" target=\"_blank\">print-shipping-options</a> instead

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::ShippingOptionsApi.new

begin
  #Retrieve List of Shipping Options
  api_instance.deprecated_shipping_options_list
rescue Lulu::ApiError => e
  puts "Exception when calling ShippingOptionsApi->deprecated_shipping_options_list: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

nil (empty response body)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined



# **shipping_options_list**
> Object shipping_options_list(opts)

Retrieve List of Shipping Options

When integrating the Print API with your own shop, you might want to give customers an option to select among different shipping_levels. This endpoint allows you to request available shipping methods (including cost) with minimal input data. Typically you want to specify the following parameters in a query: * `iso_country_code` * `fastest_per_level` * `quantity` * `pod_package_id` * `currency` only required if you don't want USD  You can further restrict shipping options that support post box delivery by adding `postbox_ok=true` to your query. 

### Example
```ruby
# load the gem
require 'lulu'
# setup authorization
Lulu.configure do |config|
  # Configure OAuth2 access token for authorization: oauth2
  config.access_token = 'YOUR ACCESS TOKEN'
end

api_instance = Lulu::ShippingOptionsApi.new
opts = {
  page: 56, # Integer | Result page, default: 1
  page_size: 56, # Integer | The default is 100.
  currency: 'currency_example', # String | Currency to base cost calculations on, defaults to USD. Available currencies are AUD, CAD, EUR, GBP, and USD.
  quantity: 'quantity_example', # String | Quantity of shipped units to base cost calculations on. Use the sum of all units from all line items.
  pod_package_id: 'pod_package_id_example', # String | Filter by pod package id. When your cart uses multiple line items, add an additional query parameter for each line item like `?pod_package_id=value1&pod_package_id=value2`.
  iso_country_code: 'iso_country_code_example', # String | Filter by [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code (e.g. US, CA)
  level: 'level_example', # String | Filter shipping options by given level
  postbox_ok: true, # BOOLEAN | Show only those shipping methods that deliver to post boxes. Accepted boolean 'truth' values are `yes`, `y`, `t`, `true`, and `1`.
  fastest_per_level: true # BOOLEAN | Show only the fastest option per shipping level.
}

begin
  #Retrieve List of Shipping Options
  result = api_instance.shipping_options_list(opts)
  p result
rescue Lulu::ApiError => e
  puts "Exception when calling ShippingOptionsApi->shipping_options_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| Result page, default: 1 | [optional] 
 **page_size** | **Integer**| The default is 100. | [optional] 
 **currency** | **String**| Currency to base cost calculations on, defaults to USD. Available currencies are AUD, CAD, EUR, GBP, and USD. | [optional] 
 **quantity** | **String**| Quantity of shipped units to base cost calculations on. Use the sum of all units from all line items. | [optional] 
 **pod_package_id** | **String**| Filter by pod package id. When your cart uses multiple line items, add an additional query parameter for each line item like &#x60;?pod_package_id&#x3D;value1&amp;pod_package_id&#x3D;value2&#x60;. | [optional] 
 **iso_country_code** | **String**| Filter by [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code (e.g. US, CA) | [optional] 
 **level** | **String**| Filter shipping options by given level | [optional] 
 **postbox_ok** | **BOOLEAN**| Show only those shipping methods that deliver to post boxes. Accepted boolean &#39;truth&#39; values are &#x60;yes&#x60;, &#x60;y&#x60;, &#x60;t&#x60;, &#x60;true&#x60;, and &#x60;1&#x60;. | [optional] 
 **fastest_per_level** | **BOOLEAN**| Show only the fastest option per shipping level. | [optional] 

### Return type

**Object**

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



