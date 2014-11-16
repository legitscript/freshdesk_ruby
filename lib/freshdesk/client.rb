require 'httpclient'

module Freshdesk
  #
  class Client
    attr_reader :client, :endpoint

    def initialize
      @endpoint = Freshdesk::Endpoint.new
      @client = HTTPClient.new
    end

    def find_ticket(id)
      url = endpoint.ticket_path(id)
      response = get_request(url)
      body = JSON.parse(response.body)
      ticket = body['helpdesk_ticket']
      Ticket.new(ticket)
    end

    def all_tickets(options = {})
      url = endpoint.tickets_path(options)
      response = get_request(url)
      body = JSON.parse(response.body)
      body.map { |ticket| Ticket.new(ticket) }
    end

    private

    def get_request(url)
      client.get(url, nil, endpoint.request_headers)
    end
  end
end
