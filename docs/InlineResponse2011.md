# Lulu::InlineResponse2011

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **Float** |  | 
**shipping_level** | **String** | The service level of a shipping option. In the US &#x60;GROUND_HD&#x60; (ground home delivery) and &#x60;GROUND_BUS&#x60; (ground business) have to be used. Outside of the US use plain &#x60;GROUND&#x60;. | 
**shipping_option_level** | **Object** | Use &#x60;shipping_level&#x60; instead | [optional] 
**estimated_shipping_dates** | [**PrintjobsEstimatedShippingDates**](PrintjobsEstimatedShippingDates.md) |  | [optional] 
**line_items** | [**Array&lt;PrintjobsLineItems&gt;**](PrintjobsLineItems.md) | The line items of a Print-Job, defining it&#39;s Printables and their quantities. The property name &#39;items&#39; can be used instead. | 
**items** | [**Array&lt;PrintjobsLineItems&gt;**](PrintjobsLineItems.md) | Alias for &#x60;line_items&#x60; | [optional] 
**contact_email** | **String** | Email address that should be contacted if questions regarding the Print-Job arise. Lulu recommends to use the email of a person who is responsible for placing the Print-Job like a developer or business owner.  | 
**shipping_address** | [**PrintjobsShippingAddress**](PrintjobsShippingAddress.md) |  | 
**production_delay** | **Integer** | Delay before a newly created Print-Job is sent to production. Minimum is 60 minutes, maximum is 1440 minutes (&#x3D;24 hours). As most cancellation requests occur right after an order has been placed, it makes sense to wait for some time before sending an order to production. Once production has started, orders cannot be canceled anymore.  | [optional] [default to 60]
**production_due_time** | **DateTime** | Target timestamp of when this job will move into production ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) | [optional] 
**order_id** | **String** | Reference to the order, which this PrintJob has created | [optional] 
**tax_country** | **String** | [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code of the tax country determined for this job | [optional] 
**external_id** | **String** | Arbitrary string to identify and connect a print job to your systems. Set it to an order number, a purchase order or whatever else works for your particular use case. | [optional] 
**costs** | [**PrintjobsCosts**](PrintjobsCosts.md) |  | [optional] 


