module Freshdesk
  #
  class RequestBody
    def ticket_body(body)
      {
        helpdesk_ticket: body
      }.to_json
    end

    def note_body(user_id, body, priv=false)
      {
        helpdesk_note: {
          body: body,
          user_id: user_id,
          private: priv
        }
      }.to_json
    end

    def user_body(name, email)
      {
        user: {
          name: name,
          email: email
        }
      }.to_json
    end
  end
end
