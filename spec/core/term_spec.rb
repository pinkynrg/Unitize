require "spec_helper"

RSpec.describe Unitize::Unit do

  describe "instance" do

    subject { Unitize::Term.new(:atom => 'J', :prefix => 'k')}

    describe "#atom" do
      it "should be an atom" do
        expect(subject.atom).to be_instance_of Unitize::Atom
      end
    end

    describe "#prefix" do
      it "should be a prefix" do
        expect(subject.prefix).to be_instance_of Unitize::Prefix
      end
    end

    describe "#exponent" do
      it "should be an integer" do
        expect(subject.exponent).to be_equal 1
      end
    end

    describe "#root_terms" do
      it "should be an array of terms" do
        expect(subject.root_terms).to be_kind_of Array
        expect(subject.root_terms.first).to be_instance_of Unitize::Term
      end
    end

    describe "#composition" do
      it "should be a Multiset" do
        expect(subject.composition).to be_instance_of SignedMultiset
      end
    end

    describe "#scale" do
      it "should return value relative to terminal atoms" do
        expect(subject.scalar).to be_equal 1000000.0
      end
    end

    describe "#frozen?" do
      it "should be frozen" do
        expect(subject.frozen?).to be_equal true
      end
    end

    describe "#to_s" do
      it "should return the UCUM code" do
        expect(subject.to_s).to be == "kJ"
      end
    end
  end
end