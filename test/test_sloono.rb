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

    context "yields block" do
      asserts("without arg") do
        Sloono::API.new("username", "password") do
          $username = username
        end
        $username
      end.equals("username")

      asserts("with arg") do
        Sloono::API.new("username", "password") do |api|
          $username = api.username
        end
        $username
      end.equals("username")
    end
  end # API

end
