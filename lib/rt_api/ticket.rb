# encoding: utf-8

require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'

module RTApi
  class Ticket
    attr_reader :created, :creator, :due, :id, :final_priority, :initial_priority,
      :last_updated, :priority, :queue, :requestors, :resolved, :started,
      :starts, :status, :subject, :time_estimated, :time_left, :time_worked,
      :told, :admin_cc, :cc, :custom_fields

    CUSTOM_FIELD_REGEX = /\ACF\.\{(.*)\}:\s*(.*)\z/i

    def initialize(ticket_id)
      ticket_id = ticket_id.to_i unless ticket_id.is_a?(Fixnum)
      @id = ticket_id
    end

    def set_basic_data(raw_string)
      attribute_hash = parse_basic_data_string(raw_string)
      attribute_hash.each_pair do |k, v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end

    private

      def parse_basic_data_string(data_string)
        elements = data_string.split("\n").reject(&:empty?)[1..-1]
        custom_attrs, base_attrs = elements.partition { |e| e =~ CUSTOM_FIELD_REGEX }
        result = base_attrs.inject({}) do |res, el|
          key, value = el.split(':', 2).map(&:strip)
          res[key.underscore.to_sym] = string_to_type(value)
          res
        end.except(:id)
        result[:custom_fields] = custom_attrs.inject({}) do |res, el|
          key, value = el.match(CUSTOM_FIELD_REGEX).captures.map(&:strip)
          res[key.gsub(/\s+/, '').underscore.to_sym] = string_to_type(value)
          res
        end
        result
      end

      def string_to_type(string)
        return nil if (string.nil? || string == 'Not set' || string.empty?)
        begin
          Date.parse(string)
        rescue
          if string =~ /\A\d+\z/
            string.to_i
          else
            string
          end
        end
      end
  end
end

