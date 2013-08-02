module Marathon
  class Response

    # TODO make this attr_reader and set the error some other way
    attr_accessor :error

    def initialize(http)
      @http = http
      @error = error_message_from_response
    end

    def ok?
      @ok ||= !!@http && @http.success?
    end

    def error?
      !ok?
    end

    def parsed_response
      @http && @http.parsed_response
    end

    def self.error(message)
      error = new(nil)
      error.error = message
      error
    end

    def to_s
      if ok?
        "OK"
      else
        "ERROR: #{error}"
      end
    end

    private

    def error_message_from_response
      return if ok?
      return if @http.nil?
      @http.body
    end
  end
end
