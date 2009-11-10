require 'helper'

context "Sloono" do

  asserts("#new dispatching to API") do
    Sloono.new("username", "password")
  end.kind_of(Sloono::API)

  context "API" do
    setup { Sloono::API.new("username", "password") }

    asserts("username") { topic.username }.equals("username")
    asserts("crypt password") { topic.password }.equals("5f4dcc3b5aa765d61d8327deb882cf99")
    asserts("crypted password") do
      Sloono::API.new("username", "5f4dcc3b5aa765d61d8327deb882cf99").password
    end.equals("5f4dcc3b5aa765d61d8327deb882cf99")

    context "initialize" do
      context "yields block" do
        asserts("without arg") do
          var = nil
          Sloono::API.new("username", "password") do
            var = username
          end
          var
        end.equals("username")

        asserts("with arg") do
          var = nil
          Sloono::API.new("username", "password") do |api|
            var = api.username
          end
          var
        end.equals("username")
      end
    end

    context "sms" do
      asserts("dispatches") { topic.sms }.kind_of(Sloono::SMS)
      asserts("passes api") { topic.sms.api }.kind_of(Sloono::API)
      asserts("passes options") { topic.sms(:text => "text").text }.equals("text")
      asserts("passes block") { topic.sms { text "text" }.text }.equals("text")
    end

  end # API

end
