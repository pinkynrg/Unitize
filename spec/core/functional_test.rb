require "spec_helper"

describe Unitize::Functional do
  subject { Unitize::Functional }
  {
    
    "Cel":              "K", 
    "[degRe]":          "K", 
    "[degF]":           "K", 
    "[p'diop]":         "deg", 
    "%[slope]":         "deg", 
    "bit_s":            "1",
    "Np":               "1",
    "[hp'_X]":          "1",
    "[pH]":             "mol/l",
    "B":                "1",
    "B[W]":             "W",
    "B[kW]":            "kW",
    # "B[SPL]":           "Pa",
    # "B[V]":             "V",
    # "B[10.nV]":         "nV",
    "[hp'_C]":          "1",
    "[m/s2/Hz^(1/2)]":  "m2/s4/Hz",

  }.each do |unit, base|
    describe unit do
      it 'should convert back and forth' do
        number = rand(1000) / 1000.0
        # expect(Unitize(number,unit).to(base).to(unit).to_f).to be == number
        expect(Unitize(number,unit).to(base).to(unit).to_f).to be_within(0.1).of(number)
      end
    end
  end

end
