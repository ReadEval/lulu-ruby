=begin
#Universal Publishing Platform API

## Getting Started The Lulu Print API allows you to use [Lulu](https://www.lulu.com/) as your production and fulfillment network. The API provides access the same functionality that Lulu uses internally to normalize files and send Print-Jobs to our production partners around the world.  The Lulu Print API is a **RESTful API** that communicates with JSON encoded messages. Communication is secured with **OpenID Connect** and **transport layer security** (HTTPS).  Working with the API requires intermediate level programming skills and a general understanding of web APIs. Take a look at **[Lulu xPress](https://xpress.lulu.com)** if you want to check out Lulu's services without having to do technical work upfront.   ## Registration You have to create an account to start using the Lulu Print API. Your account will automatically receive a client-key and a client-secret.  ## Sandbox Environment The API is available in a production and a sandbox environment. The sandbox can be used for development and testing purposes. Print-Jobs created on the sandbox will never be forwarded to a real production and can be paid for with test credit cards.  To access the sandbox, you have to create a separate account at https://developers.sandbox.lulu.com/. The sandbox API URL is https://api.sandbox.lulu.com/  ## Authorization The Lulu API uses [OpenID Connect](https://en.wikipedia.org/wiki/OpenID_Connect), an authentication layer built on top of [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth). Instead of exchanging username and password, the API uses [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) to authorize client requests.  To interact with the API you need a **client-key** and a **client-secret**. Open the [Client Keys & Secret](/user-profile/api-keys) page to generate them.  <img src=\"assets/keyAndSecretExample.png\">  ## Generate a Token To interact with the API you first have to generate an OAuth token. This requires the following parameters: * `client_key` * `client_secret` * `grant-type` must be set to `client_credentials`  You have to send a POST request to the token endpoint a special Authorization header. For your convenience, you can copy the authorization string directly from your [API Keys](https://developers.lulu.com/user-profile/api-keys) page:  ```bash curl -X POST https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token \\   -d 'grant_type=client_credentials' \\   -H 'Content-Type: application/x-www-form-urlencoded' \\   -H 'Authorization: Basic ZjJjNDdmMTctOWMxZi00ZWZlLWIzYzEtMDI4YTNlZTRjM2M3OjMzOTViZGU4LTBkMjQtNGQ0Ny1hYTRjLWM4NGM3NjI0OGRiYw==' ```  The request will return a JSON response that contains an `access_token` key:  ```json {     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkI...\",     \"expires_in\":3600,     \"refresh_expires_in\":604800,     \"refresh_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6...\",     \"token_type\":\"bearer\",     \"not-before-policy\":0,     \"session_state\":\"a856fb91-eafc-460e-8f6a-f09325062c88\" } ```  Store this `access_token` and use it to authorize all further requests. The token will expire after a few minutes, but you can always request a fresh token from the server as outlined above. We recommend to use an OAuth capable client lib in your favorite programming language to simplify working with client credentials and tokens. Some might even automatically refresh your token after it expired.  ## Make authenticated requests To authenticate subsequent API requests, you must provide a valid access token in the HTTP header of the request: `Authorization: Bearer {access_token}`:  ```bash curl -X GET https://api.lulu.com/{some_api_endpoint}/ \\   -H 'Authorization: Bearer {access_token}' \\   -H 'Content-Type: application/json' ```  ## Select a Product Lulu’s Print API offers a wide range of products. Each product is represented by a 27 character code call **pod_package_id**: > Trim Size + Color + Print Quality + Bind + Paper + PPI + Finish + Linen + Foil = **pod_package_id**  Here are a few examples:  | pod_package_id | Description | | --- | --- | | `0850X1100BWSTDLW060UW444MNG` | `0850X1100`: trim size 8.5” x 11”<br>`BW`: black-and-white<br>`STD`: standard quality <br>`LW`: linen wrap binding<br>`060UW444`: 60# uncoated white paper with a bulk of 444 pages per inch <br>`M`: matte cover coating <br>`N`: navy colored linen<br>`G`: golden foil stamping | | `0600X0900FCSTDPB080CW444GXX` | `0600X0900`: trim size 6” x 9” <br>`FC`: full color<br>`STD`: standard quality<br>`PB`: perfect binding<br>`080CW444`: 80# coated white paper with a bulk of 444 ppi<br>`G`: gloss cover coating<br>`X`: no linen<br>`X`: no foil| | `0700X1000FCPRECO060UC444MXX` | 7\" x 10\" black-and-white premium coil-bound book printed on 60# cream paper with a matte cover | | `0600X0900BWSTDPB060UW444MXX` | 6\" x 9\" black-and-white standard quality paperback book printed on 60# white paper with a matte cover |  For a full listing of Lulu SKUs and product specification, download the [Product Specification Sheet](https://developers.lulu.com/assets/files/Lulu_Print_API_Spec_Sheet_11092018.xlsx). Also, please download and review our [Production Templates](https://developers.lulu.com/products-and-shipping#production-templates) for additional guidance with formatting and file preparation. If you have general questions about which Lulu products are right for your business, please [contact one of our experts](https://developers.lulu.com/contact-us) through our Technical Support form.  ## Create a Print-Job Now you can start to create Print-Jobs. A Print-Job request consists of at least three data fields:  * `line_items` **(required)**: the list of books that shall be printed * `shipping_address` **(required)**: the (end) customer’s address where Lulu should send the books - including a phone number. * `contact_email` **(required)**: an email address for questions regarding the Print-Job - normally, you want to use the email address of a developer or shop owner, not the end customer * `shipping_option_level`**(required)**: Lulu offers five different quality levels for shipping:     * `MAIL` - Slowest ship method. Depending on the destination, tracking might not be available.     * `PRIORITY_MAIL` - priority mail shipping     * `GROUND` - Courier based shipping using ground transportation in the US.     * `EXPEDITED` - expedited (2nd day) delivery via air mail or equivalent     * `EXPRESS` - overnight delivery. Fastest shipping available. * `external_id` (optional): a reference number to link the Print-Job to your system (e.g. your order number)  The **shipping address must contain a phone number**. This is required by our shipping carriers. If the shipping address does not contain a phone number, the default phone number from the account will be used. If neither the account nor the shipping address contain a phone number, the Print-Job can not be created.  You can find the detailed documentation for [Creating a new Print-Job](#) below.  ## Check Print-Job Status After sending a Print-Job, you can check its status. Normally, a Print-Job goes through the following stages:  <img src=\"assets/print-job-stages.svg\">  * **CREATED**: Print-Job created * **UNPAID**: Print-Job can be paid * **PAYMENT_IN_PROGRESS**: Payment is in Progress * **PRODUCTION_DELAYED**: Print-Job is paid and will move to production after the mandatory production delay. * **PRODUCTION_READY**: Production delay has ended and the Print-Job will move to \"in production\" shortly. * **IN_PRODUCTION**: Print-Job submitted to printer * **SHIPPED**: Print-Job is fully shipped  There are a few more status that can occur when there is a problem with the Print-Job: * **REJECTED**: When there is a problem with the input data or the file, Lulu will reject a Print-Job with a detailed error message. Please [contact our experts](https://developers.lulu.com/contact-us) if you need help in resolving this issue. * **CANCELED**: You can cancel a Print-Job as long as it is not “in production” with an API request to the status endpoint. In rare cases, Lulu might also cancel a Print-Job if a problem has surfaced in production and the order cannot be fulfilled.  ## Shipping Notification Once an order has been shipped, Lulu will provide tracking information in the Print-Job endpoint. 

OpenAPI spec version: 1.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 3.3.4

=end

require 'date'

module Lulu
  # A basic address format that holds address related data for individuals or organizations.
  class PrintjobsShippingAddress
    attr_accessor :title

    # Name of an organization. Required if no person name is given.
    attr_accessor :organization

    # First address line
    attr_accessor :street1

    # Second address line
    attr_accessor :street2

    attr_accessor :city

    # 2 or 3 letter state codes (officially called [ISO-3166-2 subdivision codes](https://en.wikipedia.org/wiki/ISO_3166-2)). They are required for some countries (e.g. US, MX, CA, AU)
    attr_accessor :state_code

    # [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) country code
    attr_accessor :country_code

    # Required for most countries
    attr_accessor :postcode

    # Shipping carriers require a phone number for handling delivery issues. If no phone number is given, the default default in the API user profile will be used. Validation Regex Pattern for phone numbers `^\\+?[\\d\\s\\-./()]{8,20}$` 
    attr_accessor :phone_number

    # Shipping carriers require an email address for notifications or handling delivery issues. If no phone number is given, the default email in the user profile will be used. 
    attr_accessor :email

    # Only relevant for US addresses. Some US carriers don't deliver to business-addresses on Saturday.
    attr_accessor :is_business

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
        :'title' => :'title',
        :'organization' => :'organization',
        :'street1' => :'street1',
        :'street2' => :'street2',
        :'city' => :'city',
        :'state_code' => :'state_code',
        :'country_code' => :'country_code',
        :'postcode' => :'postcode',
        :'phone_number' => :'phone_number',
        :'email' => :'email',
        :'is_business' => :'is_business'
      }
    end

    # Attribute type mapping.
    def self.openapi_types
      {
        :'title' => :'String',
        :'organization' => :'String',
        :'street1' => :'String',
        :'street2' => :'String',
        :'city' => :'String',
        :'state_code' => :'String',
        :'country_code' => :'String',
        :'postcode' => :'String',
        :'phone_number' => :'String',
        :'email' => :'String',
        :'is_business' => :'BOOLEAN'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'title')
        self.title = attributes[:'title']
      end

      if attributes.has_key?(:'organization')
        self.organization = attributes[:'organization']
      end

      if attributes.has_key?(:'street1')
        self.street1 = attributes[:'street1']
      end

      if attributes.has_key?(:'street2')
        self.street2 = attributes[:'street2']
      end

      if attributes.has_key?(:'city')
        self.city = attributes[:'city']
      end

      if attributes.has_key?(:'state_code')
        self.state_code = attributes[:'state_code']
      end

      if attributes.has_key?(:'country_code')
        self.country_code = attributes[:'country_code']
      end

      if attributes.has_key?(:'postcode')
        self.postcode = attributes[:'postcode']
      end

      if attributes.has_key?(:'phone_number')
        self.phone_number = attributes[:'phone_number']
      end

      if attributes.has_key?(:'email')
        self.email = attributes[:'email']
      end

      if attributes.has_key?(:'is_business')
        self.is_business = attributes[:'is_business']
      else
        self.is_business = false
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @street1.nil?
        invalid_properties.push('invalid value for "street1", street1 cannot be nil.')
      end

      if @city.nil?
        invalid_properties.push('invalid value for "city", city cannot be nil.')
      end

      if @country_code.nil?
        invalid_properties.push('invalid value for "country_code", country_code cannot be nil.')
      end

      if @country_code.to_s.length > 2
        invalid_properties.push('invalid value for "country_code", the character length must be smaller than or equal to 2.')
      end

      if @country_code.to_s.length < 2
        invalid_properties.push('invalid value for "country_code", the character length must be great than or equal to 2.')
      end

      if @postcode.nil?
        invalid_properties.push('invalid value for "postcode", postcode cannot be nil.')
      end

      if @postcode.to_s.length > 64
        invalid_properties.push('invalid value for "postcode", the character length must be smaller than or equal to 64.')
      end

      if @phone_number.nil?
        invalid_properties.push('invalid value for "phone_number", phone_number cannot be nil.')
      end

      if @phone_number.to_s.length > 20
        invalid_properties.push('invalid value for "phone_number", the character length must be smaller than or equal to 20.')
      end

      if @email.nil?
        invalid_properties.push('invalid value for "email", email cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      title_validator = EnumAttributeValidator.new('String', ['MR', 'MISS', 'MRS', 'MS', 'DR'])
      return false unless title_validator.valid?(@title)
      return false if @street1.nil?
      return false if @city.nil?
      return false if @country_code.nil?
      return false if @country_code.to_s.length > 2
      return false if @country_code.to_s.length < 2
      return false if @postcode.nil?
      return false if @postcode.to_s.length > 64
      return false if @phone_number.nil?
      return false if @phone_number.to_s.length > 20
      return false if @email.nil?
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] title Object to be assigned
    def title=(title)
      validator = EnumAttributeValidator.new('String', ['MR', 'MISS', 'MRS', 'MS', 'DR'])
      unless validator.valid?(title)
        fail ArgumentError, 'invalid value for "title", must be one of #{validator.allowable_values}.'
      end
      @title = title
    end

    # Custom attribute writer method with validation
    # @param [Object] country_code Value to be assigned
    def country_code=(country_code)
      if country_code.nil?
        fail ArgumentError, 'country_code cannot be nil'
      end

      if country_code.to_s.length > 2
        fail ArgumentError, 'invalid value for "country_code", the character length must be smaller than or equal to 2.'
      end

      if country_code.to_s.length < 2
        fail ArgumentError, 'invalid value for "country_code", the character length must be great than or equal to 2.'
      end

      @country_code = country_code
    end

    # Custom attribute writer method with validation
    # @param [Object] postcode Value to be assigned
    def postcode=(postcode)
      if postcode.nil?
        fail ArgumentError, 'postcode cannot be nil'
      end

      if postcode.to_s.length > 64
        fail ArgumentError, 'invalid value for "postcode", the character length must be smaller than or equal to 64.'
      end

      @postcode = postcode
    end

    # Custom attribute writer method with validation
    # @param [Object] phone_number Value to be assigned
    def phone_number=(phone_number)
      if phone_number.nil?
        fail ArgumentError, 'phone_number cannot be nil'
      end

      if phone_number.to_s.length > 20
        fail ArgumentError, 'invalid value for "phone_number", the character length must be smaller than or equal to 20.'
      end

      @phone_number = phone_number
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          title == o.title &&
          organization == o.organization &&
          street1 == o.street1 &&
          street2 == o.street2 &&
          city == o.city &&
          state_code == o.state_code &&
          country_code == o.country_code &&
          postcode == o.postcode &&
          phone_number == o.phone_number &&
          email == o.email &&
          is_business == o.is_business
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [title, organization, street1, street2, city, state_code, country_code, postcode, phone_number, email, is_business].hash
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
