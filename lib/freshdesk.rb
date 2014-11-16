require 'json'
require 'base64'
require 'active_support/core_ext/hash'
require_relative 'freshdesk/configuration'

#
module Freshdesk
  def self.configuration
    @config ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require_relative 'freshdesk/base'
require_relative 'freshdesk/ticket'
require_relative 'freshdesk/endpoint'
require_relative 'freshdesk/client'
