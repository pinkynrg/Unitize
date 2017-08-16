require "spec_helper"

describe Unitize::Expression::Matcher do
  describe "::atom(:codes)" do
    subject { Unitize::Expression::Matcher.atom(:code)}
    it "must be an Alternative list" do
      expect(subject).to be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse [in_i]" do
      expect(subject.parse("[in_i]")).to be == "[in_i]"
    end
  end
  describe "::metric_atom(:name)" do
    subject { Unitize::Expression::Matcher.metric_atom(:name)}
    it "must be an Alternative list of names" do
      expect(subject).to be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse 'joule'" do
      expect(subject.parse('joule')).to be == 'joule'
    end
  end

  describe "::prefix(:symbol)" do
    subject { Unitize::Expression::Matcher.prefix(:symbol)}
    it "must be an Alternative list of symbols" do
      expect(subject).to be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse 'h'" do
      expect(subject.parse('h')).to be == 'h'
    end
  end
end
