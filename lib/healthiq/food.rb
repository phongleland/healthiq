require 'time'

class Healthiq::Food
  
  attr_reader :glycemic_index, :time_ate
  
  MAX_MINUTE = 120
  COEFFICIENT = 0.001
  PRECISION = 2
  
  def self.parse(line)
    parts = line.split(/\t/)
    self.new(
      :time_ate => Time.parse(parts[0]),
      :glycemic_index => parts[1].to_i
    )
  end
  
  def initialize(opts={})
    @time_ate = opts[:time_ate]
    @glycemic_index = opts[:glycemic_index].to_i
  end
  
  def bg_contribution_at(time)
    min = (time - time_ate ) / 60
    return self.bg_contribution_after_minute(min)
  end
  
  protected
  def bg_contribution_after_minute(min)
    min = min.to_i
    return 0 if min <= 0
    return 0 if min > MAX_MINUTE
    return (glycemic_index * min * COEFFICIENT).round(PRECISION)
  end
  
end