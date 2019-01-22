# Lulu::PrintJobStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** | The actual processing status of the Print-Job.&lt;/br&gt; Valid status transtions:&lt;/br&gt; &lt;/t&gt;&#39;CREATED&#39;: &#39;UNPAID&#39;, &#39;REJECTED, &#39;CANCELED&#39;, &#39;PRODUCTION_READY&#39;&lt;/br&gt; &lt;/t&gt;&#39;UNPAID&#39;: &#39;PAYMENT_IN_PROGRESS&#39;, &#39;CANCELED&#39;, &#39;PRODUCTION_DELAYED&#39;&lt;/br&gt; &lt;/t&gt;&#39;PAYMENT_IN_PROGRESS&#39;: &#39;UNPAID&#39;, &#39;PRODUCTION_DELAYED&#39;&lt;/br&gt; &lt;/t&gt;&#39;PRODUCTION_DELAYED&#39;: &#39;PRODUCTION_READY&#39;, &#39;CANCELED&#39;&lt;/br&gt; &lt;/t&gt;&#39;PRODUCTION_READY&#39;: &#39;IN_PRODUCTION&#39;, &#39;PRODUCTION_DELAYED&#39;&lt;/br&gt; &lt;/t&gt;&#39;IN_PRODUCTION&#39;: &#39;SHIPPED&#39;, &#39;ERROR&#39;&lt;/br&gt; | [default to &#39;CREATED&#39;]
**message** | **String** | Status related message | [optional] 
**changed** | **DateTime** | [ISO 8601](https://www.w3.org/TR/NOTE-datetime)) Timestamp of the latest status change | 


