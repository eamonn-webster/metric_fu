#
# File: grapher.rb
# Author: jscruggs
# Copyright jscruggs, 2008-2018
# Contents:
#
# Date:          Author:  Comments:
#  3rd May 2018  eweb     #0008 use saved code smell counts
#
MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class ReekGrapher < Grapher
    attr_accessor :reek_count, :labels

    def self.metric
      :reek
    end

    def initialize
      super
      @reek_count = {}
      @labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:reek]
        counter = @labels.size
        @labels.update(@labels.size => date)

        if metrics[:reek][:smell_counts]
          metrics[:reek][:smell_counts].each do |smell, count|
            @reek_count[smell] ||= []
            @reek_count[smell][counter] = count
          end
        else
          metrics[:reek][:matches].each do |reek_chunk|
            reek_chunk[:code_smells].each do |code_smell|
              # speaking of code smell...
              @reek_count[code_smell[:type]] = [] if @reek_count[code_smell[:type]].nil?
              if @reek_count[code_smell[:type]][counter].nil?
                @reek_count[code_smell[:type]][counter] = 1
              else
                @reek_count[code_smell[:type]][counter] += 1
              end
            end
          end
          # puts ({date => {smell_counts: Hash[@reek_count.map { |k, v| [k, v[counter]] }]}}).to_yaml
        end
        metrics
      end
    end

    def title
      "Reek: code smells"
    end

    def data
      @reek_count.map do |name, count|
        [name, nil_counts_to_zero(count).join(",")]
      end
    end

    def output_filename
      "reek.js"
    end

    private

    def nil_counts_to_zero(counts)
      counts.map { |count| count || 0 }
    end
  end
end
