MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class CyclesGrapher < Grapher
    attr_accessor :cycles, :labels

    def self.metric
      :cycles
    end

    def initialize
      super
      self.cycles = []
      self.labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:cycles]
        cycles.push(metrics[:cycles][:total].to_i)
        labels.update(labels.size => date)
      end
    end

    def title
      "Cycles"
    end

    def data
      [
        ["Cycles", @cycles.join(",")],
      ]
    end

    def output_filename
      "cycles.js"
    end
  end
end
