module Marathon
  class App

    def initialize(id)
      @id = id
    end

    def start(opts)
      body = opts.dup
      body[:id] = @id

      request('/v1/apps/start', body)
    end

    def scale(num_instances)
      body = {:id => @id, :instances => num_instances}
      request('/v1/apps/scale', body)
    end

    def stop
      body = {:id => @id}
      request('/v1/apps/stop', body)
    end

    private

    def request(url, body)
      res = Marathon.connection.post do |req|
        req.url url
        req.body = MultiJson.dump(body)
      end
      (res.status >= 200 && res.status < 300) ? 'OK' : "ERROR: Status #{res.status}"
    rescue Faraday::Error::ClientError => e
      "ERROR: #{e.message}"
    end

  end
end
