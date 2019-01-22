=begin
#Universal Publishing Platform API

## Getting Started The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.  The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).  Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.   ## Registration You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.  ## Sandbox Environment The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.  To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/  ## Authorization The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.  To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.  <img src=\"assets/keyAndSecretExample.png\">  ## Generate a Token To interact with the API you first have to generate an OAuth token. This requires the following parameters: * `client_key` * `client_secret` * `grant-type` must be set to `client_credentials`  You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:  ```bash curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\   -d 'grant_type=client_credentials' \\   -H 'Content-Type: application/x-www-form-urlencoded' \\   -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw==' ```  The request will return a JSON response that contains an `access_token` key:  ```json {     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",     \"expires_in\":3600,     \"refresh_expires_in\":604800,     \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",     \"token_type\":\"bearer\",     \"not-before-policy\":0,     \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\" } ```  Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.  ## Make authenticated requests To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request: `Authorization: Bearer {access_token}`:  ```bash curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\   -H 'Authorization: Bearer {access_token}' \\   -H 'Content-Type: application/json' ```  ## Select a Product Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**: > Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**  Here are a few examples:  | pod_package_id | Description | | --- | --- | | `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping | | `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil| | `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover | | `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |  For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.  ## Create a Print-Job Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:  * `line_items` **(required)**: the list of books that shall be printed * `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number. * `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer * `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:     * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.     * `PRIORITY_MAIL` - priority mail shipping     * `GROUND` - Courier based shipping using ground transportation in the US.     * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent     * `EXPRESS` - overnight delivery. Fastest shipping available. * `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)  The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used. If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.  You can find the detailed documentation for [Creating a new Print-Job](#) below.  ## Check Print-Job Status After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:  <img src=\"assets/print-job-stages.svg\">  * **CREATED**: Print-Job created * **UNPAID**: Print-Job can be paid * **PAYMENT_IN_PROGRESS**: Payment is in Progress * **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay. * **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly. * **IN_PRODUCTION**: Print-Job submitted to printer * **SHIPPED**: Print-Job is fully shipped  There are a few more status that can occur when there is a problem with the Print-Job: * **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue. * **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.  ## Shipping Notification Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint. 

OpenAPI spec version: 1.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 3.3.4

=end

require 'date'

module Lulu
  # A shipping option defines a concrete shipping configuration that an order can be shipped with
  class ShippingOption
    attr_accessor :id

    attr_accessor :level

    # Support of delivery to postboxes
    attr_accessor :postbox_ok

    # Delivery also on non working days
    attr_accessor :home_only

    # Delivery only on working days
    attr_accessor :business_only

    # If this shipping provides the possibility to create a tracking link
    attr_accessor :traceable

    # Average transit time in days
    attr_accessor :transit_time

    # Production related delay
    attr_accessor :shipping_buffer

    # The shipping cost excluding taxes as a decimal string. This attribute will only be set on the detail endpoint representation, and only if the query parameters 'quantity' and 'currency' are provided
    attr_accessor :cost_excl_tax

    # Currency of `cost_excl_tax`
    attr_accessor :currency

    # Earliest estimated dispatch ( handover to carrier ) date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format
    attr_accessor :min_dispatch_date

    # Latest estimated dispatch ( handover to carrier ) date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format
    attr_accessor :max_dispatch_date

    # Earliest estimated delivery date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format
    attr_accessor :min_delivery_date

    # Latest estimated delivery date in ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) format
    attr_accessor :max_delivery_date

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
        :'level' => :'level',
        :'postbox_ok' => :'postbox_ok',
        :'home_only' => :'home_only',
        :'business_only' => :'business_only',
        :'traceable' => :'traceable',
        :'transit_time' => :'transit_time',
        :'shipping_buffer' => :'shipping_buffer',
        :'cost_excl_tax' => :'cost_excl_tax',
        :'currency' => :'currency',
        :'min_dispatch_date' => :'min_dispatch_date',
        :'max_dispatch_date' => :'max_dispatch_date',
        :'min_delivery_date' => :'min_delivery_date',
        :'max_delivery_date' => :'max_delivery_date'
      }
    end

    # Attribute type mapping.
    def self.openapi_types
      {
        :'id' => :'Float',
        :'level' => :'String',
        :'postbox_ok' => :'BOOLEAN',
        :'home_only' => :'BOOLEAN',
        :'business_only' => :'BOOLEAN',
        :'traceable' => :'BOOLEAN',
        :'transit_time' => :'Float',
        :'shipping_buffer' => :'Float',
        :'cost_excl_tax' => :'String',
        :'currency' => :'String',
        :'min_dispatch_date' => :'String',
        :'max_dispatch_date' => :'String',
        :'min_delivery_date' => :'String',
        :'max_delivery_date' => :'String'
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

      if attributes.has_key?(:'level')
        self.level = attributes[:'level']
      else
        self.level = 'MAIL'
      end

      if attributes.has_key?(:'postbox_ok')
        self.postbox_ok = attributes[:'postbox_ok']
      else
        self.postbox_ok = false
      end

      if attributes.has_key?(:'home_only')
        self.home_only = attributes[:'home_only']
      else
        self.home_only = false
      end

      if attributes.has_key?(:'business_only')
        self.business_only = attributes[:'business_only']
      else
        self.business_only = false
      end

      if attributes.has_key?(:'traceable')
        self.traceable = attributes[:'traceable']
      else
        self.traceable = false
      end

      if attributes.has_key?(:'transit_time')
        self.transit_time = attributes[:'transit_time']
      else
        self.transit_time = 0
      end

      if attributes.has_key?(:'shipping_buffer')
        self.shipping_buffer = attributes[:'shipping_buffer']
      else
        self.shipping_buffer = 0
      end

      if attributes.has_key?(:'cost_excl_tax')
        self.cost_excl_tax = attributes[:'cost_excl_tax']
      end

      if attributes.has_key?(:'currency')
        self.currency = attributes[:'currency']
      end

      if attributes.has_key?(:'min_dispatch_date')
        self.min_dispatch_date = attributes[:'min_dispatch_date']
      end

      if attributes.has_key?(:'max_dispatch_date')
        self.max_dispatch_date = attributes[:'max_dispatch_date']
      end

      if attributes.has_key?(:'min_delivery_date')
        self.min_delivery_date = attributes[:'min_delivery_date']
      end

      if attributes.has_key?(:'max_delivery_date')
        self.max_delivery_date = attributes[:'max_delivery_date']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @id.nil?
        invalid_properties.push('invalid value for "id", id cannot be nil.')
      end

      if @level.nil?
        invalid_properties.push('invalid value for "level", level cannot be nil.')
      end

      if @postbox_ok.nil?
        invalid_properties.push('invalid value for "postbox_ok", postbox_ok cannot be nil.')
      end

      if @home_only.nil?
        invalid_properties.push('invalid value for "home_only", home_only cannot be nil.')
      end

      if @business_only.nil?
        invalid_properties.push('invalid value for "business_only", business_only cannot be nil.')
      end

      if @traceable.nil?
        invalid_properties.push('invalid value for "traceable", traceable cannot be nil.')
      end

      if @transit_time.nil?
        invalid_properties.push('invalid value for "transit_time", transit_time cannot be nil.')
      end

      if @shipping_buffer.nil?
        invalid_properties.push('invalid value for "shipping_buffer", shipping_buffer cannot be nil.')
      end

      if @min_delivery_date.nil?
        invalid_properties.push('invalid value for "min_delivery_date", min_delivery_date cannot be nil.')
      end

      if @max_delivery_date.nil?
        invalid_properties.push('invalid value for "max_delivery_date", max_delivery_date cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @id.nil?
      return false if @level.nil?
      level_validator = EnumAttributeValidator.new('String', ['MAIL', 'PRIORITY_MAIL', 'GROUND_HD', 'GROUND_BUS', 'GROUND', 'EXPEDITED', 'EXPRESS'])
      return false unless level_validator.valid?(@level)
      return false if @postbox_ok.nil?
      return false if @home_only.nil?
      return false if @business_only.nil?
      return false if @traceable.nil?
      return false if @transit_time.nil?
      return false if @shipping_buffer.nil?
      return false if @min_delivery_date.nil?
      return false if @max_delivery_date.nil?
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] level Object to be assigned
    def level=(level)
      validator = EnumAttributeValidator.new('String', ['MAIL', 'PRIORITY_MAIL', 'GROUND_HD', 'GROUND_BUS', 'GROUND', 'EXPEDITED', 'EXPRESS'])
      unless validator.valid?(level)
        fail ArgumentError, 'invalid value for "level", must be one of #{validator.allowable_values}.'
      end
      @level = level
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          id == o.id &&
          level == o.level &&
          postbox_ok == o.postbox_ok &&
          home_only == o.home_only &&
          business_only == o.business_only &&
          traceable == o.traceable &&
          transit_time == o.transit_time &&
          shipping_buffer == o.shipping_buffer &&
          cost_excl_tax == o.cost_excl_tax &&
          currency == o.currency &&
          min_dispatch_date == o.min_dispatch_date &&
          max_dispatch_date == o.max_dispatch_date &&
          min_delivery_date == o.min_delivery_date &&
          max_delivery_date == o.max_delivery_date
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [id, level, postbox_ok, home_only, business_only, traceable, transit_time, shipping_buffer, cost_excl_tax, currency, min_dispatch_date, max_dispatch_date, min_delivery_date, max_delivery_date].hash
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
