module Freshdesk
  #
  class Agent < Freshdesk::Base
    def initialize(attributes)
      attributes.each do |(attr, value)|
        unless respond_to?(attr)
          value = attr == 'user' ? User.new(value) : value
          set_variable(attr, value)
        end
      end
    end

    class << self
      def find_by_email(email)
        url = endpoint.list_agents_path("email is #{email}")
        response = get_request(url)
        with_error_handling(response) do |parsed|
          agents = parsed.map { |agent| new(agent) }
          if agents.size > 1
            raise "More than one agent with the same email?"
          else
            return agents.first
          end
        end
      end
    end
  end
end
