require 'rubygems'
require 'riot'

require 'notify_report'
require 'sloono'

class Riot::Context
  def helper(&block)
    Riot::Situation.class_eval(&block)
  end
end
