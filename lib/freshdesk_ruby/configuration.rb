module Freshdesk
  #
  class Configuration
    attr_accessor :api_key, :password, :username
    attr_reader :base_endpoint, :subdomain, :protocol

    def initialize
      @protocol = 'https'
      @subdomain = 'www'
      @api_key = ''
      @password = 'X'
      @username = ''
      @base_endpoint = base_path
    end

    def subdomain=(value)
      @subdomain = value
      reset_base_endpoint
    end

    def protocol=(value)
      @protocol = value
      reset_base_endpoint
    end

    def reset_base_endpoint
      @base_endpoint = base_path
    end

    def base_path
      "#{protocol}://#{subdomain}freshdesk.com"
    end
  end
end
