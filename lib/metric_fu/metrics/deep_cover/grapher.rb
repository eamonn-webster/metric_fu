MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class DeepCoverGrapher < Grapher
    attr_accessor :branches_executeds, :branches_not_executeds, :branch_percents, :labels

    def self.metric
      :deep_cover
    end

    def initialize
      super
      self.branches_executeds = []
      self.branches_not_executeds = []
      self.branch_percents = []
      self.labels = {}
    end

    def branches_executed(metrics)
      metrics[:deep_cover][:branches_executed]
    end

    def branches_not_executed(metrics)
      metrics[:deep_cover][:branches_not_executed]
    end

    def branch_percent(metrics)
      metrics[:deep_cover][:branch_percent]
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:deep_cover]
        branches_executeds.push(branches_executed(metrics))
        branches_not_executeds.push(branches_not_executed(metrics))
        branch_percents.push(branch_percent(metrics))
        labels.update(labels.size => date)
      end
    end

    def title
      "DeepCover Results"
    end

    def data
      [
        # ["branches_executed", branches_executeds.join(",")],
        ["branches_not_executed", branches_not_executeds.join(",")],
        ["branch_percent", branch_percents.join(",")]
      ]
    end

    def output_filename
      "deep_cover.js"
    end
  end
end
