require 'spec_helper'

describe Freshdesk::TicketField do
  let(:endpoint) { Freshdesk::Endpoint.new }

  describe '.all' do
    let(:filepath) do
      path = File.join('spec', 'support', 'responses', 'ticket_fields.json')
      File.expand_path(path)
    end

    let(:response_body) { File.read(filepath) }

    before do
      stub_request(:get, endpoint.ticket_fields_path)
        .to_return(status: 200, body: response_body)
    end

    it 'returns an array of Freshdesk::Field objects' do
      fields = described_class.all
      full_of_fields = fields.all? { |f| f.is_a?(described_class) }
      expect(full_of_fields).to eq(true)
    end
  end
end
