MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class DeepCoverGrapher < Grapher
    attr_accessor :branches_executeds, :branches_not_executeds, :branch_percents,
                  :chars_executeds, :chars_not_executeds, :char_percents,
                  :nodes_executeds, :nodes_not_executeds, :node_percents,
                  :labels

    def self.metric
      :deep_cover
    end

    def initialize
      super
      self.branches_executeds = []
      self.branches_not_executeds = []
      self.branch_percents = []
      self.chars_executeds = []
      self.chars_not_executeds = []
      self.char_percents = []
      self.nodes_executeds = []
      self.nodes_not_executeds = []
      self.node_percents = []
      self.labels = {}
    end

    def chars_executed(metrics)
      metrics[:deep_cover][:chars_executed]
    end

    def chars_not_executed(metrics)
      metrics[:deep_cover][:chars_not_executed]
    end

    def char_percent(metrics)
      metrics[:deep_cover][:char_percent]
    end

    def nodes_executed(metrics)
      metrics[:deep_cover][:nodes_executed]
    end

    def nodes_not_executed(metrics)
      metrics[:deep_cover][:nodes_not_executed]
    end

    def node_percent(metrics)
      metrics[:deep_cover][:node_percent]
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
        chars_executeds.push(chars_executed(metrics))
        chars_not_executeds.push(chars_not_executed(metrics))
        char_percents.push(char_percent(metrics))
        nodes_executeds.push(nodes_executed(metrics))
        nodes_not_executeds.push(nodes_not_executed(metrics))
        node_percents.push(node_percent(metrics))
        labels.update(labels.size => date)
      end
    end

    def title
      "DeepCover Results"
    end

    def data
      [
        # ["branches_executed", branches_executeds.join(",")],
        ["branches_not_executed", branches_not_executeds.map  { |c| c || 'null' }.join(",")],
        ["branch_percent", branch_percents.map { |c| c || 'null' }.join(",")],
        ["chars_not_executed", chars_not_executeds.map { |c| c || 'null' }.join(",")],
        ["char_percent", char_percents.map { |c| c || 'null' }.join(",")],
        ["nodes_not_executed", nodes_not_executeds.map { |c| c || 'null' }.join(",")],
        ["node_percent", node_percents.map { |c| c || 'null' }.join(",")]
      ]
    end

    def output_filename
      "deep_cover.js"
    end
  end
end
