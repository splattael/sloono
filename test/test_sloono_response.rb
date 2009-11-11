require 'helper'

context "Sloono::Response" do

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
      asserts("status") { topic.status }.equals(:success)
    end

    context "input_error" do
      setup { status(:code => 200) }
      asserts("!success?") { !topic.success? }
      asserts("input_error?") { topic.input_error? }
      asserts("error?") { topic.error? }
      asserts("status") { topic.status }.equals(:input_error)
    end

    context "input_error" do
      setup { status(:code => 300) }
      asserts("!success?") { !topic.success? }
      asserts("system_error?") { topic.system_error? }
      asserts("error?") { topic.error? }
      asserts("status") { topic.status }.equals(:system_error)
    end

  end

end
