require 'spec_helper'

describe Freshdesk::Ticket do
  let(:response_body) do
    path = File.join('spec', 'support', 'responses', 'ticket.json')
    full_path = File.expand_path(path)
    File.read(full_path)
  end
  let(:parsed_data) { JSON.parse(response_body)['helpdesk_ticket'] }
  let(:ticket) { Freshdesk::Ticket.new(parsed_data) }

  it 'has methods mapping to JSON response fields' do
    expect(ticket).to respond_to(:notes)
    expect(ticket).to respond_to(:requester_id)
    expect(ticket).to respond_to(:subject)
    expect(ticket).to respond_to(:responder_name)
  end
end
