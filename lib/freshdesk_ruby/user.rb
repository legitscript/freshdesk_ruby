module Freshdesk
  #
  class User < Freshdesk::Base
    class << self
      def find_by_email(email)
        url = endpoint.list_users_path("email is #{email}")
        response = get_request(url)
        with_error_handling(response) do |parsed|
          users = parsed.map { |user| new(user['user']) }
          if users.size > 1
            raise "More than one user with the same email?"
          else
            return users.first
          end
        end
      end

      def find_by_id(id)
        url = endpoint.user_by_id_path(id)
        response = get_request(url)
        with_error_handling(response) do |parsed_user|
          return new(parsed_user['user'])
        end
      end

      def create(name, email)
        req_body = request_body.user_body(name, email)
        url = endpoint.create_user_path
        response = post_request(url, req_body)
        with_error_handling(response) do |parsed|
          new(parsed['user'])
        end
      end
    end
  end
end
