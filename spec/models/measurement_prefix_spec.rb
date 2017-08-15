require "spec_helper"

RSpec.describe Unitize::MeasurementPrefix, type: :model do
  
  it "is valid with valid attributes" do
    expect(FactoryGirl.build(:measurement_prefix)).to be_valid
  end

	it "is not valid without a name" do
    expect(FactoryGirl.build(:measurement_prefix, name: nil)).not_to be_valid
  end  

	it "is not valid with an already taken name" do
    measurement_prefix_1 = FactoryGirl.create(:measurement_prefix, name: "mp1")
    measurement_prefix_2 = FactoryGirl.build(:measurement_prefix, name: "mp1")
    expect(measurement_prefix_2).not_to be_valid
  end  

  it "is not valid without a code" do
    expect(FactoryGirl.build(:measurement_prefix, code: nil)).not_to be_valid
  end  

  it "is not valid with an already taken code" do
    measurement_prefix_1 = FactoryGirl.create(:measurement_prefix, code: "mp1")
    measurement_prefix_2 = FactoryGirl.build(:measurement_prefix, code: "mp1")
    expect(measurement_prefix_2).not_to be_valid
  end  

  it "is not valid if scalar is not a positive number" do
    expect(FactoryGirl.build(:measurement_prefix, scalar: -1)).not_to be_valid
    expect(FactoryGirl.build(:measurement_prefix, scalar: 0)).not_to be_valid
    expect(FactoryGirl.build(:measurement_prefix, scalar: 1)).to be_valid
    expect(FactoryGirl.build(:measurement_prefix, scalar: 100)).to be_valid
    expect(FactoryGirl.build(:measurement_prefix, scalar: 1024)).to be_valid
  end

end
