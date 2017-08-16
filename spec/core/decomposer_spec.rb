require "spec_helper"

describe Unitize::Expression::Decomposer do
  subject { Unitize::Expression::Decomposer }

  describe "#terms" do
    it "should accept codes" do
      fts = subject.new("[ft_i]/s").terms
      expect(fts.count).to be_equal 2
    end
    it "should accept names" do
      kms = subject.new("km/s").terms
      expect(kms.count).to be_equal 2
    end
    it "should accept complex units" do
      complex = subject.new("(mg.(km/s)3/J)2.Pa").terms
      expect(complex.count).to be_equal 5
    end
    it "should accept more complex units" do
      complex = subject.new("4.1(mm/2s3)4.7.3J-2").terms
      expect(complex.count).to be_equal 3
    end
    it "should accept weird units" do
      frequency = subject.new("/s").terms
      expect(frequency.count).to be_equal 1
    end
    it "should accept units with a factor and unit" do
      oddity = subject.new("2ms2").terms
      expect(oddity.count).to be_equal 1
    end
  end

end