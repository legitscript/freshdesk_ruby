require 'spec_helper'

describe Freshdesk::Client do
  let(:client) { described_class.new }
  let(:endpoint) { Freshdesk::Endpoint.new }
  let(:request_body) { Freshdesk::RequestBody.new }

  describe 'ticket API' do
    describe '#ticket' do
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
        ticket = client.ticket(ticket_id)
        expect(ticket).to be_a(Freshdesk::Ticket)
      end
    end

    describe '#tickets' do
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
        tickets = client.tickets
        full_of_tickets = tickets.all? { |t| t.is_a?(Freshdesk::Ticket) }
        expect(full_of_tickets).to eq(true)
      end

      context 'when given params' do
        before do
          stub_request(:get, endpoint.tickets_path(page: 3))
             .to_return(status: 200, body: response_body, headers: {})
        end

        it 'adds those parameters to the query string' do
          client.tickets(page: 3)
          expect(WebMock)
            .to have_requested(:get, endpoint.tickets_path(page: 3))
        end
      end
    end

    describe '#create_ticket' do
      let(:body) do
        {
          subject: 'What is the sound of one hand clapping?',
          description: 'Some details on the issue...',
          email: 'tom@outerspace.com',
          priority: 1,
          status: 2
        }
      end

      let(:filepath) do
        path = File.join('spec', 'support', 'responses', 'ticket.json')
        File.expand_path(path)
      end

      let(:response_body) do
        File.read(filepath)
      end

      before do
        stub_request(:post, endpoint.tickets_path)
          .with(body: request_body.ticket_body(body))
          .to_return(status: 200, body: response_body)
      end

      it 'returns the ticket created in Freshdesk' do
        ticket = client.create_ticket(body)
        expect(ticket).to be_a(Freshdesk::Ticket)
      end
    end
  end
end
