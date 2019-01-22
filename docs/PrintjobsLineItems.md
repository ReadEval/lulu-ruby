# Lulu::PrintjobsLineItems

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **Float** |  | 
**status** | [**PrintjobsStatus**](PrintjobsStatus.md) |  | 
**external_id** | **String** | Arbitrary string to identify and connect a print job to your systems. Set it to an order number, a purchase order or whatever else works for your particular use case | [optional] 
**title** | **String** | The title of the line item. Should be on the cover. This field will become mandatory on June 30, 2019! | [optional] 
**quantity** | **Float** | Quantity of printed books for this line item | 
**tracking_id** | **String** | A list of tracking ids for this line item&#39;s shipment | [optional] 
**tracking_urls** | **Array&lt;String&gt;** | A list of tracking urls for this line item&#39;s shipment. | [optional] 
**pod_package_id** | **String** | The id of the PodPackage of the printable of this line item | [optional] 
**page_count** | **Float** | The page count of the printable | [optional] 
**printable_normalization** | [**PrintjobsPrintableNormalization**](PrintjobsPrintableNormalization.md) |  | [optional] 
**interior** | **Object** | Shorthand of the interior source definition. If used together with &#39;cover&#39; , it can replace &#39;printable_normalization&#39;. Alternatively to both options, a &#39;printable_id&#39; of an existing printable can be provided. | [optional] 
**cover** | **Object** | Shorthand of the cover source definition. If used together with &#39;interior&#39; , it can replace &#39;printable_normalization&#39;, Alternatively to both options, a &#39;printable_id&#39; of an existing printable can be provided. | [optional] 
**printable_id** | **String** | Id of the Printable of of this line item. It can be used instead of &#39;printable_normalization&#39; / &#39;interior&#39; / &#39;cover&#39; | [optional] 
**printable** | **String** | deprecated: use &#39;printable_id&#39; instead&lt;/br&gt;&lt;/br&gt; Id of the Printable of of this line item. It can be used instead of &#39;printable_normalization&#39; / &#39;interior&#39; / &#39;cover&#39; | [optional] 


