# encoding: utf-8

require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require_relative 'history'

module RTApi
  class Ticket
    attr_reader :created, :creator, :due, :id, :final_priority, :initial_priority,
      :last_updated, :priority, :queue, :requestors, :resolved, :started,
      :starts, :status, :subject, :time_estimated, :time_left, :time_worked,
      :told, :admin_cc, :cc, :custom_fields, :cached_history

    CUSTOM_FIELD_REGEX = /\ACF\.\{(.*)\}:\s*(.*)\z/i

    def initialize(ticket_id)
      ticket_id = ticket_id.to_i unless ticket_id.is_a?(Fixnum)
      @id = ticket_id
      @cached_history = []
    end

    def history
      @cached_history.empty? ? [] : @cached_history
    end

    def set_basic_data(raw_string)
      attribute_hash = parse_basic_data_string(raw_string)
      attribute_hash.each_pair do |k, v|
        instance_variable_set("@#{k.to_s.gsub('@', '').gsub('.', '_')}", v)
      end
    end

    def set_history(raw_string)
      @cached_history = parse_history_string(raw_string)
                          .map { |options| RTApi::History.new(options) }
                          .sort_by { |obj| obj.created_at }
    end

    private

      def parse_basic_data_string(data_string)
        elements = data_string.split("\n").reject(&:empty?)[1..-1]
        custom_attrs, base_attrs = elements.partition { |e| e =~ CUSTOM_FIELD_REGEX }
        current_key = nil
        result = base_attrs.inject({}) do |res, el|
          matches = el.match(/\A(?<key>\w+):\s*(?<value>.*)\z/)
          if matches
            current_key = matches[:key].underscore.to_sym
            res[current_key] = string_to_type(matches[:value].strip)
          else
            res[current_key] += "\n#{el}"
          end
          res
        end.except(:id)
        result[:custom_fields] = custom_attrs.inject({}) do |res, el|
          key, value = el.match(CUSTOM_FIELD_REGEX).captures.map(&:strip)
          res[key.gsub(/\s+/, '').underscore.to_sym] = string_to_type(value)
          res
        end
        result
      end

      def parse_history_string(raw_string)
        key_line_regex = /\A(?<key>\w+):\s*(?<value>.*)\z/

        raw_histories = raw_string.split("\n--\n").map { |x| x.split("\n")[4..-1].reject { |y| y.empty? } }
        raw_histories.inject([]) do |processed, raw|
          current_key = nil
          processed << raw.inject({}) do |history_hash, line|
            matches = line.match(key_line_regex)
            if matches
              new_key = matches[:key].underscore.to_sym
              current_key = new_key
              new_key = 'created_at'.to_sym if new_key == :created
              new_key = 'ticket_id'.to_sym if new_key == :ticket
              history_hash[new_key] = matches[:value]
            else
              history_hash[current_key] += "\n#{line}"
            end
            history_hash
          end
          processed
        end
      end

      def string_to_type(string)
        return nil if (string.nil? || string == 'Not set' || string.empty?)
        begin
          Time.parse(string)
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

