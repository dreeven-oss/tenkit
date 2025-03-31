module Tenkit
  class TenkitError < StandardError
  end

  class RequestError < TenkitError
    attr_accessor :response

    def initialize(message, response: nil)
      super(message)
      self.response = response
    end
  end
end
