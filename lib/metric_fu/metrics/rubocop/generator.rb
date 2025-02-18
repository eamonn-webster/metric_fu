module MetricFu
  class RubocopGenerator < Generator
    def self.metric
      :rubocop
    end

    def emit
      @output = run(options)
    end

    def analyze
      if @output.nil? || @output.size.zero?
        @rubocop = { rubocop: {} }
      else
        @rubocop = @output
      end
      @rubocop
    end

    # ensure hash only has the :rubocop key
    def to_h
      { rubocop: @rubocop[:rubocop] }
    end

    # @param args [Hash] rubocop metric run options
    # @return [Hash] rubocop results
    def run(args)
      # @note passing in false to report will return a hash
      #    instead of the default String
      # ::Rubocop::RubocopCalculator.new(args).report(false)
      output = `rubocop --format html --out rubocop.html --format json`
      while output =~ /RuboCop server starting/
        output = `rubocop --format html --out rubocop.html --format json`
      end
      results = JSON.parse(output)
      summary = results.delete('summary')
      summary.each do |k, v|
        results[k] = v
      end
      results[:primary] = summary['offense_count']
      { rubocop: results }
    end
  end
end
