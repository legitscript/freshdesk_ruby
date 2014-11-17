require 'spec_helper'

describe Freshdesk::Base do
  let(:endpoint) { Freshdesk::Endpoint.new }

  describe '.response_error' do
    context 'when successful' do
      let(:filepath) do
        path = File.join('spec', 'support', 'responses', 'ticket.json')
        File.expand_path(path)
      end

      let(:response_body) { File.read(filepath) }

      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 200, body: response_body)
      end

      it 'returns nil' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_nil
      end
    end

    context 'when authentication fails' do
      let(:response_body) { '{ "require_login": true }' }

      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 200, body: response_body)
      end

      it 'returns a Freshdesk::ResponseError' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_a(Freshdesk::ResponseError)
      end
    end

    context 'when the response code is not in the 2xx class' do
      before do
        stub_request(:get, endpoint.tickets_path)
          .to_return(status: 404, body: '{}')
      end

      it 'returns a Freshdesk::ResponseError' do
        response = described_class.get_request(endpoint.tickets_path)
        object = described_class.response_error(response)
        expect(object).to be_a(Freshdesk::ResponseError)
      end
    end
  end
end
