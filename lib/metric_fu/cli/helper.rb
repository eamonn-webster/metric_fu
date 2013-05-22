require 'metric_fu'
require 'metric_fu/cli/parser'
# see https://github.com/grosser/pru/blob/master/bin/pru
module MetricFu
  module Cli
    class Helper
      def initialize
        @metric_fu = MetricFu::Run.new
      end
      def run(options={})
        @metric_fu.run(options)
        complete
      end
      def version
        MetricFu::VERSION
      end
      def shutdown
        out "\nShuting down. Bye"
        exit(1)
      end
      def banner
        "MetricFu: A Fistful of code metrics"
      end
      def usage
        <<-EOS
        #{banner}
        Use --help for help
        EOS
      end
      def executable_name
        'metric_fu'
      end

      def metrics
        MetricFu.configuration.metrics.sort_by(&:to_s)
      end

      def process_options(argv=ARGV.dup)
        options = MetricFu::Cli::MicroOptParse::Parser.new do |p|
            p.banner = self.banner
            p.version = self.version
            p.option :run, "Run all metrics with defaults", :default => false
            metrics.each do |metric|
              p.option metric.to_sym, "Enables or disables #{metric.to_s}", :default => true #, :value_in_set => [true, false]
            end
            p.option :open, "Open report in browser", :default => true
        end.process!(argv)
        options
      end

      private
      def out(text)
        STDOUT.puts text
      end
      def error(text)
        STDERR.puts text
      end
      def complete
        out "all done"
        exit(0)
      end
    end
  end
end
