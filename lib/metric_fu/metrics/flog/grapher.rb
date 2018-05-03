#
# File: grapher.rb
# Author: jscruggs
# Copyright jscruggs, 2008-2018
# Contents:
#
# Date:          Author:  Comments:
#  3rd May 2018  eweb     #0008 use saved top 5 percent average
#
MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class FlogGrapher < Grapher
    attr_accessor :flog_average, :labels, :top_five_percent_average

    def self.metric
      :flog
    end

    def initialize
      super
      @flog_average = []
      @labels = {}
      @top_five_percent_average = []
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:flog]
        @top_five_percent_average.push(calc_top_five_percent_average(metrics))
        @flog_average.push(metrics[:flog][:average])
        @labels.update(@labels.size => date)
      end
    end

    def title
      "Flog: code complexity"
    end

    def data
      [
        ["average", @flog_average.map { |a| a.round(4) }.join(",")],
        ["top 5% average", @top_five_percent_average.map { |a| a.round(4) }.join(",")]
      ]
    end

    def output_filename
      "flog.js"
    end

    private

    def calc_top_five_percent_average(metrics)
      return metrics[:flog][:top_5_average] if metrics[:flog][:top_5_average]

      method_scores = metrics[:flog][:method_containers].inject([]) do |method_scores, container|
        method_scores + container[:methods].values.map { |v| v[:score] }
      end
      method_scores.sort!.reverse!

      five_percent_of_methods = (method_scores.size * 0.05).ceil

      total_for_five_percent = method_scores[0...five_percent_of_methods].inject(0) { |total, score| total + score }
      if five_percent_of_methods == 0
        0.0
      else
        (total_for_five_percent / five_percent_of_methods.to_f) # .tap { |x| puts "  :top_5_average: #{x}" }
      end
    end
  end
end
