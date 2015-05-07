require "fetchable/version"
require "active_support/concern"
require 'active_support/core_ext'
require "active_support/inflector"
require "faraday"
require "faraday_middleware"
require "fetchable/base"
require "models/fetchable_connection"

module Fetchable
  extend ActiveSupport::Concern
  include Base

  def initialize args={}
    raise NotImplementedError
  end

  module ClassMethods
    def where args={}
      request_parameters = whitelist_arguments(args)
      response = fetchable_connection.get collection_url, request_parameters
      collection = parse_collection(response)

      collection.map do |resource|
        new resource
      end
    end
    alias_method :all, :where

    def find identifier, args={}
      response = fetchable_connection.get singular_url(identifier), whitelist_arguments(args)
      resource = parse_singular response
      new resource
    end

    private
    def resource_name
      self.to_s.downcase.pluralize
    end

    def collection_url
      resource_name
    end

    def singular_url id
      "#{collection_url.chomp("/")}/#{id}"
    end

    def parse_collection response
      response.body[resource_name]
    end

    def parse_singular response
      response.body
    end

    def allowed_connection_options
      []
    end

    def whitelist_arguments args
      args.select{ |key,_| allowed_connection_options.include?(key) }.reverse_merge default_arguments
    end
  end
end
