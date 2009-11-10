require 'helper'

class Riot::Context
  def situation_helper(&block)
    Riot::Situation.class_eval(&block)
  end
end

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
  end

  context "SMS" do

    situation_helper do
      def sms_options(options={})
        {
          :from   =>  1,
          :to     =>  "0234/56789",
          :text   =>  "Hello world",
          :action =>  :info,
          :type   =>  :discount
        }.update(options)
      end
    end

    context "options" do
      asserts("empty") { sms_options[:from] }.equals(1)
      asserts("empty") { sms_options[:type] }.equals(:discount)
      asserts("empty") { sms_options[:action] }.equals(:info)
      asserts("empty") { sms_options[:timestamp] }.nil
      asserts("update") { sms_options(:timestamp => 1)[:timestamp] }.equals(1)
    end

    context "defaults" do
      setup { Sloono::SMS.new }

      asserts("from is 1") { topic.from }.equals(1)
      asserts("to is nil") { topic.to }.nil
      asserts("text is empty") { topic.text }.equals("")
      asserts("type is discount") { topic.type }.equals(:discount)
      asserts("timestamp is 0") { topic.timestamp }.equals(0)
      asserts("action is nil") { topic.action }.nil
    end

    context "validate" do
      setup { Sloono::SMS.new }

      context "from" do
        asserts("1") { topic.from 1 }.equals(1)
        asserts("1 as string") { topic.from "1" }.equals(1)
        asserts("5") { topic.from 5 }.equals(5)
        asserts("out of range") { topic.from 0 }.raises(ArgumentError)
      end

      # TODO other
    end

  end

end
