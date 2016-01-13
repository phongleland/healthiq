class Healthiq::Simulator

  attr_reader :body_inputs
  
  def initialize
    @body_inputs = []
  end

  def add(input)
   
    @body_inputs << input
    
  end
end