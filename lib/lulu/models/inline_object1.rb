=begin
#Universal Publishing Platform API

## Getting Started The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.  The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).  Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.   ## Registration You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.  ## Sandbox Environment The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.  To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/  ## Authorization The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.  To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.  <img src=\"assets/keyAndSecretExample.png\">  ## Generate a Token To interact with the API you first have to generate an OAuth token. This requires the following parameters: * `client_key` * `client_secret` * `grant-type` must be set to `client_credentials`  You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:  ```bash curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\   -d 'grant_type=client_credentials' \\   -H 'Content-Type: application/x-www-form-urlencoded' \\   -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw==' ```  The request will return a JSON response that contains an `access_token` key:  ```json {     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",     \"expires_in\":3600,     \"refresh_expires_in\":604800,     \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",     \"token_type\":\"bearer\",     \"not-before-policy\":0,     \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\" } ```  Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.  ## Make authenticated requests To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request: `Authorization: Bearer {access_token}`:  ```bash curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\   -H 'Authorization: Bearer {access_token}' \\   -H 'Content-Type: application/json' ```  ## Select a Product Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**: > Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**  Here are a few examples:  | pod_package_id | Description | | --- | --- | | `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping | | `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil| | `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover | | `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |  For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.  ## Create a Print-Job Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:  * `line_items` **(required)**: the list of books that shall be printed * `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number. * `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer * `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:     * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.     * `PRIORITY_MAIL` - priority mail shipping     * `GROUND` - Courier based shipping using ground transportation in the US.     * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent     * `EXPRESS` - overnight delivery. Fastest shipping available. * `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)  The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used. If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.  You can find the detailed documentation for [Creating a new Print-Job](#) below.  ## Check Print-Job Status After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:  <img src=\"assets/print-job-stages.svg\">  * **CREATED**: Print-Job created * **UNPAID**: Print-Job can be paid * **PAYMENT_IN_PROGRESS**: Payment is in Progress * **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay. * **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly. * **IN_PRODUCTION**: Print-Job submitted to printer * **SHIPPED**: Print-Job is fully shipped  There are a few more status that can occur when there is a problem with the Print-Job: * **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue. * **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.  ## Shipping Notification Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint. 

OpenAPI spec version: 1.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 3.3.4

=end

require 'date'

module Lulu
  # The job resource that represents a print order
  class InlineObject1
    attr_accessor :id

    # The service level of a shipping option. In the US `GROUND_HD` (ground home delivery) and `GROUND_BUS` (ground business) have to be used. Outside of the US use plain `GROUND`.
    attr_accessor :shipping_level

    # Use `shipping_level` instead
    attr_accessor :shipping_option_level

    attr_accessor :estimated_shipping_dates

    # The line items of a Print-Job, defining it's Printables and their quantities. The property name 'items' can be used instead.
    attr_accessor :line_items

    # Alias for `line_items`
    attr_accessor :items

    # Email address that should be contacted if questions regarding the Print-Job arise. Lulu recommends to use the email of a person who is responsible for placing the Print-Job like a developer or business owner. 
    attr_accessor :contact_email

    attr_accessor :shipping_address

    # Delay before a newly created Print-Job is sent to production. Minimum is 60 minutes, maximum is 1440 minutes (=24 hours). As most cancellation requests occur right after an order has been placed, it makes sense to wait for some time before sending an order to production. Once production has started, orders cannot be canceled anymore. 
    attr_accessor :production_delay

    # Target timestamp of when this job will move into production ([ISO 8601](https://www.w3.org/TR/NOTE-datetime))
    attr_accessor :production_due_time

    # Reference to the order, which this PrintJob has created
    attr_accessor :order_id

    # [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code of the tax country determined for this job
    attr_accessor :tax_country

    # Arbitrary string to identify and connect a print job to your systems. Set it to an order number, a purchase order or whatever else works for your particular use case.
    attr_accessor :external_id

    attr_accessor :costs

    class EnumAttributeValidator
      attr_reader :datatype
      attr_reader :allowable_values

      def initialize(datatype, allowable_values)
        @allowable_values = allowable_values.map do |value|
          case datatype.to_s
          when /Integer/i
            value.to_i
          when /Float/i
            value.to_f
          else
            value
          end
        end
      end

      def valid?(value)
        !value || allowable_values.include?(value)
      end
    end

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'id' => :'id',
        :'shipping_level' => :'shipping_level',
        :'shipping_option_level' => :'shipping_option_level',
        :'estimated_shipping_dates' => :'estimated_shipping_dates',
        :'line_items' => :'line_items',
        :'items' => :'items',
        :'contact_email' => :'contact_email',
        :'shipping_address' => :'shipping_address',
        :'production_delay' => :'production_delay',
        :'production_due_time' => :'production_due_time',
        :'order_id' => :'order_id',
        :'tax_country' => :'tax_country',
        :'external_id' => :'external_id',
        :'costs' => :'costs'
      }
    end

    # Attribute type mapping.
    def self.openapi_types
      {
        :'id' => :'Float',
        :'shipping_level' => :'String',
        :'shipping_option_level' => :'Object',
        :'estimated_shipping_dates' => :'PrintjobsEstimatedShippingDates',
        :'line_items' => :'Array<PrintjobsLineItems>',
        :'items' => :'Array<PrintjobsLineItems>',
        :'contact_email' => :'String',
        :'shipping_address' => :'PrintjobsShippingAddress',
        :'production_delay' => :'Integer',
        :'production_due_time' => :'DateTime',
        :'order_id' => :'String',
        :'tax_country' => :'String',
        :'external_id' => :'String',
        :'costs' => :'PrintjobsCosts'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
      end

      if attributes.has_key?(:'shipping_level')
        self.shipping_level = attributes[:'shipping_level']
      end

      if attributes.has_key?(:'shipping_option_level')
        self.shipping_option_level = attributes[:'shipping_option_level']
      end

      if attributes.has_key?(:'estimated_shipping_dates')
        self.estimated_shipping_dates = attributes[:'estimated_shipping_dates']
      end

      if attributes.has_key?(:'line_items')
        if (value = attributes[:'line_items']).is_a?(Array)
          self.line_items = value
        end
      end

      if attributes.has_key?(:'items')
        if (value = attributes[:'items']).is_a?(Array)
          self.items = value
        end
      end

      if attributes.has_key?(:'contact_email')
        self.contact_email = attributes[:'contact_email']
      end

      if attributes.has_key?(:'shipping_address')
        self.shipping_address = attributes[:'shipping_address']
      end

      if attributes.has_key?(:'production_delay')
        self.production_delay = attributes[:'production_delay']
      else
        self.production_delay = 60
      end

      if attributes.has_key?(:'production_due_time')
        self.production_due_time = attributes[:'production_due_time']
      end

      if attributes.has_key?(:'order_id')
        self.order_id = attributes[:'order_id']
      end

      if attributes.has_key?(:'tax_country')
        self.tax_country = attributes[:'tax_country']
      end

      if attributes.has_key?(:'external_id')
        self.external_id = attributes[:'external_id']
      end

      if attributes.has_key?(:'costs')
        self.costs = attributes[:'costs']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @id.nil?
        invalid_properties.push('invalid value for "id", id cannot be nil.')
      end

      if @shipping_level.nil?
        invalid_properties.push('invalid value for "shipping_level", shipping_level cannot be nil.')
      end

      if @line_items.nil?
        invalid_properties.push('invalid value for "line_items", line_items cannot be nil.')
      end

      if @contact_email.nil?
        invalid_properties.push('invalid value for "contact_email", contact_email cannot be nil.')
      end

      if @shipping_address.nil?
        invalid_properties.push('invalid value for "shipping_address", shipping_address cannot be nil.')
      end

      if !@tax_country.nil? && @tax_country.to_s.length > 2
        invalid_properties.push('invalid value for "tax_country", the character length must be smaller than or equal to 2.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @id.nil?
      return false if @shipping_level.nil?
      shipping_level_validator = EnumAttributeValidator.new('String', ['MAIL', 'PRIORITY_MAIL', 'GROUND_HD', 'GROUND_BUS', 'GROUND', 'EXPEDITED', 'EXPRESS'])
      return false unless shipping_level_validator.valid?(@shipping_level)
      return false if @line_items.nil?
      return false if @contact_email.nil?
      return false if @shipping_address.nil?
      return false if !@tax_country.nil? && @tax_country.to_s.length > 2
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] shipping_level Object to be assigned
    def shipping_level=(shipping_level)
      validator = EnumAttributeValidator.new('String', ['MAIL', 'PRIORITY_MAIL', 'GROUND_HD', 'GROUND_BUS', 'GROUND', 'EXPEDITED', 'EXPRESS'])
      unless validator.valid?(shipping_level)
        fail ArgumentError, 'invalid value for "shipping_level", must be one of #{validator.allowable_values}.'
      end
      @shipping_level = shipping_level
    end

    # Custom attribute writer method with validation
    # @param [Object] tax_country Value to be assigned
    def tax_country=(tax_country)
      if !tax_country.nil? && tax_country.to_s.length > 2
        fail ArgumentError, 'invalid value for "tax_country", the character length must be smaller than or equal to 2.'
      end

      @tax_country = tax_country
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          id == o.id &&
          shipping_level == o.shipping_level &&
          shipping_option_level == o.shipping_option_level &&
          estimated_shipping_dates == o.estimated_shipping_dates &&
          line_items == o.line_items &&
          items == o.items &&
          contact_email == o.contact_email &&
          shipping_address == o.shipping_address &&
          production_delay == o.production_delay &&
          production_due_time == o.production_due_time &&
          order_id == o.order_id &&
          tax_country == o.tax_country &&
          external_id == o.external_id &&
          costs == o.costs
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [id, shipping_level, shipping_option_level, estimated_shipping_dates, line_items, items, contact_email, shipping_address, production_delay, production_due_time, order_id, tax_country, external_id, costs].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.openapi_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :BOOLEAN
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        temp_model = Lulu.const_get(type).new
        temp_model.build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        next if value.nil?
        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end
  end
end
