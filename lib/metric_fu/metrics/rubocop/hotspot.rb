class MetricFu::RubocopHotspot < MetricFu::Hotspot
  COLUMNS = %w{times_changed}

  def columns
    COLUMNS
  end

  def name
    :rubocop
  end

  def map_strategy
    :present
  end

  def reduce_strategy
    :sum
  end

  def score_strategy
    :calculate_score
  end

  def calculate_score(metric_ranking, item)
    flat_rubocop_score = 0.50
    metric_ranking.scored?(item) ? flat_rubocop_score : 0
  end

  def generate_records(data, table)
    return if data == nil
    Array(data[:changes]).each do |change|
      table << {
        "metric" => :churn,
        "times_changed" => change[:times_changed],
        "file_path" => change[:file_path]
      }
    end
  end

  def present_group(group)
    "detected high level of rubocop (changed #{group[0].times_changed} times)"
  end
end
