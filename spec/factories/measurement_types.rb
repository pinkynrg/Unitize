FactoryGirl.define do
  factory :measurement_type, class: Unitize::MeasurementType do
  	sequence(:name) { |e| "type_#{e}" }
  end
end
