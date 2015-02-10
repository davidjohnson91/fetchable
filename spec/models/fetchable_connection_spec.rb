require "spec_helper"

describe FetchableConnection do
  let(:api_endpoint_url) { "http://example.test/" }
  subject { FetchableConnection.new(api_endpoint_url: api_endpoint_url) }
  describe "initialize" do
    it "creates a new Farday Connection" do
      expect(subject.client).to be_a Faraday::Connection
      expect(subject.client.url_prefix.to_s).to eq api_endpoint_url
    end
  end

  %i[get post put delete].each do |method_name|
    it "makes a #{method_name} request" do
      expect_any_instance_of(Faraday::Connection).to receive(method_name).with "foobar", {}
      subject.send(method_name, "foobar")
    end
  end
end
