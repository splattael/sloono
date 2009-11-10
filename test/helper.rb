require 'riot'

require 'sloono'

class Riot::Context
  def situation_helper(&block)
    Riot::Situation.class_eval(&block)
  end
end
