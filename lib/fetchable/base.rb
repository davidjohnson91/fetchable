module Fetchable
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      private
      def connection
        @connection ||= FetchableConnection.new(api_endpoint_url: api_endpoint_url)
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
