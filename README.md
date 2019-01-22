# lulu

Lulu - the Ruby gem for the Universal Publishing Platform API

# Getting Started
The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.

The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).

Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.


## Registration
You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.

## Sandbox Environment
The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.

To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/

## Authorization
The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.

To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.

<img src=\"assets/keyAndSecretExample.png\">

## Generate a Token
To interact with the API you first have to generate an OAuth token. This requires the following parameters:
* `client_key`
* `client_secret`
* `grant-type` must be set to `client_credentials`

You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:

```bash
curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\
  -d 'grant_type=client_credentials' \\
  -H 'Content-Type: application/x-www-form-urlencoded' \\
  -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw=='
```

The request will return a JSON response that contains an `access_token` key:

```json
{
    \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",
    \"expires_in\":3600,
    \"refresh_expires_in\":604800,
    \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",
    \"token_type\":\"bearer\",
    \"not-before-policy\":0,
    \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\"
}
```

Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.

## Make authenticated requests
To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request:
`Authorization: Bearer {access_token}`:

```bash
curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\
  -H 'Authorization: Bearer {access_token}' \\
  -H 'Content-Type: application/json'
```

## Select a Product
Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**:
> Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**

Here are a few examples:

| pod_package_id | Description |
| --- | --- |
| `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping |
| `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil|
| `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover |
| `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |

For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.

## Create a Print-Job
Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:

* `line_items` **(required)**: the list of books that shall be printed
* `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number.
* `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer
* `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:
    * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.
    * `PRIORITY_MAIL` - priority mail shipping
    * `GROUND` - Courier based shipping using ground transportation in the US.
    * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent
    * `EXPRESS` - overnight delivery. Fastest shipping available.
* `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)

The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used.
If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.

You can find the detailed documentation for [Creating a new Print-Job](#) below.

## Check Print-Job Status
After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:

<img src=\"assets/print-job-stages.svg\">

* **CREATED**: Print-Job created
* **UNPAID**: Print-Job can be paid
* **PAYMENT_IN_PROGRESS**: Payment is in Progress
* **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay.
* **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly.
* **IN_PRODUCTION**: Print-Job submitted to printer
* **SHIPPED**: Print-Job is fully shipped

There are a few more status that can occur when there is a problem with the Print-Job:
* **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue.
* **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.

## Shipping Notification
Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint.


This SDK is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 1.0
- Package version: 1.0.0
- Build package: org.openapitools.codegen.languages.RubyClientCodegen

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build lulu.gemspec
```

Then either install the gem locally:

```shell
gem install ./lulu-1.0.0.gem
```
(for development, run `gem install --dev ./lulu-1.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'lulu', '~> 1.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/GIT_USER_ID/GIT_REPO_ID, then add the following in the Gemfile:

    gem 'lulu', :git => 'https://github.com/GIT_USER_ID/GIT_REPO_ID.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:
```ruby
# Load the gem
require 'lulu'

# Setup authorization
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

## Documentation for API Endpoints

All URIs are relative to *https://api.lulu.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*Lulu::PrintJobCostCalculationsApi* | [**print_job_cost_calculations_create**](docs/PrintJobCostCalculationsApi.md#print_job_cost_calculations_create) | **POST** /print-job-cost-calculations/ | Create a Print-Job cost calculation
*Lulu::PrintJobsApi* | [**print_jobs_costs**](docs/PrintJobsApi.md#print_jobs_costs) | **GET** /print-jobs/{id}/costs/ | Retrieve Print-Job Costs
*Lulu::PrintJobsApi* | [**print_jobs_create**](docs/PrintJobsApi.md#print_jobs_create) | **POST** /print-jobs/ | Create a new Print-Job
*Lulu::PrintJobsApi* | [**print_jobs_list**](docs/PrintJobsApi.md#print_jobs_list) | **GET** /print-jobs/ | Retrieve a list of Print-Jobs
*Lulu::PrintJobsApi* | [**print_jobs_read**](docs/PrintJobsApi.md#print_jobs_read) | **GET** /print-jobs/{id}/ | Retrieve a single Print-Job
*Lulu::PrintJobsApi* | [**print_jobs_statistics**](docs/PrintJobsApi.md#print_jobs_statistics) | **GET** /print-jobs/statistics/ | Retrieve the number of Print-Jobs in each status
*Lulu::PrintJobsApi* | [**print_jobs_status_read**](docs/PrintJobsApi.md#print_jobs_status_read) | **GET** /print-jobs/{id}/status/ | Retrieve Print-Job Status
*Lulu::ShippingOptionsApi* | [**deprecated_shipping_options_list**](docs/ShippingOptionsApi.md#deprecated_shipping_options_list) | **GET** /shipping-options/ | Retrieve List of Shipping Options
*Lulu::ShippingOptionsApi* | [**shipping_options_list**](docs/ShippingOptionsApi.md#shipping_options_list) | **GET** /print-shipping-options/ | Retrieve List of Shipping Options


## Documentation for Models

 - [Lulu::BadRequestError](docs/BadRequestError.md)
 - [Lulu::ConflictError](docs/ConflictError.md)
 - [Lulu::Discount](docs/Discount.md)
 - [Lulu::Error](docs/Error.md)
 - [Lulu::ForbiddenError](docs/ForbiddenError.md)
 - [Lulu::InlineObject](docs/InlineObject.md)
 - [Lulu::InlineObject1](docs/InlineObject1.md)
 - [Lulu::InlineResponse200](docs/InlineResponse200.md)
 - [Lulu::InlineResponse2001](docs/InlineResponse2001.md)
 - [Lulu::InlineResponse2001LineItemCosts](docs/InlineResponse2001LineItemCosts.md)
 - [Lulu::InlineResponse2002](docs/InlineResponse2002.md)
 - [Lulu::InlineResponse200LineItems](docs/InlineResponse200LineItems.md)
 - [Lulu::InlineResponse200Reprint](docs/InlineResponse200Reprint.md)
 - [Lulu::InlineResponse201](docs/InlineResponse201.md)
 - [Lulu::InlineResponse2011](docs/InlineResponse2011.md)
 - [Lulu::InlineResponse201Discounts](docs/InlineResponse201Discounts.md)
 - [Lulu::InlineResponse201LineItemCosts](docs/InlineResponse201LineItemCosts.md)
 - [Lulu::InlineResponse201ShippingCost](docs/InlineResponse201ShippingCost.md)
 - [Lulu::LegacyAddress](docs/LegacyAddress.md)
 - [Lulu::Pagination](docs/Pagination.md)
 - [Lulu::PrintFileNormalization](docs/PrintFileNormalization.md)
 - [Lulu::PrintJob](docs/PrintJob.md)
 - [Lulu::PrintJobCost](docs/PrintJobCost.md)
 - [Lulu::PrintJobCostCalculation](docs/PrintJobCostCalculation.md)
 - [Lulu::PrintJobCostCalculationLineItem](docs/PrintJobCostCalculationLineItem.md)
 - [Lulu::PrintJobCostWithLineItemIds](docs/PrintJobCostWithLineItemIds.md)
 - [Lulu::PrintJobDetail](docs/PrintJobDetail.md)
 - [Lulu::PrintJobLineItem](docs/PrintJobLineItem.md)
 - [Lulu::PrintJobLineItemCost](docs/PrintJobLineItemCost.md)
 - [Lulu::PrintJobLineItemDetail](docs/PrintJobLineItemDetail.md)
 - [Lulu::PrintJobStatus](docs/PrintJobStatus.md)
 - [Lulu::PrintJobStatusName](docs/PrintJobStatusName.md)
 - [Lulu::PrintJobsStatistics](docs/PrintJobsStatistics.md)
 - [Lulu::PrintjobcostcalculationsLineItems](docs/PrintjobcostcalculationsLineItems.md)
 - [Lulu::PrintjobcostcalculationsShippingAddress](docs/PrintjobcostcalculationsShippingAddress.md)
 - [Lulu::PrintjobsCosts](docs/PrintjobsCosts.md)
 - [Lulu::PrintjobsEstimatedShippingDates](docs/PrintjobsEstimatedShippingDates.md)
 - [Lulu::PrintjobsLineItems](docs/PrintjobsLineItems.md)
 - [Lulu::PrintjobsPrintableNormalization](docs/PrintjobsPrintableNormalization.md)
 - [Lulu::PrintjobsPrintableNormalizationCover](docs/PrintjobsPrintableNormalizationCover.md)
 - [Lulu::PrintjobsPrintableNormalizationInterior](docs/PrintjobsPrintableNormalizationInterior.md)
 - [Lulu::PrintjobsPrintableNormalizationInteriorNormalizedFile](docs/PrintjobsPrintableNormalizationInteriorNormalizedFile.md)
 - [Lulu::PrintjobsShippingAddress](docs/PrintjobsShippingAddress.md)
 - [Lulu::PrintjobsStatus](docs/PrintjobsStatus.md)
 - [Lulu::PrintjobsStatusMessages](docs/PrintjobsStatusMessages.md)
 - [Lulu::PrintjobsStatusMessagesPrintableNormalization](docs/PrintjobsStatusMessagesPrintableNormalization.md)
 - [Lulu::ShippingOption](docs/ShippingOption.md)
 - [Lulu::ShippingOptionLevel](docs/ShippingOptionLevel.md)
 - [Lulu::ShorthandPrintFileNormalization](docs/ShorthandPrintFileNormalization.md)
 - [Lulu::UnauthorizedError](docs/UnauthorizedError.md)
 - [Lulu::UnavailableError](docs/UnavailableError.md)


## Documentation for Authorization


### oauth2

- **Type**: OAuth
- **Flow**: password
- **Authorization URL**: 
- **Scopes**: N/A

