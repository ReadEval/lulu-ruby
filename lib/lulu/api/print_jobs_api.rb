=begin
#Universal Publishing Platform API

## Getting Started The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.  The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).  Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.   ## Registration You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.  ## Sandbox Environment The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.  To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/  ## Authorization The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.  To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.  <img src=\"assets/keyAndSecretExample.png\">  ## Generate a Token To interact with the API you first have to generate an OAuth token. This requires the following parameters: * `client_key` * `client_secret` * `grant-type` must be set to `client_credentials`  You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:  ```bash curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\   -d 'grant_type=client_credentials' \\   -H 'Content-Type: application/x-www-form-urlencoded' \\   -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw==' ```  The request will return a JSON response that contains an `access_token` key:  ```json {     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",     \"expires_in\":3600,     \"refresh_expires_in\":604800,     \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",     \"token_type\":\"bearer\",     \"not-before-policy\":0,     \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\" } ```  Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.  ## Make authenticated requests To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request: `Authorization: Bearer {access_token}`:  ```bash curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\   -H 'Authorization: Bearer {access_token}' \\   -H 'Content-Type: application/json' ```  ## Select a Product Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**: > Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**  Here are a few examples:  | pod_package_id | Description | | --- | --- | | `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping | | `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil| | `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover | | `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |  For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.  ## Create a Print-Job Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:  * `line_items` **(required)**: the list of books that shall be printed * `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number. * `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer * `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:     * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.     * `PRIORITY_MAIL` - priority mail shipping     * `GROUND` - Courier based shipping using ground transportation in the US.     * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent     * `EXPRESS` - overnight delivery. Fastest shipping available. * `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)  The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used. If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.  You can find the detailed documentation for [Creating a new Print-Job](#) below.  ## Check Print-Job Status After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:  <img src=\"assets/print-job-stages.svg\">  * **CREATED**: Print-Job created * **UNPAID**: Print-Job can be paid * **PAYMENT_IN_PROGRESS**: Payment is in Progress * **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay. * **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly. * **IN_PRODUCTION**: Print-Job submitted to printer * **SHIPPED**: Print-Job is fully shipped  There are a few more status that can occur when there is a problem with the Print-Job: * **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue. * **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.  ## Shipping Notification Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint. 

OpenAPI spec version: 1.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 3.3.4

=end

require 'uri'

module Lulu
  class PrintJobsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Retrieve Print-Job Costs
    # Sub-resource to retrieve only the costs of a Print-Job
    # @param id Id of the resource
    # @param [Hash] opts the optional parameters
    # @return [InlineResponse2001]
    def print_jobs_costs(id, opts = {})
      data, _status_code, _headers = print_jobs_costs_with_http_info(id, opts)
      data
    end

    # Retrieve Print-Job Costs
    # Sub-resource to retrieve only the costs of a Print-Job
    # @param id Id of the resource
    # @param [Hash] opts the optional parameters
    # @return [Array<(InlineResponse2001, Fixnum, Hash)>] InlineResponse2001 data, response status code and response headers
    def print_jobs_costs_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PrintJobsApi.print_jobs_costs ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling PrintJobsApi.print_jobs_costs"
      end
      # resource path
      local_var_path = '/print-jobs/{id}/costs/'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

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
        :return_type => 'InlineResponse2001')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PrintJobsApi#print_jobs_costs\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Create a new Print-Job
    # Print-Jobs are the core resource of the Print API. A Printjob consists of line items, shipping information and some additional metadata.  ## Elements of a Print-Job ### Line Items A line item represents a book that should be printed or in short a **printable**. Printables consist of cover and interior files as well as a `pod_package_id`. The `pod_package_id` represents the manufacturing options; see the [\"Select a product\"](#section/Select-a-Product) section for details. Each printable can be identified by an immutable `printable_id`. The `printable_id` can be used for re-orders so that the files don't have to be transferred again.  ### Shipping Information & Metadata Print-Jobs have to contain a `shipping_address` as well as a `shipping_level`. Lulu offers five different service levels that differ in speed and traceability.  ### Additional Metadata A few additional metadata fields can be specified in the Print-Job as well: * `contact_email` for questions related to the Print-Job itself * `production_delay` allows you to specify a delay (between 60 minutes and a full day) before the Print-Job goes to production. * `external_id` allows you to link the Print-Job to an internal order number or other reference.  ## File Handling and Normalization Interior and cover files have to be specified with a URL from which Lulu can download the files. Using encoded [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication#URL_encoding) in the URL is ok. All files processed by Lulu will be validated and normalized before sending them to production. If problems with the file occur, the PrintJob will be rejected or cancelled and an error message will be displayed.  ## Automation and Payment After a Print-Job has been created successfully, it will remain in an `UNPAID` state until it is paid for through the developer portal. However, you can automate the process by putting a credit card on file. Then, the Print-Job will automatically transition to the `PRODUCTION_DELAY` status and your card will charged when the Print-Job is sent to production. 
    # @param [Hash] opts the optional parameters
    # @option opts [InlineObject1] :inline_object1 
    # @return [InlineResponse2011]
    def print_jobs_create(opts = {})
      data, _status_code, _headers = print_jobs_create_with_http_info(opts)
      data
    end

    # Create a new Print-Job
    # Print-Jobs are the core resource of the Print API. A Printjob consists of line items, shipping information and some additional metadata.  ## Elements of a Print-Job ### Line Items A line item represents a book that should be printed or in short a **printable**. Printables consist of cover and interior files as well as a &#x60;pod_package_id&#x60;. The &#x60;pod_package_id&#x60; represents the manufacturing options; see the [\&quot;Select a product\&quot;](#section/Select-a-Product) section for details. Each printable can be identified by an immutable &#x60;printable_id&#x60;. The &#x60;printable_id&#x60; can be used for re-orders so that the files don&#39;t have to be transferred again.  ### Shipping Information &amp; Metadata Print-Jobs have to contain a &#x60;shipping_address&#x60; as well as a &#x60;shipping_level&#x60;. Lulu offers five different service levels that differ in speed and traceability.  ### Additional Metadata A few additional metadata fields can be specified in the Print-Job as well: * &#x60;contact_email&#x60; for questions related to the Print-Job itself * &#x60;production_delay&#x60; allows you to specify a delay (between 60 minutes and a full day) before the Print-Job goes to production. * &#x60;external_id&#x60; allows you to link the Print-Job to an internal order number or other reference.  ## File Handling and Normalization Interior and cover files have to be specified with a URL from which Lulu can download the files. Using encoded [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication#URL_encoding) in the URL is ok. All files processed by Lulu will be validated and normalized before sending them to production. If problems with the file occur, the PrintJob will be rejected or cancelled and an error message will be displayed.  ## Automation and Payment After a Print-Job has been created successfully, it will remain in an &#x60;UNPAID&#x60; state until it is paid for through the developer portal. However, you can automate the process by putting a credit card on file. Then, the Print-Job will automatically transition to the &#x60;PRODUCTION_DELAY&#x60; status and your card will charged when the Print-Job is sent to production. 
    # @param [Hash] opts the optional parameters
    # @option opts [InlineObject1] :inline_object1 
    # @return [Array<(InlineResponse2011, Fixnum, Hash)>] InlineResponse2011 data, response status code and response headers
    def print_jobs_create_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PrintJobsApi.print_jobs_create ...'
      end
      # resource path
      local_var_path = '/print-jobs/'

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(opts[:'inline_object1'])
      auth_names = ['oauth2']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'InlineResponse2011')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PrintJobsApi#print_jobs_create\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Retrieve a list of Print-Jobs
    # Use this request to show a list of Print-Jobs. The list is paginated and can be filtered by various attributes that are given as query parameters.  Timestamps like `created_after`, `created_before`, `modified_after`, and `modified_before` can be entered as [ISO8601 datetime strings](https://www.w3.org/TR/NOTE-datetime). Internally, the Lulu API uses [Coordinated Universal Time (UTC)](https://en.wikipedia.org/wiki/Coordinated_Universal_Time). The following formats are valid:  * `2017-11-09` (date only)  * `2017-11-09T09:30` (datetime with minute precision)  * `2017-11-09T09:30:08` (datetime with second precision)  * `2017-11-09T09:30:08Z` (UTC datetime)  * `2017-11-09T09:30:08+06:00` (datetime with offset)  To filter Print-Jobs by status you can use any valid status string (`CREATED`, `REJECTED`, `UNPAID`, `PAYMENT_IN_PROGRESS`, `PRODUCTION_READY`, `PRODUCTION_DELAYED`, `IN_PRODUCTION`, `ERROR`, `SHIPPED`, `CANCELED`). `PAYMENT_IN_PROGRESS` and `PRODUCTION_READY` are rather short-lived states that exist only for a few minutes at max; filtering by these status will rarely yield any results. 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page Result page, default: 1
    # @option opts [Integer] :page_size The default is 100.
    # @option opts [String] :created_after Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :created_before Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_after Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_before Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :id Filter by id
    # @option opts [String] :order_id Filter by order_id
    # @option opts [BOOLEAN] :exclude_line_items Leave the list of line_items out of the Print-Jobs in the response.
    # @option opts [String] :search Search across the fields &#39;id&#39;, &#39;external_id&#39;, &#39;order_id&#39;, &#39;status&#39;, &#39;line_item_id&#39;, &#39;line_item_external_id&#39;, &#39;line_item_title&#39;, &#39;line_item_tracking_id&#39; and &#39;shipping_address&#39;
    # @option opts [String] :ordering Which field to use when ordering the results.
    # @return [Object]
    def print_jobs_list(opts = {})
      data, _status_code, _headers = print_jobs_list_with_http_info(opts)
      data
    end

    # Retrieve a list of Print-Jobs
    # Use this request to show a list of Print-Jobs. The list is paginated and can be filtered by various attributes that are given as query parameters.  Timestamps like &#x60;created_after&#x60;, &#x60;created_before&#x60;, &#x60;modified_after&#x60;, and &#x60;modified_before&#x60; can be entered as [ISO8601 datetime strings](https://www.w3.org/TR/NOTE-datetime). Internally, the Lulu API uses [Coordinated Universal Time (UTC)](https://en.wikipedia.org/wiki/Coordinated_Universal_Time). The following formats are valid:  * &#x60;2017-11-09&#x60; (date only)  * &#x60;2017-11-09T09:30&#x60; (datetime with minute precision)  * &#x60;2017-11-09T09:30:08&#x60; (datetime with second precision)  * &#x60;2017-11-09T09:30:08Z&#x60; (UTC datetime)  * &#x60;2017-11-09T09:30:08+06:00&#x60; (datetime with offset)  To filter Print-Jobs by status you can use any valid status string (&#x60;CREATED&#x60;, &#x60;REJECTED&#x60;, &#x60;UNPAID&#x60;, &#x60;PAYMENT_IN_PROGRESS&#x60;, &#x60;PRODUCTION_READY&#x60;, &#x60;PRODUCTION_DELAYED&#x60;, &#x60;IN_PRODUCTION&#x60;, &#x60;ERROR&#x60;, &#x60;SHIPPED&#x60;, &#x60;CANCELED&#x60;). &#x60;PAYMENT_IN_PROGRESS&#x60; and &#x60;PRODUCTION_READY&#x60; are rather short-lived states that exist only for a few minutes at max; filtering by these status will rarely yield any results. 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page Result page, default: 1
    # @option opts [Integer] :page_size The default is 100.
    # @option opts [String] :created_after Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :created_before Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_after Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_before Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :id Filter by id
    # @option opts [String] :order_id Filter by order_id
    # @option opts [BOOLEAN] :exclude_line_items Leave the list of line_items out of the Print-Jobs in the response.
    # @option opts [String] :search Search across the fields &#39;id&#39;, &#39;external_id&#39;, &#39;order_id&#39;, &#39;status&#39;, &#39;line_item_id&#39;, &#39;line_item_external_id&#39;, &#39;line_item_title&#39;, &#39;line_item_tracking_id&#39; and &#39;shipping_address&#39;
    # @option opts [String] :ordering Which field to use when ordering the results.
    # @return [Array<(Object, Fixnum, Hash)>] Object data, response status code and response headers
    def print_jobs_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PrintJobsApi.print_jobs_list ...'
      end
      # resource path
      local_var_path = '/print-jobs/'

      # query parameters
      query_params = {}
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'created_after'] = opts[:'created_after'] if !opts[:'created_after'].nil?
      query_params[:'created_before'] = opts[:'created_before'] if !opts[:'created_before'].nil?
      query_params[:'modified_after'] = opts[:'modified_after'] if !opts[:'modified_after'].nil?
      query_params[:'modified_before'] = opts[:'modified_before'] if !opts[:'modified_before'].nil?
      query_params[:'id'] = opts[:'id'] if !opts[:'id'].nil?
      query_params[:'order_id'] = opts[:'order_id'] if !opts[:'order_id'].nil?
      query_params[:'exclude_line_items'] = opts[:'exclude_line_items'] if !opts[:'exclude_line_items'].nil?
      query_params[:'search'] = opts[:'search'] if !opts[:'search'].nil?
      query_params[:'ordering'] = opts[:'ordering'] if !opts[:'ordering'].nil?

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
        @api_client.config.logger.debug "API called: PrintJobsApi#print_jobs_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Retrieve a single Print-Job
    # Retrieve a single Print-Job by id.
    # @param id Id of the resource
    # @param [Hash] opts the optional parameters
    # @return [InlineResponse200]
    def print_jobs_read(id, opts = {})
      data, _status_code, _headers = print_jobs_read_with_http_info(id, opts)
      data
    end

    # Retrieve a single Print-Job
    # Retrieve a single Print-Job by id.
    # @param id Id of the resource
    # @param [Hash] opts the optional parameters
    # @return [Array<(InlineResponse200, Fixnum, Hash)>] InlineResponse200 data, response status code and response headers
    def print_jobs_read_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PrintJobsApi.print_jobs_read ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling PrintJobsApi.print_jobs_read"
      end
      # resource path
      local_var_path = '/print-jobs/{id}/'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

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
        :return_type => 'InlineResponse200')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PrintJobsApi#print_jobs_read\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Retrieve the number of Print-Jobs in each status
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page Result page, default: 1
    # @option opts [Integer] :page_size The default is 100.
    # @option opts [String] :created_after Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :created_before Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_after Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_before Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :id Filter by id
    # @option opts [String] :ordering Which field to use when ordering the results.
    # @return [Object]
    def print_jobs_statistics(opts = {})
      data, _status_code, _headers = print_jobs_statistics_with_http_info(opts)
      data
    end

    # Retrieve the number of Print-Jobs in each status
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page Result page, default: 1
    # @option opts [Integer] :page_size The default is 100.
    # @option opts [String] :created_after Filter by creation timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :created_before Filter by creation timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_after Filter by modification timestamp after the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :modified_before Filter by modification timestamp before the given ([ISO 8601](https://www.w3.org/TR/NOTE-datetime)) timestamp.
    # @option opts [String] :id Filter by id
    # @option opts [String] :ordering Which field to use when ordering the results.
    # @return [Array<(Object, Fixnum, Hash)>] Object data, response status code and response headers
    def print_jobs_statistics_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PrintJobsApi.print_jobs_statistics ...'
      end
      # resource path
      local_var_path = '/print-jobs/statistics/'

      # query parameters
      query_params = {}
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'created_after'] = opts[:'created_after'] if !opts[:'created_after'].nil?
      query_params[:'created_before'] = opts[:'created_before'] if !opts[:'created_before'].nil?
      query_params[:'modified_after'] = opts[:'modified_after'] if !opts[:'modified_after'].nil?
      query_params[:'modified_before'] = opts[:'modified_before'] if !opts[:'modified_before'].nil?
      query_params[:'id'] = opts[:'id'] if !opts[:'id'].nil?
      query_params[:'ordering'] = opts[:'ordering'] if !opts[:'ordering'].nil?

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
        @api_client.config.logger.debug "API called: PrintJobsApi#print_jobs_statistics\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Retrieve Print-Job Status
    # Sub-resource that represents the status of a Print-Job
    # @param id Id of the resource
    # @param [Hash] opts the optional parameters
    # @return [InlineResponse2002]
    def print_jobs_status_read(id, opts = {})
      data, _status_code, _headers = print_jobs_status_read_with_http_info(id, opts)
      data
    end

    # Retrieve Print-Job Status
    # Sub-resource that represents the status of a Print-Job
    # @param id Id of the resource
    # @param [Hash] opts the optional parameters
    # @return [Array<(InlineResponse2002, Fixnum, Hash)>] InlineResponse2002 data, response status code and response headers
    def print_jobs_status_read_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PrintJobsApi.print_jobs_status_read ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling PrintJobsApi.print_jobs_status_read"
      end
      # resource path
      local_var_path = '/print-jobs/{id}/status/'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

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
        :return_type => 'InlineResponse2002')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PrintJobsApi#print_jobs_status_read\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

  end
end
