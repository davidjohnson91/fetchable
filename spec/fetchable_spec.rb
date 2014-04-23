require "spec_helper"

class InvalidFetchableModel
  include Fetchable
end

class FetchableModel
  include Fetchable
  attr_reader :id

  def initialize args
    @id = args[:id]
  end

  private
  def api_endpoint_url
    "http://example.test"
  end
end

describe Fetchable do
  subject { FetchableModel }

  describe "unimplemented methods" do
    subject { InvalidFetchableModel }

    it "raises unimplemented errors" do
      %i[new].each do |method|
        expect { subject.send(method) }.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".resource_name" do
    it "has a resource name" do
      expect(subject.send(:resource_name)).to eq(subject.to_s.downcase.pluralize)
    end
  end

  shared_examples_for "all" do

    before do
      subject.stub(:api_endpoint_url).and_return "http://example.test"
    end

    it "requests based on the default RESTful route" do
      subject.stub_chain(:connection, :get)
        .and_return( double body: response_no_root )

      collection
    end

    it "returns an array of instances" do
      subject.stub_chain(:connection, :get)
        .and_return( double body: response_no_root )

      expect(collection.size).to eq(2)
      collection.each_with_index do |instance, index|
        expect(instance).to be_a(FetchableModel)
        expect(instance.id).to eq(expected_collection[index][:id])
      end
    end
  end

  %i[where all].each do |method_name|
    describe ".#{method_name}" do
      let(:expected_collection) { [{ id: 1, name: "Test One" }, { id: 2, name: "Test Two" }] }

      let(:response_with_root) do
        {
          collection: expected_collection,
          other_key: "foobar"
        }
      end
      let(:response_no_root) { expected_collection }

      let(:collection) { subject.send(method_name) }

      describe "generic behaviors" do
        let(:response) { response_no_root }

        it_behaves_like "all"
      end

      describe "with overridden behavior" do
        before do
          subject.stub(:parse_collection)
            .and_return(expected_collection)
        end

        context "response from server is different" do
          let(:response) { response_with_root }

          it_behaves_like "all"
        end

        describe "passing options" do
          let(:accepted_passed_options) { { allowed: "foobar", also_allowed: "baz" } }

          before do
            subject.stub(:allowed_connection_options)
              .and_return(accepted_passed_options.keys)

            subject.stub(:api_endpoint_url).and_return("http://example.test")
          end

          it "removes non-whitelisted options" do
            expect_any_instance_of(Faraday::Connection)
              .to receive(:get).with("fetchablemodels", accepted_passed_options)
              .and_return(double body: response_no_root)

            subject.all(accepted_passed_options.merge(disallow: "me"))
          end

          it "removes nil options" do
            expect_any_instance_of(Faraday::Connection)
              .to receive(:get).with("fetchablemodels", accepted_passed_options)
              .and_return(double body: response_no_root)

            subject.all(accepted_passed_options.merge({disallow: "", also_disallow: nil}))
          end
        end
      end
    end
  end
end
