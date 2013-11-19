require 'uri'

module Marathon
  class Client
    include HTTParty

    headers(
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    )
    query_string_normalizer proc { |query| MultiJson.dump(query) }
    maintain_method_across_redirects
    default_timeout 5


    def initialize(host = nil, user = nil, pass = nil)
      @host = host || ENV['MARATHON_HOST'] || 'http://localhost:8080'
      @default_options = {}

      if user && pass
        @default_options[:basic_auth] = {:username => user, :password => pass}
      end
    end

    def list
      wrap_request(:get, '/v1/apps')
    end

    def list_tasks(id)
      wrap_request(:get, URI.escape("/v1/apps/#{id}/tasks"))
    end

    def search(id=nil, cmd=nil)
      uri = ""
      uri = uri + "id=#{id}" unless id.nil?
      uri = uri + "cmd=#{cmd}" unless cmd.nil?

      wrap_request(:get, URI.escape("/v1/apps/search?#{uri}"))
    end

    def endpoints(id = nil)
      if id.nil?
        wrap_request(:get, "/v1/endpoints")
      else
        wrap_request(:get, "/v1/endpoints/#{id}")
      end
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

    def scale_by_task(id, host)
      body = {}
      wrap_request(:post, URI.escape("/v1/tasks/kill?scale=true&host=#{host}&appId=#{appId}"), :body => body)
    end

    private

    def wrap_request(method, url, options = {})
      options = @default_options.merge(options)
      http = self.class.send(method, @host + url, options)
      Marathon::Response.new(http)
    rescue => e
      Marathon::Response.error(e.message)
    end
  end
end
