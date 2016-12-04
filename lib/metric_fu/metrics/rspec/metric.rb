module MetricFu
  class MetricRspec < Metric
    def name
      :rspec
    end

    def default_run_options
      {
        ignore_files: [],
        data_directory: MetricFu::Io::FileSystem.scratch_directory(name)
      }
    end

    def has_graph?
      true
    end

    def enable
      if results_file?
        super
      else
        mf_debug("Rspec is not available. See README")
      end
    end

    def activate
      super
    end

    def results_file?
      results_file = 'tmp/rspec.json'
      File.exist?(results_file) # ||
      # mf_log("Rspec file #{results_file.inspect} does not exist")
    end
  end
end
