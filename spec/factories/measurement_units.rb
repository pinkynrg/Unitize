FactoryGirl.define do
  factory :measurement_unit, class: Unitize::MeasurementUnit do
  	sequence(:name) { |e| "unit_#{e}" }
  	sequence(:code) { |e| "code_#{e}" }
    sequence(:dim) { |e| e }
    sequence(:metric) { |e| true }
    measurement_type
  	
    trait :derived do
      dim { |e| nil }
      sequence(:scale_value) { |e| 1 }
	    sequence(:scale_unit_code) { |e| FactoryGirl.create(:measurement_unit, code: "base_code_#{e}").code }
  	end

  end
end
