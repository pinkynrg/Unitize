require "spec_helper"

RSpec.describe Unitize::Unit do
	
	let(:ms2) { Unitize::Unit.new("m/s2") }
	let(:kg)  { Unitize::Unit.new("kg") }
	let(:psi) { Unitize::Unit.new("[psi]") }
	let(:deg) { Unitize::Unit.new("deg") }

  describe "#terms" do
    it "must be a collection of terms" do
      expect(ms2).to respond_to :terms
      expect(ms2.terms).to be_kind_of Enumerable
      expect(ms2.terms.first).to be_instance_of Unitize::Term
    end
  end

  describe "#root_terms" do
    it "must be an array of Terms" do
      expect(ms2).to respond_to :terms
      expect(ms2.root_terms).to be_kind_of Array
      expect(ms2.root_terms.first).to be_instance_of Unitize::Term
    end
  end

  describe "#scalar" do
    it "must return value relative to terminal atoms" do
      expect(ms2).to respond_to :scalar
      expect(ms2.scalar).to be_equal 1
      expect(psi.scalar).to be_within(0.0001).of(6894757.293168361)
      expect(deg.scalar).to be_within(0.0001).of(0.0174532925199433)
    end
  end

  describe "#composition" do
    it "must be a multiset" do
      expect(ms2).to respond_to :terms
      expect(ms2.composition).to be_instance_of SignedMultiset
    end
  end

  describe "#dim" do
    it "must be a string representing it's dimensional makeup" do
      expect(ms2.dim).to be == 'm.s-2'
      expect(psi.dim).to be == 'g.m-1.s-2'
    end
  end

  describe "#*" do
    it "should multiply units" do
      mult = kg * ms2
      expect(mult.expression.to_s).to match(/kg.*\/s2/)
      expect(mult.expression.to_s).to match(/m.*\/s2/)
    end
  end

  describe "#/" do
    it "should divide units" do
      div = kg / ms2
      expect(div.expression.to_s).to match(/kg.*\/m/)
      expect(div.expression.to_s).to match(/s2.*\/m/)
    end
  end

  describe "#frozen?" do
    it "should be frozen" do
      kg.scalar
      expect(kg.frozen?).to be_equal true
    end
  end

  describe "#to_s" do
    it "should return an expression in the same mode it was initialized with" do
      ['m', 'mm', '%'].each do |name|
        expect(Unitize::Unit.new(name).to_s).to be_equal(name)
      end
    end

    it "should accept an optional mode to build the expression with" do
      temp_change = Unitize::Unit.new("Cel/h")
      expect(temp_change.to_s(:code)).to be == ("Cel/h")
      expect(temp_change.to_s(:symbol)).to be == ("°C/h")
    end
  end

end