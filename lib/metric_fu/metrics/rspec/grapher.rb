MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class RspecGrapher < Grapher
    attr_accessor :durations, :passes, :examples, :failures, :pendings, :labels

    def self.metric
      :rspec
    end

    def initialize
      super
      self.passes = []
      self.durations = []
      self.examples = []
      self.failures = []
      self.pendings = []
      self.labels = {}
    end

    def duration(metrics)
      metrics[:rspec]['duration'].to_i
    end

    def pending_count(metrics)
      metrics[:rspec]['pending_count'].to_i
    end

    def failure_count(metrics)
      metrics[:rspec]['failure_count'].to_i
    end

    def example_count(metrics)
      metrics[:rspec]['example_count'].to_i
    end

    def passed_percent(metrics)
      e = example_count(metrics)
      p = pending_count(metrics)
      f = failure_count(metrics)
      if e.zero?
        0
      else
        ((e - (p + f)) * 100.0)/e
      end
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:rspec]
        durations.push(duration(metrics))
        examples.push(pending_count(metrics))
        failures.push(failure_count(metrics))
        pendings.push(pending_count(metrics))
        passes.push(passed_percent(metrics))
        labels.update(labels.size => date)
      end
    end

    def title
      "Rspec Results"
    end

    def data
      [
        ["Passed", passes.join(",")],
        # ["Duration", durations.join(",")],
        # ["Examples", examples.join(",")],
        ["Failures", failures.join(",")],
        ["Pending", pendings.join(",")]
      ]
    end

    def output_filename
      "rspec.js"
    end
  end
end
