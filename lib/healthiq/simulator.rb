class Healthiq::Simulator

  attr_reader :body_inputs, :bg_level, :glycation_level
  
  PRECISION = 2
  NORMAL_LEVEL = 80
  GLYCATION_TRIGGER = 150
  
  def initialize(opts={})
    @bg_level = opts[:bg_level]
    @glycation_level = opts[:glycation_level]
    @body_inputs = []
  end

  def add(input)
    @body_inputs << input
  end
  
  def simulate_readings(t1, t2)
    bg_readings = []
    bg_readings << bg_level
    glycations = []
    glycations << glycation_level
    while t1 <= t2
      bg_reading = normalize(bg_readings.last, bg_contributions_at(t1)).round(PRECISION)
      bg_readings << bg_reading
      glycations << glycation(glycations.last, bg_reading)
      t1 += 60
    end
    
    {:bg => bg_readings, :glycation => glycations }
  end
  
  def glycation(current_glycation, bg_reading)
    if (bg_reading > GLYCATION_TRIGGER)
      return (current_glycation + 1)
    else
      return current_glycation
    end
  end
  
  def normalize(basal_bg_level, contributing_bg_reading)
    if contributing_bg_reading == 0 
      return basal_bg_level if basal_bg_level == NORMAL_LEVEL
      return basal_bg_level - 1 if basal_bg_level > NORMAL_LEVEL
      return basal_bg_level + 1 if basal_bg_level < NORMAL_LEVEL
    else
      return (basal_bg_level + contributing_bg_reading)
    end
  end
  
  def bg_contributions_at(time)
    return body_inputs.map{|item| item.bg_contribution_at(time)}.inject(0) {|sum, i|  sum + i }.round(PRECISION)
  end
end