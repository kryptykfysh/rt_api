# encoding: utf-8

require 'rest-client'

module RTApi
  class Connection

    @environment_var_to_attribute_map = {
      username:   'user',
      password:   'pass',
      base_url:   'url'
    }

    class << self
      attr_reader :environment_var_to_attribute_map
    end

    @environment_var_to_attribute_map.keys.each do |attribute|
      attr_reader attribute
    end
    attr_reader :path

    def initialize(options_hash = {})
      begin
        set_attributes(options_hash)
        @path = options_hash[:path] || ENV['rt_api_path'] || RTApi::DEFAULT_PATH
        raise RTApi::ConnectionError.new('The connection arguments are invalid.') unless self.valid?
      rescue RTApi::ConnectionError => e
        false
      end
    end

    def full_path
      @base_url + @path
    end

    def valid?
      begin
        response = RestClient::Request.execute(
          url:        full_path,
          method:     :get,
          user:       @username,
          password:   @password,
          verify_ssl: false
        )
      rescue
        return false
      end
      response == "RT/3.8.2 200 Ok\n\n# Invalid object specification: 'index.html'\n\nid: index.html\n\n"
    end

    private

      def set_attributes(options_hash)
        self.class.environment_var_to_attribute_map.each_pair do |attribute, env_var|
          instance_variable_set("@#{attribute}", options_hash[attribute] || ENV["rt_api_#{env_var}"] || nil)

          # Trim any trailing '/' from the @base_url attribute
          if attribute == :base_url && !@base_url.nil? && @base_url[-1] == '/'
            instance_variable_set('@base_url', @base_url[0..-2])
          end
        end
      end
  end
end
