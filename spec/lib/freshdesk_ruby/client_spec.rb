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

    describe '#all_tickets' do
      let(:filepath) do
        path = File.join('spec', 'support', 'responses', 'tickets.json')
        File.expand_path(path)
      end
      let(:response_body) { File.read(filepath) }

      before do
        stub_request(:get, endpoint.tickets_path)
           .to_return(status: 200, body: response_body, headers: {})
      end

      it 'returns an array of tickets' do
        tickets = client.all_tickets
        full_of_tickets = tickets.all? { |t| t.is_a?(Freshdesk::Ticket) }
        expect(full_of_tickets).to eq(true)
      end

      context 'when given params' do
        before do
          stub_request(:get, endpoint.tickets_path(page: 3))
             .to_return(status: 200, body: response_body, headers: {})
        end

        it 'adds those parameters to the query string' do
          client.all_tickets(page: 3)
          expect(WebMock)
            .to have_requested(:get, endpoint.tickets_path(page: 3))
        end
      end
    end
  end
end
