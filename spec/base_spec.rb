require "spec_helper"

class FetchableModel
  include Fetchable::Base
end

describe Fetchable::Base do
  subject { FetchableModel }

  describe "unimplemented methods" do
    it "raises unimplemented errors" do
      %i[api_endpoint_url].each do |method|
        expect { subject.send(method) }.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".connection" do
    before do
      subject.stub(api_endpoint_url: "http://example.com")
    end

    it "returns a Faraday Connection" do
      expect(subject.send(:fetchable_connection)).to be_a FetchableConnection
    end
  end

  it "has no API options" do
    expect(subject.send(:api_options)).to be_empty
  end
end
