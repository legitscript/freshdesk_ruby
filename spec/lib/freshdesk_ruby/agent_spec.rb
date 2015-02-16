require 'spec_helper'

describe Freshdesk::Agent do
  let(:response_body) do
    path = File.join('spec', 'support', 'responses', 'list_of_agents.json')
    full_path = File.expand_path(path)
    File.read(full_path)
  end

  let(:parsed_data) { JSON.parse(response_body).first['agent'] }

  let(:agent) { described_class.new(parsed_data) }

  let(:endpoint) { Freshdesk::Endpoint.new }

  let(:request_body) { Freshdesk::RequestBody.new }

  it 'has methods mapping to JSON response fields' do
    expect(agent).to respond_to(:id)
  end

  it 'has a user within the agent object' do
    expect(agent.user).to be_a(Freshdesk::User)
  end

  describe '#find_by_email' do
    let(:agent_email) { 'mohan.zhang@legitscript.com' }

    let(:filepath) do
      path = File.join('spec', 'support', 'responses', 'list_of_agents.json')
      File.expand_path(path)
    end

    let(:response_body) { File.read(filepath) }

    before do
      stub_request(:get, endpoint.list_agents_path("email is mohan.zhang@legitscript.com"))
         .to_return(status: 200, body: response_body, headers: {})
    end

    it 'returns a single agent with a given email' do
      agent = described_class.find_by_email(agent_email)
      expect(agent).to be_a(described_class)
    end
  end
end
