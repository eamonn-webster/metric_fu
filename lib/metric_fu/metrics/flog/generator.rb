#
# File: generator.rb
# Author: jscruggs
# Copyright jscruggs, 2008-2018
# Contents:
#
# Date:          Author:  Comments:
#  3rd May 2018  eweb     #0008 save top 5 percent average
#
require "pathname"
require "optparse"

module MetricFu
  class FlogGenerator < Generator
    def self.metric
      :flog
    end

    def emit
      parse_options = FlogCLI.parse_options [
        "--all",
        options[:continue] ? "--continue" : nil,
      ].compact
      @flogger = FlogCLI.new parse_options
      @flogger.flog *files_to_flog
    end

    def analyze
      @method_containers = {}
      @flogger.calculate
      @flogger.each_by_score do |full_method_name, score, operators|
        if full_method_name["#"]
          container_name = full_method_name.split('#').first
        else
          container_name = full_method_name.split('::')[0..-2].join('::')
        end
        path = @flogger.method_locations[full_method_name]
        if @method_containers[container_name]
          @method_containers[container_name].add_method(full_method_name, operators, score, path)
          @method_containers[container_name].add_path(path)
        else
          mc = MethodContainer.new(container_name, path)
          mc.add_method(full_method_name, operators, score, path)
          @method_containers[container_name] = mc
        end
      end
    end

    def to_h
      { flog: { total: @flogger.total_score,
                average: @flogger.average,
                top_5_average: calc_top_five_percent_average,
                primary: @flogger.average.round(3),
                method_containers: sorted_containers } }
    end

    def per_file_info(out)
      @method_containers.each_pair do |_klass, container|
        container.methods.each_pair do |_method_name, data|
          next if data[:path].nil?

          file, line = data[:path].split(":")

          out[file][line] << { type: :flog, description: "Score of %.2f" % data[:score] }
        end
      end
    end

    private

    def calc_top_five_percent_average
      method_scores = @method_containers.values.inject([]) do |scores, container|
        scores + container.methods.values.map { |v| v[:score] }
      end
      method_scores.sort!.reverse!

      five_percent_of_methods = (method_scores.size * 0.05).ceil

      total_for_five_percent =
        method_scores[0...five_percent_of_methods].inject(0) { |total, score| total + score }
      if five_percent_of_methods == 0
        0.0
      else
        total_for_five_percent / five_percent_of_methods.to_f
      end
    end

    def sorted_containers
      @method_containers.values.sort_by(&:highest_score).reverse.map(&:to_h)
    end

    def files_to_flog
      includes = options[:dirs_to_flog].flatten.map do |p|
        next if p[0] == '-'
        if File.directory? p
          Dir[File.join(p, '**/*.{rb,rake}')]
        else
          p
        end
      end.flatten
      excludes = options[:dirs_to_flog].flatten.map do |p|
        next unless p[0] == '-'
        p = p[1..-1]
        if File.directory? p
          Dir[File.join(p, '**/*.{rb,rake}')]
        elsif p['*']
          Dir[p]
        else
          p
        end
      end.flatten
      includes - excludes
    end
  end

  class MethodContainer
    attr_reader :methods

    def initialize(name, path)
      @name = name
      add_path path
      @methods = {}
    end

    def add_path(path)
      return unless path
      @path ||= path.split(":").first
    end

    def add_method(full_method_name, operators, score, path)
      @methods[full_method_name] = { operators: operators, score: score, path: path }
    end

    def to_h
      { name: @name,
        path: @path || "",
        total_score: total_score,
        highest_score: highest_score,
        average_score: average_score,
        methods: @methods }
    end

    def highest_score
      method_scores.max
    end

    private

    def method_scores
      @method_scores ||= @methods.values.map { |v| v[:score] }
    end

    def total_score
      @total_score ||= method_scores.inject(0) { |sum, score| sum + score }
    end

    def average_score
      total_score / method_scores.size.to_f
    end
  end
end
