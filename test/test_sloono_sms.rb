require 'helper'

context "Sloono::SMS" do

  context "validate" do
    setup { Sloono::SMS.new }

    context "from" do
      asserts("default") { topic.from }.equals(1)
      Sloono::SMS::FROM_RANGE.each do |i|
        asserts(i) { topic.from i }.equals(i)
      end
      asserts("1 as string") { topic.from "1" }.equals(1)
      asserts("out of range") { topic.from 0 }.raises(ArgumentError)
    end

    context "to" do
      asserts("default") { topic.to }.equals([])
      asserts("one") { topic.to "1234 5678" }.equals(["1234 5678"])
      asserts("more") { topic.to ["1234 5678", "2345 7890"] }.equals(["1234 5678", "2345 7890"])
    end

    context "text" do
      asserts("default") { topic.text }.equals("")
      asserts("text") { topic.text "hello world" }.equals("hello world")
      asserts("text stripped") { topic.text "  hello world  " }.equals("hello world")
    end

    context "type" do
      asserts("default") { topic.type }.equals("discount")
      Sloono::SMS::TYPES.each do |type|
        asserts(type) { topic.type type }.equals(type)
      end
      asserts("number") { topic.type 0 }.equals("0")
      asserts("string") { topic.type "FLASH" }.equals("flash")
      asserts("symbol") { topic.type :FLASH }.equals("flash")
      [ -1, :invalid, "invalid" ].each do |type|
        asserts("invalid #{type}") { topic.type type }.raises(ArgumentError)
      end
    end

    context "deliver_at" do
      asserts("default") { topic.deliver_at }.equals(nil)
      asserts("number") { topic.deliver_at 1234 }.equals(1234)
      asserts("time") { topic.deliver_at Time.now }.equals(Time.now.to_i)
    end
  end # validate

  context "new" do
    asserts("with options") do
      Sloono::SMS.new(:text => "hello world").text
    end.equals("hello world")

    asserts("yields block with arg") do
      Sloono::SMS.new do |sms|
        sms.text "hello world"
      end.text
    end.equals("hello world")

    asserts("yields block without arg") do
      Sloono::SMS.new do
        text "hello world"
      end.text
    end.equals("hello world")

    asserts("with options and block") do
      Sloono::SMS.new(:text => "never see me") do |sms|
        sms.text "I win"
      end.text
    end.equals("I win")
  end
end 
