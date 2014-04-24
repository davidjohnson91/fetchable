class FetchableConnection
  attr_reader :client, :args, :api_endpoint_url

  def initialize args
    @api_endpoint_url = args.delete(:api_endpoint_url)
    @args = args
    @client = create_client args
  end

  def get(path, options={})
    client.get(path_builder(path), options)
  end

  def put(path, options={})
   client.put(path_builder(path), options)
  end

  def post(path, options={})
    client.post(path_builder(path), options)
  end

  def delete(path, options={})
    client.delete(path_builder(path), options)
  end

  private
  def path_builder path
    combined_path = "#{path}?"
    args.each do |k, v|
      combined_path << "#{k}=#{v}&"
    end
    combined_path.chomp("&").chomp("?")
  end

  def create_client args
    Faraday.new(args[:api_endpoint_url], ssl: { verify: false }) do |connection|
      connection.use FaradayMiddleware::ParseJson, content_type: "application/json"
      connection.use FaradayMiddleware::FollowRedirects, limit: 3
      connection.use Faraday::Response::RaiseError
      connection.request :url_encoded
    end
  end
end
