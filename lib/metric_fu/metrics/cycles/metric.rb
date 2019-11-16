module MetricFu
  class MetricCycles < Metric
    def name
      :cycles
    end

    def default_run_options
      dirs_to_cycle = MetricFu::Io::FileSystem.directory("code_dirs") +
        MetricFu::Io::FileSystem.file_globs_to_ignore.map { |dir| '-' + dir }
      {dirs_to_cycle: dirs_to_cycle}
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
