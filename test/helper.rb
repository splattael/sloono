require 'rubygems'
require 'riot'

require 'notify_report'
require 'sloono'

class Riot::Context
  def helper(&block)
    Riot::Situation.class_eval(&block)
  end
end

Riot::Situation.class_eval do
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

    text = <<-TEXT
      #{options[:status_code]}
      #{options[:status_text]}
    TEXT

    if Sloono::Response::Status::SUCCESS_RANGE.include?(options[:status_code].to_i)
      text.concat <<-TEXT
        Text: #{options[:text]}
        Zeichen: #{options[:characters]}
        SMS: #{options[:messages]}
        Absenderkennung: #{options[:from]}
        Ziele: #{Array(options[:to]).join(",")}
        Kosten: #{options[:charge]}
        Versenden: #{options[:deliver_at]}
      TEXT
    end

    text.gsub!(/^\s*/, '').gsub!(/\n/, "\r\n")
  end

  def response(text)
    Sloono::Response.parse(text.is_a?(Hash) ? text(text) : text)
  end
end
