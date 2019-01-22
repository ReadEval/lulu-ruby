# Lulu::ShippingOption

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **Float** |  | 
**level** | **String** |  | [default to &#39;MAIL&#39;]
**postbox_ok** | **BOOLEAN** | Support of delivery to postboxes | [default to false]
**home_only** | **BOOLEAN** | Delivery also on non working days | [default to false]
**business_only** | **BOOLEAN** | Delivery only on working days | [default to false]
**traceable** | **BOOLEAN** | If this shipping provides the possibility to create a tracking link | [default to false]
**transit_time** | **Float** | Average transit time in days | [default to 0]
**shipping_buffer** | **Float** | Production related delay | [default to 0]
**cost_excl_tax** | **String** | The shipping cost excluding taxes as a decimal string. This attribute will only be set on the detail endpoint representation, and only if the query parameters &#39;quantity&#39; and &#39;currency&#39; are provided | [optional] 
**currency** | **String** | Currency of &#x60;cost_excl_tax&#x60; | [optional] 
**min_dispatch_date** | **String** | Earliest estimated dispatch ( handover to carrier ) date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format | [optional] 
**max_dispatch_date** | **String** | Latest estimated dispatch ( handover to carrier ) date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format | [optional] 
**min_delivery_date** | **String** | Earliest estimated delivery date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format | 
**max_delivery_date** | **String** | Latest estimated delivery date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format | 


