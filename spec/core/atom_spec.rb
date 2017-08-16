require "spec_helper"

RSpec.describe Unitize::Atom do
  
  subject { Unitize::Atom }

  describe "::data" do
    pending "must have data" do
      expect(subject.data).to be_instance_of Array
      expect(subject.data.count).to be == Unitize::MeasurementUnit.all.count
    end
  end

  describe "::all" do
    it "must be an Array of instances" do
      expect(subject.all).to be_instance_of Array
      expect(subject.all.first).to be_instance_of Unitize::Atom
    end
  end

  describe "::find" do
    it "must find atoms" do
      expect(subject.find("m")).to be_instance_of Unitize::Atom
      expect(subject.find("V")).to be_instance_of Unitize::Atom
    end
  end

  let(:second)  { Unitize::Atom.find("s") }
  let(:yard)    { Unitize::Atom.find("[yd_i]")}
  let(:pi)      { Unitize::Atom.find("[pi]")}
  let(:celsius) { Unitize::Atom.find("Cel")}
  let(:pfu)     { Unitize::Atom.find("[PFU]")}
  let(:joule)   { Unitize::Atom.find("J")}
  
  describe "#scale" do
    it "must be nil for base atoms" do
      expect(second.scale).to be_nil
    end
    it "sould be a Scale object for derived atoms" do
      expect(yard.scale).to be_instance_of Unitize::Scale
    end
    it "must be a FunctionalScale object for special atoms" do
      expect(celsius.scale).to be_instance_of Unitize::Functional
    end
  end

  describe "#base?" do
    it "must be true for base atoms" do
      expect(second.base?).to be_equal true
    end
    it "must be false for derived atoms" do
      expect(yard.base?).to be_equal false
      expect(pi.base?).to be_equal false
    end
  end

  describe "#derived?" do
    it "must be false for base atoms" do
      expect(second.derived?).to be_equal false
    end
    it "must be true for derived atoms" do
      expect(yard.derived?).to be_equal true
      expect(celsius.derived?).to be_equal true
    end
  end

  describe "#metric?" do
    it "must be true for base atoms" do
      expect(second.metric?).to be_equal true
    end
    it "must be false for english atoms" do
      expect(yard.metric?).to be_equal false
    end
  end

  describe "#special?" do
    it "must be true for special atoms" do
      expect(celsius.special?).to be_equal true
    end
    it "must be false for non-special atoms" do
      expect(second.special?).to be_equal false
    end
  end

  describe "#arbitrary?" do
    it "must be true for arbitrary atoms" do
      expect(pfu.arbitrary?).to be_equal true
    end
    it "must be false for non-arbitrary atoms" do
      expect(yard.arbitrary?).to be_equal false
      expect(celsius.arbitrary?).to be_equal false
    end
  end

  describe "#terminal?" do
    it "must be true for atoms without a valid measurement atom" do
      expect(second.terminal?).to be_equal true
      expect(pi.terminal?).to be_equal true
    end
    it "must be false for child atoms" do
      expect(yard.terminal?).to be_equal false
    end
  end

  describe "#scalar" do
    it "must return scalar relative to terminal atom" do
      expect(second.scalar).to be_equal 1
      expect(yard.scalar).to be_within(0.001).of(0.9144)
      expect(pi.scalar).to be_within(0.001).of(3.141592653589793)
    end
  end

  describe "#dim" do
    it "must return the dim" do
      expect(second.dim).to be == 'T'
      expect(yard.dim).to be  == 'L'
      expect(joule.dim).to be == 'L2.M.T-2'
    end
  end

  describe "#frozen?" do
    it "should be frozen" do
      expect(second.frozen?).to be_equal true
    end
  end

  describe "validate!" do
    it "returns true for a valid atom" do
      atom = Unitize::Atom.new(
        code: "warp",
        name: "Warp",
        scale: {
          value: 1,
          unit_code: "[c]"
        }
      )

      expect(atom.validate!).to be_equal true
    end

    it "returns an error for an atom with missing properties" do
      atom = Unitize::Atom.new(names: "hot dog")
      expect { atom.validate! }.to raise_error(Unitize::DefinitionError)
    end

    it "returns an error for an atom that doesn't resolve" do
      atom = Unitize::Atom.new(
        code: "feels",
        name: "feels",
        scale: {
          value: 1,
          unit_code: "hearts"
        }
      )
      expect { atom.validate! }.to raise_error(Unitize::DefinitionError)
    end
  end
end
