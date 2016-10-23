MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class RubocopGrapher < Grapher
    attr_accessor :offenses, :labels

    def self.metric
      :rubocop
    end

    def initialize
      super
      self.offenses = []
      self.labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:rubocop]
        offenses.push(metrics[:rubocop]['offense_count'].to_i)
        labels.update(labels.size => date)
      end
    end

    def title
      "Rubocop Offenses"
    end

    def data
      [
        ["Offenses", offenses.join(",")],
      ]
    end

    def output_filename
      "rubocop.js"
    end
  end
end
