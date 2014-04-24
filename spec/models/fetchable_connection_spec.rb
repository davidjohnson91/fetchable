require "spec_helper"

describe FetchableConnection do
  subject { FetchableConnection.new(api_endpoint_url: "http://example.test") }
  describe "initialize" do
    it "creates a new Farday Connection" do
      expect(subject.client).to be_a Faraday::Connection
    end
  end

  describe "#get" do
    it "makes a get request" do
      expect_any_instance_of(Faraday::Connection).to receive(:get).with "foobar", {}
      subject.get("foobar")
    end
  end

  describe "#post" do
    it "makes a post request" do
      expect_any_instance_of(Faraday::Connection).to receive(:post).with "foobar", {}
      subject.post("foobar")
    end
  end

  describe "#put" do
    it "makes a put request" do
      expect_any_instance_of(Faraday::Connection).to receive(:put).with "foobar", {}
      subject.put("foobar")
    end
  end

  describe "#delete" do
    it "makes a delete request" do
      expect_any_instance_of(Faraday::Connection).to receive(:delete).with "foobar", {}
      subject.delete("foobar")
    end
  end
end
