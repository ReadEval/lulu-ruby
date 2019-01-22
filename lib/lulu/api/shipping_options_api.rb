=begin
#Universal Publishing Platform API

## Getting Started The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.  The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).  Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.   ## Registration You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.  ## Sandbox Environment The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.  To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/  ## Authorization The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.  To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.  <img src=\"assets/keyAndSecretExample.png\">  ## Generate a Token To interact with the API you first have to generate an OAuth token. This requires the following parameters: * `client_key` * `client_secret` * `grant-type` must be set to `client_credentials`  You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:  ```bash curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\   -d 'grant_type=client_credentials' \\   -H 'Content-Type: application/x-www-form-urlencoded' \\   -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw==' ```  The request will return a JSON response that contains an `access_token` key:  ```json {     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",     \"expires_in\":3600,     \"refresh_expires_in\":604800,     \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",     \"token_type\":\"bearer\",     \"not-before-policy\":0,     \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\" } ```  Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.  ## Make authenticated requests To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request: `Authorization: Bearer {access_token}`:  ```bash curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\   -H 'Authorization: Bearer {access_token}' \\   -H 'Content-Type: application/json' ```  ## Select a Product Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**: > Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**  Here are a few examples:  | pod_package_id | Description | | --- | --- | | `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping | | `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil| | `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover | | `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |  For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.  ## Create a Print-Job Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:  * `line_items` **(required)**: the list of books that shall be printed * `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number. * `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer * `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:     * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.     * `PRIORITY_MAIL` - priority mail shipping     * `GROUND` - Courier based shipping using ground transportation in the US.     * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent     * `EXPRESS` - overnight delivery. Fastest shipping available. * `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)  The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used. If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.  You can find the detailed documentation for [Creating a new Print-Job](#) below.  ## Check Print-Job Status After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:  <img src=\"assets/print-job-stages.svg\">  * **CREATED**: Print-Job created * **UNPAID**: Print-Job can be paid * **PAYMENT_IN_PROGRESS**: Payment is in Progress * **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay. * **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly. * **IN_PRODUCTION**: Print-Job submitted to printer * **SHIPPED**: Print-Job is fully shipped  There are a few more status that can occur when there is a problem with the Print-Job: * **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue. * **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.  ## Shipping Notification Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint. 

OpenAPI spec version: 1.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 3.3.4

=end

require 'uri'

module Lulu
  class ShippingOptionsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Retrieve List of Shipping Options
    # Use <a href=\"#operation/shipping-options_list\" target=\"_blank\">print-shipping-options</a> instead
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def deprecated_shipping_options_list(opts = {})
      deprecated_shipping_options_list_with_http_info(opts)
      nil
    end

    # Retrieve List of Shipping Options
    # Use &lt;a href&#x3D;\&quot;#operation/shipping-options_list\&quot; target&#x3D;\&quot;_blank\&quot;&gt;print-shipping-options&lt;/a&gt; instead
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def deprecated_shipping_options_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ShippingOptionsApi.deprecated_shipping_options_list ...'
      end
      # resource path
      local_var_path = '/shipping-options/'

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['oauth2']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ShippingOptionsApi#deprecated_shipping_options_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Retrieve List of Shipping Options
    # When integrating the Print API with your own shop, you might want to give customers an option to select among different shipping_levels. This endpoint allows you to request available shipping methods (including cost) with minimal input data. Typically you want to specify the following parameters in a query: * `iso_country_code` * `fastest_per_level` * `quantity` * `pod_package_id` * `currency` only required if you don't want USD  You can further restrict shipping options that support post box delivery by adding `postbox_ok=true` to your query. 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page Result page, default: 1
    # @option opts [Integer] :page_size The default is 100.
    # @option opts [String] :currency Currency to base cost calculations on, defaults to USD. Available currencies are AUD, CAD, EUR, GBP, and USD.
    # @option opts [String] :quantity Quantity of shipped units to base cost calculations on. Use the sum of all units from all line items.
    # @option opts [String] :pod_package_id Filter by pod package id. When your cart uses multiple line items, add an additional query parameter for each line item like &#x60;?pod_package_id&#x3D;value1&amp;pod_package_id&#x3D;value2&#x60;.
    # @option opts [String] :iso_country_code Filter by [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code (e.g. US, CA)
    # @option opts [String] :level Filter shipping options by given level
    # @option opts [BOOLEAN] :postbox_ok Show only those shipping methods that deliver to post boxes. Accepted boolean &#39;truth&#39; values are &#x60;yes&#x60;, &#x60;y&#x60;, &#x60;t&#x60;, &#x60;true&#x60;, and &#x60;1&#x60;.
    # @option opts [BOOLEAN] :fastest_per_level Show only the fastest option per shipping level.
    # @return [Object]
    def shipping_options_list(opts = {})
      data, _status_code, _headers = shipping_options_list_with_http_info(opts)
      data
    end

    # Retrieve List of Shipping Options
    # When integrating the Print API with your own shop, you might want to give customers an option to select among different shipping_levels. This endpoint allows you to request available shipping methods (including cost) with minimal input data. Typically you want to specify the following parameters in a query: * &#x60;iso_country_code&#x60; * &#x60;fastest_per_level&#x60; * &#x60;quantity&#x60; * &#x60;pod_package_id&#x60; * &#x60;currency&#x60; only required if you don&#39;t want USD  You can further restrict shipping options that support post box delivery by adding &#x60;postbox_ok&#x3D;true&#x60; to your query. 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page Result page, default: 1
    # @option opts [Integer] :page_size The default is 100.
    # @option opts [String] :currency Currency to base cost calculations on, defaults to USD. Available currencies are AUD, CAD, EUR, GBP, and USD.
    # @option opts [String] :quantity Quantity of shipped units to base cost calculations on. Use the sum of all units from all line items.
    # @option opts [String] :pod_package_id Filter by pod package id. When your cart uses multiple line items, add an additional query parameter for each line item like &#x60;?pod_package_id&#x3D;value1&amp;pod_package_id&#x3D;value2&#x60;.
    # @option opts [String] :iso_country_code Filter by [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code (e.g. US, CA)
    # @option opts [String] :level Filter shipping options by given level
    # @option opts [BOOLEAN] :postbox_ok Show only those shipping methods that deliver to post boxes. Accepted boolean &#39;truth&#39; values are &#x60;yes&#x60;, &#x60;y&#x60;, &#x60;t&#x60;, &#x60;true&#x60;, and &#x60;1&#x60;.
    # @option opts [BOOLEAN] :fastest_per_level Show only the fastest option per shipping level.
    # @return [Array<(Object, Fixnum, Hash)>] Object data, response status code and response headers
    def shipping_options_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ShippingOptionsApi.shipping_options_list ...'
      end
      if @api_client.config.client_side_validation && opts[:'level'] && !['MAIL', 'PRIORITY_MAIL', 'GROUND_HD', 'GROUND_BUS', 'GROUND', 'EXPEDITED', 'EXPRESS'].include?(opts[:'level'])
        fail ArgumentError, 'invalid value for "level", must be one of MAIL, PRIORITY_MAIL, GROUND_HD, GROUND_BUS, GROUND, EXPEDITED, EXPRESS'
      end
      # resource path
      local_var_path = '/print-shipping-options/'

      # query parameters
      query_params = {}
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'currency'] = opts[:'currency'] if !opts[:'currency'].nil?
      query_params[:'quantity'] = opts[:'quantity'] if !opts[:'quantity'].nil?
      query_params[:'pod_package_id'] = opts[:'pod_package_id'] if !opts[:'pod_package_id'].nil?
      query_params[:'iso_country_code'] = opts[:'iso_country_code'] if !opts[:'iso_country_code'].nil?
      query_params[:'level'] = opts[:'level'] if !opts[:'level'].nil?
      query_params[:'postbox_ok'] = opts[:'postbox_ok'] if !opts[:'postbox_ok'].nil?
      query_params[:'fastest_per_level'] = opts[:'fastest_per_level'] if !opts[:'fastest_per_level'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['oauth2']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Object')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ShippingOptionsApi#shipping_options_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

  end
end
