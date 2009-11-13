require 'helper'

context "Sloono::Request" do

  helper do
    def stub_request(body)
      body = body.is_a?(Hash) ? text(body) : body
      hydra = Typhoeus::Hydra.hydra
      response = Typhoeus::Response.new(:code => 200, :body => body)
      hydra.stub(:post, %r{.*}).and_return(response)
    end
  end

  asserts("default base uri") { Sloono::Request.base_uri }.equals(Sloono::Request::DEFAULT_BASE_URI)

  context "instance" do
    asserts("default base uri") { Sloono::Request.new.base_uri }.equals(Sloono::Request.base_uri)
    asserts("passes base uri") { Sloono::Request.new("http://localhost").base_uri }.equals("http://localhost")
  end

  context "sms" do
    setup do
      stub_request(:status_code => 200, :status_text => "invalid login")
      Sloono::Request.sms(:base_uri => "http://localhost")
    end

    topic.kind_of(Sloono::Response)
    asserts("error?") { topic.error? }
    asserts("status code") { topic.status.code }.equals(200)
    asserts("status text") { topic.status.text }.equals("invalid login")
  end

end
