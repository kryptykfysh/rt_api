# encoding: utf-8

require_relative 'connection'

module RTApi
  class Session
    attr_reader :connection

    # An RTApi::Session object creates an associated RTApi::Connection on
    # initialization. This requires that the connection information be provided
    # either in environment variables as per README, or in a :connection hash
    # in the options hash passed to the ::new method.
    # Example:
    #   RTApi::Session.new(
    #     { connection: {
    #                     username: 'blah',
    #                     password: 'blah',
    #                     base_url: 'http://rt.blah.com'
    #                    }
    #      }
    #    )
    def initialize(options = {})
      @connection = Connection.new(options.fetch(:connection, {}))
      raise(RTApi::ConnectionError.new('The connection arguments are invalid.')) unless @connection.valid?
    end
  end
end
