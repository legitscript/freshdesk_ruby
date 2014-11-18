require 'pry'
module Freshdesk
  #
  class Ticket < Freshdesk::Base
    class << self
      def find(id)
        url = endpoint.ticket_path(id)
        response = get_request(url)
        create_from_response(response)
      end

      def all(options = {})
        url = endpoint.tickets_path(options)
        response = get_request(url)
        create_from_response(response)
      end

      def create(body)
        req_body = request_body.ticket_body(body)
        url = endpoint.tickets_path
        response = post_request(url, req_body)
        create_from_response(response)
      end

      def destroy(id)
        url = endpoint.ticket_path(id)
        response = delete_request(url)
        response.body == '"deleted"'
      end

      def create_from_response(response)
        error = response_error(response)
        return error if error
        parsed = JSON.parse(response.body)
        if parsed.is_a?(Array)
          parsed.map { |ticket| Ticket.new(ticket) }
        else
          ticket = parsed['helpdesk_ticket']
          Ticket.new(ticket)
        end
      end
    end
  end
end
