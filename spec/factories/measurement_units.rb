FactoryGirl.define do

  factory :measurement_unit, class: Unitize::MeasurementUnit do

  	sequence(:name) { |e| "unit_#{e}" }
  	sequence(:code) { |e| "code_#{e.to_s.split("").map { |e| ('a'..'z').to_a[e.to_i] }.join }" }
    sequence(:dim)  { |e| "dim_#{e}" }
    metric true
    measurement_type

    trait :derived do
      dim nil
      scale_value 1
	    sequence(:scale_unit_code) { FactoryGirl.create(:measurement_unit).code }
  	end

    trait :special do
      dim nil
      scale_value 1
      scale_function_from "x"
      scale_function_to "x"
      sequence(:scale_unit_code) { FactoryGirl.create(:measurement_unit).code }
    end

  end
end
