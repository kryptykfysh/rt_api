# encoding: utf-8

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

    def initialize(options_hash = {})
      self.class.environment_var_to_attribute_map.each_pair do |attribute, env_var|
        instance_variable_set("@#{attribute}", options_hash[attribute] || ENV["rt_api_#{env_var}"])
      end
    end
  end
end
