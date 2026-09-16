require 'spec_helper'

RSpec.describe "Solr basic auth" do
  let(:port) { ENV.fetch('SOLR_AUTH_TEST_PORT', 8984) }
  let(:base_url) { "http://localhost:#{port}/solr/basic_configs/" }
  let(:user) { 'rsolr' }
  let(:password) { 'RSolrTest123' }

  it "succeeds using the basic_auth: option" do
    solr = RSolr.connect(url: base_url, basic_auth: { user: user, password: password })
    expect { solr.head('admin/ping') }.not_to raise_error
  end

  it "succeeds using credentials embedded in the URL" do
    url = "http://#{user}:#{password}@localhost:#{port}/solr/basic_configs/"
    solr = RSolr.connect(url: url)
    expect { solr.head('admin/ping') }.not_to raise_error
  end

  it "raises RSolr::Error::Http with no credentials" do
    solr = RSolr.connect(url: base_url)
    expect { solr.head('admin/ping') }.to raise_error(RSolr::Error::Http, /401/)
  end

  it "raises RSolr::Error::Http with the wrong credentials" do
    solr = RSolr.connect(url: base_url, basic_auth: { user: user, password: 'wrong' })
    expect { solr.head('admin/ping') }.to raise_error(RSolr::Error::Http, /401/)
  end
end
