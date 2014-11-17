module Freshdesk
  #
  class Client
    attr_reader :client, :endpoint, :request_body

    def initialize
      @endpoint = Freshdesk::Endpoint.new
      @request_body = Freshdesk::RequestBody.new
      @client = HTTPClient.new
    end

    def ticket(id)
      url = endpoint.ticket_path(id)
      response = get_request(url)
      body = JSON.parse(response.body)
      ticket = body['helpdesk_ticket']
      Ticket.new(ticket)
    end

    def tickets(options = {})
      url = endpoint.tickets_path(options)
      response = get_request(url)
      body = JSON.parse(response.body)
      body.map { |ticket| Ticket.new(ticket) }
    end

    def create_ticket(body)
      req_body = request_body.ticket_body(body)
      url = endpoint.tickets_path
      response = post_request(url, req_body)
      body = JSON.parse(response.body)
      ticket = body['helpdesk_ticket']
      Ticket.new(ticket)
    end

    private

    def get_request(url)
      client.get(url, nil, endpoint.request_headers)
    end

    def post_request(url, body)
      client.post(url, body, endpoint.request_headers)
    end
  end
end
