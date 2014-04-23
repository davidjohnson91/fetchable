require "fetchable/version"
require "active_support/concern"
require "active_support/inflector"
require "faraday"
require "faraday_middleware"
require "fetchable/base"

module Fetchable
  extend ActiveSupport::Concern

  def initialize args={}
    raise NotImplementedError
  end

  module ClassMethods
    def where args={}
      response = connection.get "", args
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
  end
end
