module MetricFu
  class MetricDeepCover < Metric
    def name
      :deep_cover
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
        mf_debug("DeepCover is not available. See README")
      end
    end

    def activate
      super
    end

    def results_file?
      results_file = 'deep_cover/deep_cover.csv'
      File.exist?(results_file) # ||
      # mf_log("DeepCover file #{results_file.inspect} does not exist")
    end
  end
end
