MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class RcovGrapher < Grapher
    attr_accessor :rcov_percent, :lines_missed, :branches_missed, :labels

    def self.metric
      :rcov
    end

    def initialize
      super
      self.rcov_percent = []
      self.lines_missed = []
      self.branches_missed = []
      self.labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:rcov]
        rcov_percent.push(metrics[:rcov][:global_percent_run])
        lines_missed.push(metrics[:rcov][:lines_missed] || 0)
        branches_missed.push(metrics[:rcov][:branches_missed] || 0)
        labels.update(labels.size => date)
      end
    end

    def title
      "Rcov: code coverage"
    end

    def data
      [
        ["rcov", @rcov_percent.join(",")],
        ["missed", @lines_missed.join(",")],
        ["branches", @branches_missed.join(",")]
      ]
    end

    def output_filename
      "rcov.js"
    end
  end
end
