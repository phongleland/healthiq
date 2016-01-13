require_relative 'spec_helper'

describe "Healthiq::Exercise" do
  
  describe "#parse" do

    it "should parse correctly" do
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t47")
      expect(exercise.time_ate).to eq(Time.utc(2013,12,1,16,19))
      expect(exercise.exercise_index).to eq(47)
    end

  end
  
  describe "#bg_contribution_after_minute" do
    
    it "should return 0 if minute param is zero" do
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t47")
      expect(exercise.bg_contribution_after_minute(0)).to eq(0)
    end
    
    it "should return 0 if minute param is negative" do
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t47")
      expect(exercise.bg_contribution_after_minute(-1)).to eq(0)
    end
    
    it "should return 0 if minute param is gt 60" do
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t47")
      expect(exercise.bg_contribution_after_minute(61)).to eq(0)
    end
    
    it "should return a number if minute param is gt than 0 and lte 60" do
      exercise = Healthiq::Exercise.parse("2013-12-01T16:19:00Z\t47")
      expect(exercise.bg_contribution_after_minute(10)).to eq(-0.47)
    end
    
  end
  
end