module Fetchable
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      private
      def connection
        Faraday.new(api_endpoint_url, ssl: { verify: false }) do |connection|
          connection.use FaradayMiddleware::ParseJson, content_type: "application/json"
          connection.use FaradayMiddleware::FollowRedirects, limit: 3
          connection.use Faraday::Response::RaiseError
          connection.request :url_encoded
        end
      end

      def api_endpoint_url
        raise NotImplementedError
      end

      def api_options
        {}
      end
    end
  end
end
