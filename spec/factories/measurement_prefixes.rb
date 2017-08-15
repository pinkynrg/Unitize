FactoryGirl.define do
  factory :measurement_prefix, class: Unitize::MeasurementPrefix do
  	sequence(:name) { |e| "prefix_#{e}" }
  	sequence(:symbol) { |e| "s#{e}" }
  	sequence(:code) { |e| "p#{e}" }
  	sequence(:scalar) { |e| e }
  end
end
