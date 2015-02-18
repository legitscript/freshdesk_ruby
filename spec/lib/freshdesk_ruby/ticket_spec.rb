require 'spec_helper'

describe Freshdesk::Ticket do
  let(:response_body) do
    path = File.join('spec', 'support', 'responses', 'ticket.json')
    full_path = File.expand_path(path)
    File.read(full_path)
  end

  let(:parsed_data) { JSON.parse(response_body)['helpdesk_ticket'] }

  let(:ticket) { described_class.new(parsed_data) }

  let(:endpoint) { Freshdesk::Endpoint.new }

  let(:request_body) { Freshdesk::RequestBody.new }

  it 'has methods mapping to JSON response fields' do
    expect(ticket).to respond_to(:notes)
    expect(ticket).to respond_to(:requester_id)
    expect(ticket).to respond_to(:subject)
    expect(ticket).to respond_to(:responder_name)
  end

  describe '.find' do
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
      ticket = described_class.find(ticket_id)
      expect(ticket).to be_a(described_class)
    end

    context 'when the response code is not 2xx' do
      before do
        stub_request(:get, endpoint.ticket_path(ticket_id))
          .to_return(status: 404, body: '{}')
      end

      it 'raises a Freshdesk::Response error' do
        expect { described_class.find(ticket_id) }.to raise_error
      end
    end
  end

  describe '.all' do
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
      tickets = described_class.all
      full_of_tickets = tickets.all? { |t| t.is_a?(described_class) }
      expect(full_of_tickets).to eq(true)
    end

    context 'when given params' do
      before do
        stub_request(:get, endpoint.tickets_path(page: 3))
          .to_return(status: 200, body: response_body, headers: {})
      end

      it 'adds those parameters to the query string' do
        described_class.all(page: 3)
        expect(WebMock)
          .to have_requested(:get, endpoint.tickets_path(page: 3))
      end
    end
  end

  describe '#find_all' do
    let(:filepath) do
      path = File.join('spec', 'support', 'responses', 'ticket.json')
      File.expand_path(path)
    end

    let(:response_body) { File.read(filepath) }

    before(:each) do
      expect(described_class).to receive(:all).and_return(
        [
          described_class.new("id" => 50000, "display_id" => 5),
          described_class.new("id" => 60000, "display_id" => 6)
        ]
      )

      stub_request(:get, /freshdesk/).to_return(status: 200, body: response_body)
    end

    after(:all) do
      Typhoeus::Expectation.clear
    end

    subject { described_class.find_all }

    it "looks up tickets in parallel using Typhoeus" do
      expect(subject.size).to eq(2)
    end
  end

  describe '.create' do
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
      ticket = described_class.create(body)
      expect(ticket).to be_a(described_class)
    end
  end

  describe '.destroy' do
    let(:ticket_id) { 10 }

    before do
      stub_request(:delete, endpoint.ticket_path(ticket_id))
        .to_return(status: 200, body: '"deleted"')
    end

    context 'when successful' do
      it 'returns true' do
        is_deleted = described_class.destroy(ticket_id)
        expect(is_deleted).to eq(true)
      end
    end
  end

  describe '.update' do
    let(:ticket_id) { 10 }

    let(:fields_to_update) do
      {
        priority: 1,
        status: 2
      }
    end

    let(:filepath) do
      path = File.join('spec', 'support', 'responses', 'update_ticket.json')
      File.expand_path(path)
    end

    let(:response_body) do
      File.read(filepath)
    end

    before do
      stub_request(:put, endpoint.ticket_path(ticket_id))
        .to_return(status: 200, body: response_body)
    end

    it 'returns an updated ticket' do
      updated = described_class.update(ticket_id, fields_to_update)
      expect(updated.priority_name).to eq('High')
      expect(updated.status_name).to eq('Pending')
    end
  end

  describe '#add_note' do
    let(:body) do
      {
        body: 'Some details on the issue...',
        email: 'tom@outerspace.com',
        private: false
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
      ticket = described_class.create(body)
      expect(ticket).to be_a(described_class)
    end
  end

  describe '#initialize' do
    it 'makes contained notes into Freshdesk::Note instances' do
      all_notes = ticket.notes.all? { |note| note.class <= Freshdesk::Note }
      expect(all_notes).to be(true)
    end
  end
end
