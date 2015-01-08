# encoding: utf-8

require_relative 'connection'

module RTApi
  class Session
    attr_reader :connection

    def initialize(options = {})
      @connection = Connection.new(options.fetch(:connection, {}))
      raise RTApi::ConnectionError.new('The connection arguments are invalid.') unless @connection.valid?
    end
  end
end
