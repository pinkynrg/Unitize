# Unitize
Unitize is gem for Rails inspired by the marvelous Unitwise gem, with the only expection that all measurement units are saved on your database. 
Do you have a weird non-linear measurement unit conversion that you want to add to your collection at runtime? With Unitize you can!

## Usage

```ruby
# Create a measurement type:
m_type = Unitize::MeasurementType.create({name: "length"})

# Create a foundamental measurement unit (note that the dim parameter is only for foundamental measurement units): 
f_unit = Unitize::MeasurementUnit.create({
	name: "meter", 
	measurement_type: m_type, 
	code: "m", 
	symbol: "m", 
	dim: "M"
})

# Create a measurement prefix:
prefix = Unitize::MeasurementPrefix.create({
	name: "centi", 
	symbol: "c", 
	code: "c", 
	scalar: "0.01"
})

# Create a derived measurement unit (note that is not derived from the meter, m, but from the centimeter, cm):
d_unit = Unitize::MeasurementUnit.create({
	name: "inch", 
	measurement_type: m_type, 
	code: "in", 
	symbol: "inch", 
	scale_value: "2.539998", 
	scale_unit_code: "cm"
})

# Create a weird special measurement unit:
my_weird_unit = Unitize::MeasurementUnit.create({
	name: "weird length from meter", 
	measurement_type: m_type, 
	code: "wl", 
	symbol: "wl", 
	scale_value: "1", 
	scale_unit_code: "m", 
	scale_function_from: "100+x/2", 		# this should be the inverse function of scale_function_to
	scale_function_to: "2*x-200", 			# this should be the inverse function of scale_function_from
	special: true
})

# It's time to use it:
meter = Unitize(12, "m")
to_centimeter = meter.to("cm")
to_inch = meter.to("in")
to_weird_unit = meter.to("wl")

puts meter.to_s(:name)                   # => 12 meter
puts to_centimeter.to_s(:name)           # => 1200 centimeter
puts inch.to_s(:name)                    # => 39.37 inch
puts to_weird_unit.to_s(:name)           # => -176 weird length from meter
puts to_weird_unit.to("m").to_s(:name)   # => 12 meter
```

All other functionalities have been copied from Unitwise gem. Check it out: https://github.com/joshwlewis/unitwise

## Installation
Add this line to your application's Gemfile:

```ruby
# add the gem to your Gemfile
gem 'unitize'

# bundle it
bundle install

# install the gem
rails g unitize:install

# if you want import 300+ measurement units from UCUM list execute this command too:
rake unitize:import
```

## Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
