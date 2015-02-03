module Freshdesk
  #
  class User < Freshdesk::Base
    class << self
      def find_by_email(email)
        url = endpoint.list_users_path(query:"email is #{email}")
        response = get_request(url)
        with_error_handling(response) do |parsed|
          users = parsed.map { |user| new(user) }
          if users.size > 1
            raise "More than one user with the same email?"
          else
            return users.first
          end
        end
      end

    end
  end
end

