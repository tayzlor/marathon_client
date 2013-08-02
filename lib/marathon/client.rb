module Marathon
  class Client
    include HTTParty

    headers 'Content-Type' => 'application/json'
    query_string_normalizer proc { |query| MultiJson.dump(query) }
    maintain_method_across_redirects


    def initialize(host = nil)
      @host = host || ENV['MARATHON_HOST'] || 'http://localhost:8080'
    end

    def list
      wrap_request(:get, '/v1/apps')
    end

    def start(id, opts)
      body = opts.dup
      body[:id] = id
      wrap_request(:post, '/v1/apps/start', :body => body)
    end

    def scale(id, num_instances)
      body = {:id => id, :instances => num_instances}
      wrap_request(:post, '/v1/apps/scale', :body => body)
    end

    def stop(id)
      body = {:id => id}
      wrap_request(:post, '/v1/apps/stop', :body => body)
    end

    private

    def wrap_request(method, url, options = {})
      http = self.class.send(method, @host + url, options)
      Marathon::Response.new(http)
    rescue => e
      Marathon::Response.error(e.message)
    end

  end
end
