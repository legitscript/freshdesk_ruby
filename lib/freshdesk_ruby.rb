require 'bundler/setup'

require 'json'
require 'base64'
require 'httpclient'
require 'active_support/core_ext/hash'
require_relative 'freshdesk_ruby/configuration'

#
module Freshdesk
  def self.configuration
    @config ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require_relative 'freshdesk_ruby/base'
require_relative 'freshdesk_ruby/ticket'
require_relative 'freshdesk_ruby/endpoint'
require_relative 'freshdesk_ruby/request_body'
require_relative 'freshdesk_ruby/response_error'
