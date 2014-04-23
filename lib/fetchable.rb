require "fetchable/version"
require "active_support/concern"
require "active_support/inflector"
require "faraday"
require "faraday_middleware"
require "fetchable/base"

module Fetchable
  extend ActiveSupport::Concern
  include Base

  def initialize args={}
    raise NotImplementedError
  end

  module ClassMethods
    def where args={}
      request_parameters = whitelist_arguments(args)
      response = connection.get resource_name, request_parameters
      collection = parse_collection(response.body)

      collection.map do |resource|
        self.new(resource)
      end
    end
    alias_method :all, :where

    private
    def resource_name
      self.to_s.downcase.pluralize
    end

    def parse_collection(response)
      response
    end

    def allowed_connection_options
      []
    end

    def whitelist_arguments args
      args.select{ |key,_| allowed_connection_options.include?(key) }
    end
  end
end
