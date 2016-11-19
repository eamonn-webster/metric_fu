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
      super
    end

    def activate
      super
    end
  end
end
