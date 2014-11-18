#
module Freshdesk
  #
  class TicketField < Freshdesk::Base
    class << self
      def all
        url = endpoint.ticket_fields_path
        response = get_request(url)
        create_from_response(response)
      end

      def create_from_response(response)
        error = response_error(response)
        return error if error
        parsed = JSON.parse(response.body)
        parsed.map do |field|
          ticket_field = field['ticket_field']
          new(ticket_field)
        end
      end
    end
  end
end
