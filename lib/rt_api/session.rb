# encoding: utf-8

require_relative 'connection'
require 'rest-client'

module RTApi
  class Session
    attr_reader :connection, :current_ticket

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

    def get_ticket(ticket_id)
      @current_ticket = RTApi::Ticket.new(ticket_id)
      set_basic_ticket_data
      @current_ticket
    end

    def set_basic_ticket_data
      @current_ticket.parse_basic_ticket_data(RestClient::Request.execute(
        url: "#{connection.full_path}ticket/#{@current_ticket.id}/show",
        method: :get,
        user: connection.username,
        password: connection.password,
        verify_ssl: false,
        content_type: :json,
        accept: :json
      ))
      @current_ticket
    end
  end
end
