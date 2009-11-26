class NotifyReporter < Riot::DotMatrixReporter
  PATH = ENV['HOME'] + "/bin/notify_redgreen"

  if File.exist?(PATH)
    def notify(color, msg)
      msg.gsub!(/</, '&lt;')
      system "#{PATH} #{color} #{msg}"
    end
  else
    def notify(color, msg)
      # noop
    end
  end

  def fail(desc, message)
    super
    notify(:red, "FAILURE: #{message}")
  end

  def error(desc, error)
    super
    notify(:red, "ERROR: #{error}")
  end

  def bad_results?
    failures + errors > 0
  end

  def results(time_taken)
    super
    unless bad_results?
      notify(:green, "%d passes, %d failures, %d errors in %s seconds" % [passes, failures, errors, ("%0.6f" % time_taken)])
    end
  end
end

Riot.reporter = NotifyReporter
