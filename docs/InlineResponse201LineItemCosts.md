# Lulu::InlineResponse201LineItemCosts

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**quantity** | **Float** | The quantity of printables to base the calculations on | 
**cost_excl_discounts** | **String** | Per unit cost without any discounts applied as a decimal string | 
**tax_rate** | **String** | The tax rate applied to the line as a decimal string | 
**discounts** | [**Array&lt;InlineResponse201Discounts&gt;**](InlineResponse201Discounts.md) | Discounts applied to this line item | 
**total_cost_excl_discounts** | **String** | The total line price without any discounts applied as a decimal string | 
**total_tax** | **String** | The total line tax amount as a decimal string | 
**total_cost_excl_tax** | **String** | The total line price including discounts excluding tax as a decimal string | 
**total_cost_incl_tax** | **String** | The total line price including discounts and taxes as a decimal string | 
**unit_tier_cost** | **String** | Per unit cost with tier discount applied, null for list price (non-tier) customers | [optional] 


