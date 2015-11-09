module Freshdesk
  #
  class ResponseError < StandardError
    attr_reader :body, :code

    def initialize(response)
      @body = response.body
      @code = response.code
    end

    def to_s
      body
    end
  end

  class EmailNotFoundError < ResponseError
    def to_s
      'No user with that email address exists in Freshdesk; have you created one?'
    end
  end
end
