require 'spec_helper'

describe Freshdesk::Client do
  let(:client) { described_class.new }
  let(:endpoint) { Freshdesk::Endpoint.new }

  describe 'ticket API' do
    describe '#find_ticket' do
      let(:ticket_id) { 10 }
      let(:filepath) do
        path = File.join('spec', 'support', 'responses', 'ticket.json')
        File.expand_path(path)
      end
      let(:response_body) { File.read(filepath) }

      before do
        stub_request(:get, endpoint.ticket_path(ticket_id))
           .to_return(status: 200, body: response_body, headers: {})

      end

      it 'returns a single ticket with a given ID' do
        ticket = client.find_ticket(ticket_id)
        expect(ticket).to be_a(Freshdesk::Ticket)
      end
    end
  end
end
