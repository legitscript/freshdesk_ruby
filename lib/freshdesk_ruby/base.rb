module Freshdesk
  #
  class Base
    class << self
      def endpoint
        Freshdesk::Endpoint.new
      end

      def request_body
        Freshdesk::RequestBody.new
      end

      def client
        HTTPClient.new
      end

      def get_request(url)
        client.get(url, nil, endpoint.request_headers)
      end

      def post_request(url, body)
        client.post(url, body, endpoint.request_headers)
      end
    end

    def initialize(attributes)
      attributes.each do |(attr, value)|
        set_variable(attr, value) unless respond_to?(attr)
      end
    end

    def set_variable(attr, value)
      ivar = "@#{attr}"
      instance_variable_set(ivar, value)
      instance_eval "def #{attr}; @#{attr}; end"
    end
  end
end
