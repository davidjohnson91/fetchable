require "spec_helper"

class FetchableModel
  include Fetchable
end

describe Fetchable do
  subject { FetchableModel }

  describe "unimplemented methods" do
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

  %i[where all].each do |method_name|
    describe ".#{method_name}" do
      let(:expected_collection) { [{ id: 1, name: "Test One" }, { id: 2, name: "Test Two" }] }

      before do
        subject.stub(:collection_url)
        subject.stub_chain(:connection, :get)
          .and_return( double body: expected_collection )

        class FetchableModel
          def initialize args={}

          end
        end
      end

      it "returns an array of instances" do
        collection = subject.send(method_name)
        expect(collection.size).to eq(2)
        collection.each do |instance|
          expect(instance).to be_a(FetchableModel)
        end
      end
    end
  end
end
