require 'csv'

module MetricFu
  class DeepCoverGenerator < Generator
    def self.metric
      :deep_cover
    end

    def emit
      @output = run(options)
    end

    def analyze
      if @output.nil? || @output.size.zero?
        @deep_cover = { deep_cover: {} }
      else
        @deep_cover = @output
      end
      @deep_cover
    end

    # ensure hash only has the :deep_cover key
    def to_h
      { deep_cover: @deep_cover[:deep_cover] }
    end

    # @param args [Hash] deep_cover metric run options
    # @return [Hash] deep_cover results
    def run(args)
      # @note passing in false to report will return a hash
      #    instead of the default String
      # ::DeepCover::DeepCoverCalculator.new(args).report(false)
      results = {}

      table = CSV.table('deep_cover/deep_cover.csv')
      table.headers
      details = table.map do |row|
        Hash[row.to_a]
      end
      details[0].each do |k, v|
        results[k.to_sym] = v
      end
      results[:primary] = results[:branch_percent]
      # if summary['example_count'].to_i == 0
      #   results[:primary] = 'ERROR'
      # elsif results['status'] == 'failure'
      #   results[:primary] = 'ERROR'
      # else
      #   results[:primary] = summary['passed']
      # end
      { deep_cover: results }
    end
  end
end
