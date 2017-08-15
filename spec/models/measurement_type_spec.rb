require "spec_helper"

RSpec.describe Unitize::MeasurementType, type: :model do
  
  it "is valid with valid attributes" do
    expect(FactoryGirl.build(:measurement_type)).to be_valid
  end

	it "is not valid without a name" do
    expect(FactoryGirl.build(:measurement_type, name: nil)).not_to be_valid
  end  

  it "is not valid with an already taken name" do
    measurement_type_1 = FactoryGirl.create(:measurement_type, name: "mp1")
    measurement_type_2 = FactoryGirl.build(:measurement_type, name: "mp1")
    expect(measurement_type_2).not_to be_valid
  end  

end
