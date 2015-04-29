module Freshdesk
  #
  class Base
    ERRORS = %w(require_login error errors access_denied)

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

      def put_request(url, body)
        client.put(url, body, endpoint.request_headers)
      end

      def delete_request(url)
        client.delete(url, nil, endpoint.request_headers)
      end

      def response_error(response)
        parsed = JSON.parse(response.body)
        if response.code.to_s !~ /2\d\d/
          Freshdesk::ResponseError.new(response)
        elsif contains_errors?(parsed)
          Freshdesk::ResponseError.new(response)
        end
      end

      def contains_errors?(parsed_response)
        return false unless parsed_response.is_a?(Hash)
        (parsed_response.keys & ERRORS).any?
      end

      def with_error_handling(response)
        error = response_error(response)
        raise error if error
        parsed = JSON.parse(response.body)
        yield parsed
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
