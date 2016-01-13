require_relative 'spec_helper'

describe 'Healthiq::Simulator' do
  before do
    @simulator = Healthiq::Simulator.new({:bg_level => 80, :glycation_level => 0 })
  end
  
  describe '#add' do
    it "should add input to body_input array" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t50")
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t70")
      @simulator.add(food)
      @simulator.add(exercise)
      expect(@simulator.body_inputs.count).to eq(2)
    end
  end
  
  describe "#bg_contributions_at" do
    it "should sum up readings from all body_inputs" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t50")
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t70")
      @simulator.add(food)
      @simulator.add(exercise)
      # 1 minute after
      # 0.05 + -0.07
      expect(@simulator.bg_contributions_at(Time.utc(2013,12,1,16,20))).to eq(-0.02)
      # 2 minute after
      # 0.10 + -0.14
      expect(@simulator.bg_contributions_at(Time.utc(2013,12,1,16,21))).to eq(-0.04)
    end
    
  end
  
  describe "#normalize" do
    it "shoudld return sum if contributing number is greater than 0" do
      expect(@simulator.normalize(1, 2)).to eq(3)
    end
    it "should return basal + 1 if contributing is 0 and basal lt 80" do
      expect(@simulator.normalize(5, 0)).to eq(6)
    end
    it "should return basal - 1 if contributing is 0 and basal gt 80" do
      expect(@simulator.normalize(88, 0)).to eq(87)
    end
    it "should return basal  if contributing is 0 and basal eq 80" do
      expect(@simulator.normalize(80, 0)).to eq(80)
    end
  end
  
  describe "#glycation" do
    it "should return current glycation if bg_level is lt 150" do
      expect(@simulator.glycation(33, 100)).to eq(33)
    end
    it "should return current glycation if bg_level is eq 150" do
      expect(@simulator.glycation(33, 150)).to eq(33)
    end
    it "should return current glycation + 1 if bg_level is gt 150" do
      expect(@simulator.glycation(33, 151)).to eq(34)
    end
  end
  
  
  describe "#simulate_readings" do
    it "should return array of readings" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t50")
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t70")
      @simulator.add(food)
      @simulator.add(exercise)
      # 4 hours of readings
      readings = @simulator.simulate_readings(Time.utc(2013,12,1,16,20), Time.utc(2013,12,1,22,21))
      p readings
      bg_readings = readings[:bg]
      glycation_readings = readings[:glycation]
      expect(bg_readings[0]).to eq( 80 )
      expect(bg_readings[1]).to eq( 79.98 )
      expect(bg_readings[2]).to eq( 79.94 )

    end
  end
  
end