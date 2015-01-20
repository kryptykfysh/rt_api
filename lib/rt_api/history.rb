# encoding: utf-8

module RTApi
  class History
    attr_reader :id, :ticket_id, :time_taken, :type, :field, :old_value,
                :new_value, :data, :description, :content, :creator,
                :created_at, :attachments, :options

    def initialize(options = {})
      @options = options
      if options.fetch(:id, 'nope') =~ /\A\d+\z/
        @id = options[:id].to_i
      end
      if options.fetch(:ticket_id, 'nope') =~ /\A\d+\z/
        @ticket_id = options[:ticket_id].to_i
      end
      if options.fetch(:time_taken, '0') =~ /\A\d+\z/
        @time_taken = options[:time_taken].to_i
      end
      @created_at = options.fetch(:created_at, nil)
      unless @created_at.is_a?(Time)
        @created_at = (Time.parse(@created_at) rescue nil)
      end
      options.except(:id, :ticket_id, :time_taken, :created_at).each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
