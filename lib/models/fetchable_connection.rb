class FetchableConnection
  attr_reader :client

  def initialize args
    @api_endpoint_url = args.delete(:api_endpoint_url)
    @client = create_client
  end

  def get(path, options={})
    client.get(path, options)
  end

  def put(path, options={})
   client.put(path, options)
  end

  def post(path, options={})
    client.post(path, options)
  end

  def delete(path, options={})
    client.delete(path, options)
  end

  private
  attr_reader :args, :api_endpoint_url

  def create_client
    Faraday.new(api_endpoint_url, ssl: { verify: false }) do |connection|
      connection.use FaradayMiddleware::ParseJson, content_type: "application/json"
      connection.use FaradayMiddleware::FollowRedirects, limit: 3
      connection.use Faraday::Response::RaiseError
      connection.request :url_encoded
      connection.adapter Faraday.default_adapter
    end
  end
end
