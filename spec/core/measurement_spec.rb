require "spec_helper"
require "support/scale_spec"

describe Unitize::Measurement do
  let(:described_class) { Unitize::Measurement }
  include ScaleTests

  describe "#new" do
    it "should raise an error for unknown units" do
      expect{ Unitize::Measurement.new(1,"funkitron") }.to raise_error(Unitize::ExpressionError)
    end
  end

  describe "#convert_to" do
    it "must convert to a similar unit code" do
      expect(mph.convert_to('km/h').value).to be_within(0.0001).of(96.56063)
    end
    it "must raise an error if the units aren't similar" do
      expect{ mph.convert_to('N') }.to raise_error(Unitize::ConversionError)
    end
    pending "must convert special units to their base units" do
      expect(cel.convert_to('K').value).to be_equal 295.15
    end
    pending "must convert base units to special units" do
      expect(k.convert_to('Cel').value).to be_equal 100
    end
    it "must convert special units to special units" do
      expect(f.convert_to('Cel').value).to be_within(0.0001).of(37)
    end
    it "must convert special units to non-special units" do
      expect(cel.convert_to("[degR]").value).to be_within(0.0001).of(531.27)
    end
    it "must convert derived units to special units" do
      expect(r.convert_to("Cel").value).to be_within(0.0001).of(0)
    end
    it "must convert to a unit of another measurement" do
      expect(mph.convert_to(kmh).value).to be_within(0.0001).of(96.56064)
    end
    pending "must convert to and from another unit without losing precision" do
      circle = Unitize::Measurement.new(1, "circ")
      expect(circle.to("deg").to("circ")).to be_equal circle

      meter = Unitize::Measurement.new(10, "meter")
      expect(meter.to("[mi_i]").to_("m")).to be_equal meter
    end
  end

  describe "#*" do
    it "must multiply by scalars" do
      mult = mph * 4
      expect(mult.value).to be_equal 240
      expect(mult.unit).to be == Unitize::Unit.new("[mi_i]/h")
    end
    it "must multiply similar units" do
      mult = mph * kmh
      expect(mult.value).to be_within(0.0001).of(3728.22715342)
      expect(mult.unit).to be == Unitize::Unit.new("([mi_i]/h).([mi_i]/h)")
    end
    it "must multiply unsimilar units" do
      mult = mph * mile
      expect(mult.value).to be_equal 180
      expect(mult.unit).to be == Unitize::Unit.new("[mi_i]2/h")
    end
    it "must multiply canceling units" do
      mult = mph * hpm
      expect(mult.value).to be_equal 360
      expect(mult.unit.to_s).to be == "1"
    end
  end

  describe "#/" do
    it "must divide by scalars" do
      div = kmh / 4
      expect(div.value).to be_equal 25
      expect(div.unit).to be == kmh.unit
    end
    it "must divide by the value of similar units" do
      div = kmh / mph
      expect(div.value).to be_within(0.0001).of(1.03561865)
      expect(div.unit.to_s).to be == '1'
    end
    it "must divide dissimilar units" do
      div = mph / hpm
      expect(div.value).to be_equal 10
      expect(div.unit.to_s).to be == "[mi_i]2/h2"
    end
  end

  describe "#+" do
    it "must add values when units are similar" do
      added = mph + kmh
      expect(added.value).to be_within(0.0001).of(122.13711922)
      expect(added.unit).to be == mph.unit
    end
    it "must raise an error when units are not similar" do
      expect {mph + hpm}.to raise_error(TypeError)
    end
  end

  describe "#-" do
    it "must add values when units are similar" do
      added = mph - kmh
      expect(added.value).to be_within(0.0001).of(-2.1371192)
      expect(added.unit).to be == mph.unit
    end
    it "must raise an error when units are not similar" do
      expect {mph - hpm}.to raise_error(TypeError)
    end
  end

  describe "#**" do
    it "must raise to a power" do
      exp = mile ** 3
      expect(exp.value).to be_equal 27
      expect(exp.unit.to_s).to be == "[mi_i]3"
    end
    pending "must raise to a negative power" do
      exp = mile ** -3
      expect(exp.value).to be_equal 0.037037037037037035
      expect(exp.unit.to_s).to be == "1/[mi_i]3"
    end
    it "must not raise to a weird power" do
      expect{mile**'weird'}.to raise_error(TypeError)
    end
  end

  describe "#coerce" do

    let(:meter) { Unitize::Measurement.new(1, 'm') }

    it "must coerce numerics" do
      expect(5 * meter).to be == Unitize::Measurement.new(5, 'm')
    end
    it "should raise an error for other crap" do
      expect{ meter.coerce("foo") }.to raise_error(TypeError)
    end
  end

  describe "equality" do

    let(:m)    { Unitize::Measurement.new(1,'m') }
    let(:feet) { Unitize::Measurement.new(20, '[ft_i]') }
    let(:mm)   { Unitize::Measurement.new(1000,'mm') }
    let(:foot) { Unitize::Measurement.new(1,'[ft_i]') }
    let(:g)    { Unitize::Measurement.new(1,'g') }

    it "should be ==" do
      expect(m == m).to be true
      expect(m == mm).to be false
      expect(m == foot).to be false
      expect(m == g).to be false
    end
    it "should be ===" do
      expect(m == m).to be true
      expect(m === mm).to be false
      expect(m === foot).to be false
      expect(m == g).to be false
    end
    it "should be equal?" do
      expect(m.equal?(m)).to be true
      expect(m.equal?(mm)).to be false
      expect(m.equal?(foot)).to be false
      expect(m.equal?(g)).to be false
    end
    it "should be eql?" do
      expect(m.eql?(m)).to be true
      expect(m.eql?(mm)).to be false
      expect(m.eql?(foot)).to be false
      expect(m.eql?(g)).to be false
    end
  end

  describe "#method_missing" do

    let(:meter) { Unitize::Measurement.new(1, 'm')}

    pending "must convert 'to_mm'" do
      convert = meter.to_mm
      expect(convert).to be_instance_of Unitize::Measurement
      expect(convert.value).to be_equal 1000
    end

    it "must convert 'to_foot'" do
      convert = meter.to("[ft_i]")
      expect(convert).to be_instance_of Unitize::Measurement
      expect(convert.value).to be_within(0.0001).of(3.280839895)
    end

    it "must not convert 'foo'" do
      expect{ meter.foo }.to raise_error(NoMethodError)
    end

    it "must not convert 'to_foo'" do
      expect{ meter.to_foo }.to raise_error(NoMethodError)
    end

  end

  describe "#round" do
    it "must round Floats to Integers" do
      result = Unitize::Measurement.new(98.6, "[degF]").round
      expect(result.value).to be_equal(99)
      expect(result.value).to be_kind_of(Integer)
    end
    it "must round Floats to Floats" do
      if RUBY_VERSION > '1.8.7'
        result = Unitize::Measurement.new(17.625, "J").round(2)
        expect(result.value).to be_equal(17.63)
        expect(result.value).to be_kind_of(Float)
      end
    end
  end
  describe "#to_f" do
    it "must convert to a float" do
      expect(f.to_f).to be_kind_of(Float)
    end
  end

  describe "#to_i" do
    it "must convert to an integer" do
      expect(k.to_i).to be_kind_of(Integer)
    end
  end

  describe "#to_r" do
    it "must convert to a rational" do
      expect(cel.to_r).to be_kind_of(Rational)
    end
  end

  describe "#to_s" do
    it "should include the simplified value and use the mode it was created with" do
      foot = described_class.new(7.00, "[gal_us]")
      expect(foot.to_s).to be == "7 [gal_us]"
      meter = described_class.new(BigDecimal("3.142"), "m")
      expect(meter.to_s).to be == "3.142 m"
    end
    it "should accept a mode and print that mode string" do
      temp = described_class.new(25, "Cel")
      expect(temp.to_s(:code)).to be == "25 Cel"
      expect(temp.to_s(:symbol)).to be == "25 °C"
    end
    it "should fallback when there is no value for the provided mode" do
      vol = described_class.new(12, "[tsp_us]")
      expect(vol.to_s(:symbol)).to be == "12 [tsp_us]"
    end
    it "should not return '1 1' for dimless measurements" do
      dimless = described_class.new(1, "1")
      expect(dimless.to_s).to be == "1"
    end
  end

end
