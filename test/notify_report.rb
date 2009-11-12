class NotifyReport < Riot::TextReport
  PATH = ENV['HOME'] + "/bin/notify_redgreen"

  if File.exist?(PATH)
    def notify(color, msg)
      system "#{PATH} #{color} #{msg}"
    end
  else
    def notify(color, msg)
      # noop
    end
  end

  def failed(failure)
    super
    notify(:red, "FAILURE: #{failure}")
  end

  def errored(error)
    super
    notify(:red, "ERROR: #{error}")
  end

  def results
    super
    if bad_results.empty?
      notify(:green, "%d assertions, %d failures, %d errors in %s seconds" % [assertions, failures, errors, ("%0.6f" % time_taken)])
    end
  end
end

Riot.reporter = NotifyReport.new
