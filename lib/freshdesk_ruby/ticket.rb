module Freshdesk
  #
  class Ticket < Freshdesk::Base
    class << self
      def find(id)
        url = endpoint.ticket_path(id)
        response = get_request(url)
        create_from_response(response.body)
      end

      def all(options = {})
        url = endpoint.tickets_path(options)
        response = get_request(url)
        create_from_response(response.body)
      end

      def create(body)
        req_body = request_body.ticket_body(body)
        url = endpoint.tickets_path
        response = post_request(url, req_body)
        create_from_response(response.body)
      end

      def create_from_response(response_body)
        parsed = JSON.parse(response_body)
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
