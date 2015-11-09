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
end
