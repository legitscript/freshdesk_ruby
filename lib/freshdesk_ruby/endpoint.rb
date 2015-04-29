module Freshdesk
  #
  class Endpoint
    def helpdesk_path
      config.base_endpoint + '/helpdesk'
    end

    def ticket_path(id)
      path = File.join('/tickets', id.to_s) + '.json'
      helpdesk_path + path
    end

    def tickets_path(parameters = {})
      query_string = '?' + parameters.to_query
      path = '/tickets.json' + query_string
      helpdesk_path + path
    end

    def ticket_fields_path
      helpdesk_path + '/ticket_fields.json'
    end

    def ticket_note_path(id)
      path = File.join('/tickets', id.to_s, 'conversations/note.json')
      helpdesk_path + path
    end

    def list_users_path(query)
      URI.escape(config.base_endpoint + "/contacts.json?query=#{query}")
    end

    def create_user_path
      URI.escape(config.base_endpoint + "/contacts.json")
    end

    def list_agents_path(query)
      URI.escape(config.base_endpoint + "/agents.json?query=#{query}")
    end

    def user_by_id_path(id)
      URI.escape(config.base_endpoint + "/contacts/#{id}.json")
    end

    def request_headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => credentials
      }
    end

    def credentials
      encoded = Base64.strict_encode64(
        basic_auth_username + ':' + config.password
      )
      'Basic ' + encoded
    end

    def basic_auth_username
      # This supports the 2 ways of authenticating
      # with Freshdesk:
      # 1.) valid username and password
      # 2.) API key as the username with a dummy password
      config.username.empty? ? config.api_key : config.username
    end

    def config
      Freshdesk.configuration
    end
  end
end
