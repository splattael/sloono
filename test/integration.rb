
require 'rubygems'
require 'sloono'

username = ARGV[0] || "user"
password = ARGV[1] || "pass"

api = Sloono::API.new(username, password)

sms = api.sms do
  text   "Hello world"
  to    "015116720981"
end

p sms.info!
p sms.info!
