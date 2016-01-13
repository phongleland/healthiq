require_relative 'spec_helper'

describe "Healthiq::Food" do
  
  describe "#parse" do

    it "should parse correctly" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t47")
      expect(food.time_ate).to eq(Time.utc(2013,12,1,16,19))
      expect(food.glycemic_index).to eq(47)
    end

  end
  
  describe "#bg_contribution_after_minute" do
    
    it "should return 0 if minute param is zero" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t47")
      expect(food.bg_contribution_after_minute(0)).to eq(0)
    end
    
    it "should return 0 if minute param is negative" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t47")
      expect(food.bg_contribution_after_minute(-1)).to eq(0)
    end
    
    it "should return 0 if minute param is gt 120" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t47")
      expect(food.bg_contribution_after_minute(121)).to eq(0)
    end
    
    it "should return a number if minute param is gt than 0 and lte 120" do
      food = Healthiq::Food.parse("2013-12-01T16:19:00Z\t47")
      expect(food.bg_contribution_after_minute(10)).to eq(0.47)
    end
    
  end
  
end