require "spec_helper"

describe Unitize::Prefix do
  subject { Unitize::Prefix }
  let(:m) { Unitize::Prefix.find('m')}
  describe "::data" do
    it "should be an Array" do
      expect(subject.data).to be_instance_of Array
    end
  end

  describe "::all" do
    it "should be an array of prefixes" do
      expect(subject.all).to be_instance_of Array
      expect(subject.all.first).to be_instance_of Unitize::Prefix
    end
  end

  describe "#scalar" do
    it "should be a number" do
      expect(m.scalar).to be_equal 0.001
    end
  end

end