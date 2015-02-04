module Freshdesk
  #
  class Ticket < Freshdesk::Base
    class << self
      def find(id)
        url = endpoint.ticket_path(id)
        response = get_request(url)
        with_error_handling(response) do |parsed|
          new(parsed['helpdesk_ticket'])
        end
      end

      def all(options = {})
        url = endpoint.tickets_path(options)
        response = get_request(url)
        with_error_handling(response) do |parsed|
          parsed.map { |ticket| new(ticket) }
        end
      end

      def create(body)
        req_body = request_body.ticket_body(body)
        url = endpoint.tickets_path
        response = post_request(url, req_body)
        with_error_handling(response) do |parsed|
          new(parsed['helpdesk_ticket'])
        end
      end

      def update(id, body)
        req_body = request_body.ticket_body(body)
        url = endpoint.ticket_path(id)
        response = put_request(url, req_body)
        with_error_handling(response) do |parsed|
          new(parsed['ticket'])
        end
      end

      def destroy(id)
        url = endpoint.ticket_path(id)
        response = delete_request(url)
        response.body == '"deleted"'
      end

      def add_note(ticket_id, user_id, body)
        req_body = request_body.note_body(user_id, body)
        url = endpoint.ticket_note_path(ticket_id)
        response = post_request(url, req_body)
        with_error_handling(response) do |parsed|
          Note.new(parsed['note'])
        end
      end
    end
  end
end
