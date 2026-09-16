require 'spec_helper'

RSpec.describe "Solr basic_configs" do
  context "basic configs" do
    subject { RSolr.connect url: "http://localhost:#{ENV.fetch('SOLR_TEST_PORT', 8983)}/solr/basic_configs/" }

    describe "HEAD admin/ping" do
      it "should not raise an exception" do
        expect { subject.head('admin/ping') }.not_to raise_error
      end

      it "should not have a body" do
        expect(subject.head('admin/ping')).to be_kind_of RSolr::HashWithResponse
      end
    end
  end

  context "error handling" do
    subject { RSolr.connect url: "http://localhost:65432/solr/basic_configs/"}

    it "wraps connection errors" do
      expect { subject.head('admin/ping') }.to raise_error RSolr::Error::ConnectionRefused
    end
  end
end
