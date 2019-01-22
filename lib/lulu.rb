=begin
#Universal Publishing Platform API

## Getting Started The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.  The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).  Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.   ## Registration You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.  ## Sandbox Environment The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.  To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/  ## Authorization The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.  To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.  <img src=\"assets/keyAndSecretExample.png\">  ## Generate a Token To interact with the API you first have to generate an OAuth token. This requires the following parameters: * `client_key` * `client_secret` * `grant-type` must be set to `client_credentials`  You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:  ```bash curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\   -d 'grant_type=client_credentials' \\   -H 'Content-Type: application/x-www-form-urlencoded' \\   -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw==' ```  The request will return a JSON response that contains an `access_token` key:  ```json {     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",     \"expires_in\":3600,     \"refresh_expires_in\":604800,     \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",     \"token_type\":\"bearer\",     \"not-before-policy\":0,     \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\" } ```  Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.  ## Make authenticated requests To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request: `Authorization: Bearer {access_token}`:  ```bash curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\   -H 'Authorization: Bearer {access_token}' \\   -H 'Content-Type: application/json' ```  ## Select a Product Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**: > Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**  Here are a few examples:  | pod_package_id | Description | | --- | --- | | `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping | | `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil| | `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover | | `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |  For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.  ## Create a Print-Job Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:  * `line_items` **(required)**: the list of books that shall be printed * `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number. * `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer * `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:     * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.     * `PRIORITY_MAIL` - priority mail shipping     * `GROUND` - Courier based shipping using ground transportation in the US.     * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent     * `EXPRESS` - overnight delivery. Fastest shipping available. * `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)  The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used. If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.  You can find the detailed documentation for [Creating a new Print-Job](#) below.  ## Check Print-Job Status After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:  <img src=\"assets/print-job-stages.svg\">  * **CREATED**: Print-Job created * **UNPAID**: Print-Job can be paid * **PAYMENT_IN_PROGRESS**: Payment is in Progress * **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay. * **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly. * **IN_PRODUCTION**: Print-Job submitted to printer * **SHIPPED**: Print-Job is fully shipped  There are a few more status that can occur when there is a problem with the Print-Job: * **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue. * **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.  ## Shipping Notification Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint. 

OpenAPI spec version: 1.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 3.3.4

=end

# Common files
require 'lulu/api_client'
require 'lulu/api_error'
require 'lulu/version'
require 'lulu/configuration'

# Models
require 'lulu/models/bad_request_error'
require 'lulu/models/conflict_error'
require 'lulu/models/discount'
require 'lulu/models/error'
require 'lulu/models/forbidden_error'
require 'lulu/models/inline_object'
require 'lulu/models/inline_object1'
require 'lulu/models/inline_response200'
require 'lulu/models/inline_response2001'
require 'lulu/models/inline_response2001_line_item_costs'
require 'lulu/models/inline_response2002'
require 'lulu/models/inline_response200_line_items'
require 'lulu/models/inline_response200_reprint'
require 'lulu/models/inline_response201'
require 'lulu/models/inline_response2011'
require 'lulu/models/inline_response201_discounts'
require 'lulu/models/inline_response201_line_item_costs'
require 'lulu/models/inline_response201_shipping_cost'
require 'lulu/models/legacy_address'
require 'lulu/models/pagination'
require 'lulu/models/print_file_normalization'
require 'lulu/models/print_job'
require 'lulu/models/print_job_cost'
require 'lulu/models/print_job_cost_calculation'
require 'lulu/models/print_job_cost_calculation_line_item'
require 'lulu/models/print_job_cost_with_line_item_ids'
require 'lulu/models/print_job_detail'
require 'lulu/models/print_job_line_item'
require 'lulu/models/print_job_line_item_cost'
require 'lulu/models/print_job_line_item_detail'
require 'lulu/models/print_job_status'
require 'lulu/models/print_job_status_name'
require 'lulu/models/print_jobs_statistics'
require 'lulu/models/printjobcostcalculations_line_items'
require 'lulu/models/printjobcostcalculations_shipping_address'
require 'lulu/models/printjobs_costs'
require 'lulu/models/printjobs_estimated_shipping_dates'
require 'lulu/models/printjobs_line_items'
require 'lulu/models/printjobs_printable_normalization'
require 'lulu/models/printjobs_printable_normalization_cover'
require 'lulu/models/printjobs_printable_normalization_interior'
require 'lulu/models/printjobs_printable_normalization_interior_normalized_file'
require 'lulu/models/printjobs_shipping_address'
require 'lulu/models/printjobs_status'
require 'lulu/models/printjobs_status_messages'
require 'lulu/models/printjobs_status_messages_printable_normalization'
require 'lulu/models/shipping_option'
require 'lulu/models/shipping_option_level'
require 'lulu/models/shorthand_print_file_normalization'
require 'lulu/models/unauthorized_error'
require 'lulu/models/unavailable_error'

# APIs
require 'lulu/api/print_job_cost_calculations_api'
require 'lulu/api/print_jobs_api'
require 'lulu/api/shipping_options_api'

module Lulu
  class << self
    # Customize default settings for the SDK using block.
    #   Lulu.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
