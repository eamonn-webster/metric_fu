module MetricFu
  class CyclesGenerator < Generator
    def self.metric
      :cycles
    end

    def emit
      cmd = "dependency.rb #{dirs_to_cycle.join(' ')}"
      @output = MetricFu::Utility.capture_output do
        system(cmd)
      end
    end

    def analyze
      lines = @output.split("\n").compact

      @cycles = {}

      set_global_stats(lines.pop)
      set_granular_stats(lines)

      @cycles
    end

    def to_h
      {cycles: @cycles}
    end

    private

    def dirs_to_cycle
      options[:dirs_to_cycle]
    end

    def set_global_stats(total)
      return if total.nil?

      @cycles[:total] = total.to_i
      @cycles[:primary] = @cycles[:total]
    end

    def set_granular_stats(lines)
      @cycles[:cycles] = lines.map do |line|
        if line =~ /Possible cyclical dependency (.+) between (.+) and (.+)/
          {object: $1, file1: $2, file2: $3}
        end
      end
    end
  end
end
