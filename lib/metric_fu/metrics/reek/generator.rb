module MetricFu
  class ReekGenerator < Generator
    def self.metric
      :reek
    end

    def emit
      files = files_to_analyze
      if files.empty?
        mf_log "Skipping Reek, no files found to analyze"
        @output = run!([], config_files)
      else
        @output = run!(files, config_files)
      end
    end

    def run!(files, config_files)
      cmd = "reek"
      if config_files.first
        cmd = "#{cmd} --config #{config_files.first}"
      end
      cmd = "#{cmd} --format json #{files.join(' ')}"
      json_text = `#{cmd}`
      JSON.parse(json_text)
    end

    def analyze
      @matches = @output.group_by{|x| x['source']}.collect do |file_path, smells|
        { file_path: file_path,
          code_smells: analyze_smells(smells) }
      end
    end

    def to_h
      { reek: { matches: @matches } }
    end

    def per_file_info(out)
      @matches.each do |file_data|
        file_path = file_data[:file_path]
        next if File.extname(file_path) =~ /\.erb|\.html|\.haml/
        begin
          line_numbers = MetricFu::LineNumbers.new(File.read(file_path), file_path)
        rescue StandardError => e
          raise e unless e.message =~ /you shouldn't be able to get here/
          mf_log "ruby_parser blew up while trying to parse #{file_path}. You won't have method level reek information for this file."
          next
        end

        file_data[:code_smells].each do |smell_data|
          line = line_numbers.start_line_for_method(smell_data[:method])
          out[file_data[:file_path]][line.to_s] << { type: :reek,
                                                     description: "#{smell_data[:type]} - #{smell_data[:message]}" }
        end
      end
    end

    private

    def files_to_analyze
      dirs_to_reek = options[:dirs_to_reek]
      files_to_reek = dirs_to_reek.map { |dir| Dir[File.join(dir, "**", "*.rb")] }.flatten
      remove_excluded_files(files_to_reek)
    end

    # TODO: Check that specified line config file exists
    def config_files
      Array(options[:config_file_pattern])
    end

    def analyze_smells(smells)
      smells.collect(&method(:smell_data))
    end

    def smell_data(smell)
      { method: smell['context'],
        message: smell['message'],
        type: smell_type(smell),
        lines: smell['lines'] }
    end

    def smell_type(smell)
      return smell.subclass if smell.respond_to?(:subclass)

      smell['smell_type']
    end
  end
end
