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

    def history
      return @current_ticket.history unless @current_ticket.history.empty?
      @current_ticket.set_history(lookup_ticket_history(@current_ticket.id))
      @current_ticket.history
    end

    def add_comment(text:, ticket_id: @current_ticket.id)
      content_hash = {
        id:     ticket_id,
        Action: 'comment',
        Text:   text
      }

      RestClient::Request.execute(
        url: "#{connection.full_path}ticket/#{ticket_id}/comment",
        method: :post,
        user: connection.username,
        password: connection.password,
        payload:  { content: build_ticket_content(content_hash) },
        verify_ssl: false,
        content_type: :json,
        accept: :json
      )
      refresh_history
    end

    def add_correspondence(text:, ticket_id: @current_ticket.id)
      content_hash = {
        id:     ticket_id,
        Action: 'correspond',
        Text:   text
      }

      RestClient::Request.execute(
        url: "#{connection.full_path}ticket/#{ticket_id}/comment",
        method: :post,
        user: connection.username,
        password: connection.password,
        payload:  { content: build_ticket_content(content_hash) },
        verify_ssl: false,
        content_type: :json,
        accept: :json
      )
      refresh_history
    end

    def create_ticket(content)
      response = RestClient::Request.execute(
        url: "#{connection.full_path}ticket/new",
        method: :post,
        user: connection.username,
        password: connection.password,
        payload: { content: build_ticket_content(content, prefix: 'id: ticket/new') },
        verify_ssl: false,
        content_type: :json,
        accept: :json
      )
      ticket_id_regex = /Ticket\s+(\d+)\s+/
      get_ticket(response.scan(ticket_id_regex)[0][0].to_i)
    end

    def edit_ticket(field_hash:, ticket_id: @current_ticket.id)
      RestClient::Request.execute(
        url: "#{connection.full_path}ticket/#{ticket_id}/edit",
        method: :post,
        user: connection.username,
        password: connection.password,
        payload:  { content: build_ticket_content(field_hash) },
        verify_ssl: false,
        content_type: :json,
        accept: :json
      )
    end

    def get_ticket(ticket_id)
      @current_ticket = RTApi::Ticket.new(ticket_id)
      set_basic_ticket_data
      @current_ticket
    end

    def refresh_history
      @current_ticket.set_history(lookup_ticket_history(@current_ticket.id))
      history
    end

    def set_basic_ticket_data
      @current_ticket.set_basic_data(basic_ticket_data)
      @current_ticket
    end

    private

      def basic_ticket_data(ticket_id = nil)
        ticket_id ||= @current_ticket.id
        RestClient::Request.execute(
          url: "#{connection.full_path}ticket/#{ticket_id}/show",
          method: :get,
          user: connection.username,
          password: connection.password,
          verify_ssl: false,
          content_type: :json,
          accept: :json
        )
      end

      def build_ticket_content(content_hash, prefix: '')
        content = prefix
        content_hash.inject(content) do |result, (k, v)|
          result << ("\n#{k}: " +  (k == :Text ? v.gsub("\n", "\n ") : v.to_s))
          result
        end
      end

      def lookup_ticket_history(ticket_id = nil)
        ticket_id || @current_ticket.id
        RestClient::Request.execute(
          url: "#{connection.full_path}ticket/#{ticket_id}/history?format=l",
          method: :get,
          user: connection.username,
          password: connection.password,
          verify_ssl: false,
          content_type: :json,
          accept: :json
        )
      end
  end
end
