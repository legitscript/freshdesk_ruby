module Freshdesk
  #
  class RequestBody
    def ticket_body(body)
      {
        helpdesk_ticket: body
      }.to_json
    end
  end
end
