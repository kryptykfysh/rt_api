# encoding: utf-8

require_relative 'rt_api/version'
require_relative 'rt_api/ticket'
require_relative 'rt_api/connection'
require_relative 'rt_api/session'

module RTApi
  class ConnectionError < StandardError
  end

  DEFAULT_PATH = '/REST/1.0/'
end
