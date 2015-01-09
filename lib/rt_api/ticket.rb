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

    def initialize(ticket_id)
      ticket_id = ticket_id.to_i unless ticket_id.is_a?(Fixnum)
      @id = ticket_id
    end

    def parse_basic_ticket_data(data_string)
      elements = data_string.split("\n").reject(&:empty?)[1..-1]
      custom_attrs, base_attrs = elements.partition { |e| e =~ /\ACF\.\{(.*)\}:(.*)\z/i }
      element_hash = base_attrs.inject({}) do |result, el|
        key, value = el.split(':')
        result["@#{key.underscore}"] = value ? value.strip : nil
        result
      end.except(:id)
      update_attributes(element_hash)
    end

    private

      def update_attributes(attribute_hash)
        attribute_hash.each_pair do |att, val|
          instance_variable_set(att, val)
        end
      end
  end
end

