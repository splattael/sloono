require 'helper'

context "Sloono::Response" do

  context "parsing" do
    helper do
      def text(options={})
        options = {
          :status_code  => "100",
          :status_text  => "SMS erfolgreich versendet",
          :text         => "Dieser Text wird gesendet.",
          :characters   =>  26,
          :messages     =>  1,
          :from         =>  "+49(123)456789",
          :to           =>  "+49(321)987654",
          :charge       =>  "0,059",
          :deliver_at   =>  "Sofort"
        }.update(options)

        text =<<-TEXT
          #{options[:status_code]}
          #{options[:status_text]}

          Text: #{options[:text]}
          Zeichen: #{options[:characters]}
          SMS: #{options[:messages]}
          Absenderkennung: #{options[:from]}
          Ziele: #{Array(options[:to]).join(",")}
          Kosten: #{options[:charge]}
          Versenden: #{options[:deliver_at]}
        TEXT
        text.gsub!(/^\s*/, '')
      end

      def response(text)
        Sloono::Response.parse(text.is_a?(Hash) ? text(text) : text)
      end
    end

    context "default" do
      setup { response(text) }
      topic.kind_of(Sloono::Response)
      asserts("status") { topic.status }.kind_of(Sloono::Response::Status)
      asserts("status code") { topic.status.code }.equals(100)
      asserts("status text") { topic.status.text }.equals("SMS erfolgreich versendet")
      asserts("text") { topic.text }.equals("Dieser Text wird gesendet.")
      asserts("characters") { topic.characters }.equals(26)
      asserts("messages") { topic.messages }.equals(1)
      asserts("from") { topic.from }.equals("+49(123)456789")
      asserts("to") { topic.to }.equals(["+49(321)987654"])
      asserts("charge") { topic.charge }.equals(0.059)
      asserts("deliver_at") { topic.deliver_at }.equals(nil)
    end

    context "special" do
      asserts("multiple to") { response(:to => %w(1 2)).to }.equals(%w(1 2))
      asserts("deliver_at") { response(:deliver_at => 12345678).deliver_at }.equals(Time.at(12345678))
    end

    context "empty" do
      asserts("invalid text") { response("") }.raises(ArgumentError)
    end

  end # parsing

  context "forwards to status" do
    setup { response(text) }
    asserts("test") { topic.status.success? }
    [ :success?, :error?, :input_error?, :system_error?, :symbol, :fake? ].each do |method|
      # asserts(method) { topic.success? == topic.status.success? }
      asserts(method) { topic.send(method) == topic.status.send(method) }
    end
  end

  context "Status" do

    helper do
      def status(options={})
        options = { :code => 100, :text => "Status" }.update(options)
        Sloono::Response::Status.new(options[:code], options[:text])
      end
    end
    
    context "new" do
      setup { status(:code => 100, :text => "Status") }
      asserts("code") { topic.code }.equals(100)
      asserts("text") { topic.text }.equals("Status")
      asserts("invalid code") { status(:code => 0) }.raises(ArgumentError)
    end

    context "success" do
      setup { status(:code => 100) }
      asserts("success?") { topic.success? }
      asserts("!error?") { !topic.error? }
      asserts("symbol") { topic.symbol }.equals(:success)
    end

    context "input_error" do
      setup { status(:code => 200) }
      asserts("!success?") { !topic.success? }
      asserts("input_error?") { topic.input_error? }
      asserts("error?") { topic.error? }
      asserts("symbol") { topic.symbol }.equals(:input_error)
    end

    context "input_error" do
      setup { status(:code => 300) }
      asserts("!success?") { !topic.success? }
      asserts("system_error?") { topic.system_error? }
      asserts("error?") { topic.error? }
      asserts("symbol") { topic.symbol }.equals(:system_error)
    end

    context "fake?" do
      setup { status(:code => 101) }
      asserts("success?") { topic.success? }
      asserts("fake") { topic.fake? }
    end

  end # Status

end
