module MetricFu
  class RspecGenerator < Generator
    def self.metric
      :rspec
    end

    def emit
      @output = run(options)
    end

    def analyze
      if @output.nil? || @output.size.zero?
        @rspec = { rspec: {} }
      else
        @rspec = @output
      end
      @rspec
    end

    # ensure hash only has the :rspec key
    def to_h
      { rspec: @rspec[:rspec] }
    end

    def passed(summary)
      e = summary['example_count'].to_i
      p = summary['pending_count'].to_i
      f = summary['failure_count'].to_i
      passed = if e.zero?
                 0
               else
                 ((e - (p + f)) * 100.0)/e
               end
      summary['passed'] = passed.round(3)
    end

    # @param args [Hash] rspec metric run options
    # @return [Hash] rspec results
    def run(args)
      # @note passing in false to report will return a hash
      #    instead of the default String
      # ::Rspec::RspecCalculator.new(args).report(false)
      results = JSON.load(File.read('tmp/rspec.json')) || {}
      summary = results.delete('summary') || {}
      passed(summary)
      summary.each do |k, v|
        results[k] = v
      end
      results[:primary] = summary['passed']
      { rspec: results }
    end
  end
end
