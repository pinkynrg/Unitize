require "spec_helper"

describe Unitize::Expression::Parser do
  subject { Unitize::Expression::Parser.new}
  describe '#metric_atom' do
    it "must match 'N'" do
      expect(subject.metric_atom.parse('N')[:atom_code]).to be == 'N'
    end
  end

  describe '#atom' do
    it "must match '[in_i]'" do
      expect(subject.atom.parse('[in_i]')[:atom_code]).to be == '[in_i]'
    end
  end

  describe '#prefix' do
    it "must match 'k'" do
      expect(subject.prefix.parse('k')[:prefix_code]).to be == 'k'
    end
  end

  describe '#annotation' do
    it "must match '{foobar}'" do
      expect(subject.annotation.parse('{foobar}')[:annotation]).to be == 'foobar'
    end
  end

  describe "#factor" do
    it "must match positives and fixnums" do
      expect(subject.factor.parse('3.2')[:factor]).to be == {fixnum: '3.2'}
    end
    it "must match negatives and integers" do
      expect(subject.factor.parse('-5')[:factor]).to be  == {integer: '-5'}
    end
  end

  describe "#exponent" do
    it "must match positives integers" do
      expect(subject.exponent.parse('4')[:exponent]).to be  == {integer: '4'}
    end
    it "must match negative integers" do
      expect(subject.exponent.parse('-5')[:exponent]).to be  == {integer: '-5'}
    end
  end

  describe "term" do
    it "must match basic atoms" do
      expect(subject.term.parse('[in_i]')[:term][:atom][:atom_code]).to be == '[in_i]'
    end
    it "must match prefixed atoms" do
      match = subject.term.parse('ks')[:term]
      expect(match[:atom][:atom_code]).to be == 's'
      expect(match[:prefix][:prefix_code]).to be == 'k'
    end
    it "must match exponential atoms" do
      match = subject.term.parse('cm3')[:term]
      expect(match[:atom][:atom_code]).to be == 'm'
      expect(match[:prefix][:prefix_code]).to be == 'c'
      expect(match[:exponent][:integer]).to be == '3'
    end
    it "must match factors" do
      expect(subject.term.parse('3.2')[:term][:factor][:fixnum]).to be == '3.2'
    end
    it "must match annotations" do
      match = subject.term.parse('N{Normal}')[:term]
      expect(match[:atom][:atom_code]).to be == 'N'
      expect(match[:annotation]).to be == 'Normal'
    end
  end

  describe '#group' do
    it "must match parentheses with a term" do
      match = subject.group.parse('(s2)')[:group][:nested][:left][:term]
      expect(match[:atom][:atom_code]).to be == 's'
      expect(match[:exponent][:integer]).to be == '2'
    end
    it "must match nested groups" do
      match = subject.group.parse('((kg))')[:group][:nested][:left][:group][:nested][:left][:term]
      expect(match[:atom][:atom_code]).to be == 'g'
      expect(match[:prefix][:prefix_code]).to be == 'k'
    end
    it "must pass exponents down" do
      match = subject.group.parse('([in_i])3')[:group]
      expect(match[:exponent][:integer]).to be == '3'
      expect(match[:nested][:left][:term][:atom][:atom_code]).to be == '[in_i]'
    end
  end

  describe "#expression" do
    it "must match left only" do
      match = subject.expression.parse('m')
      expect(match[:left][:term][:atom][:atom_code]).to be == "m"
    end
    it "must match left + right + operator" do
      match = subject.expression.parse('m.s')
      expect(match[:left][:term][:atom][:atom_code]).to be == "m"
      expect(match[:operator]).to be == '.'
      expect(match[:right][:left][:term][:atom][:atom_code]).to be == 's'
    end
    it "must match operator + right" do
      match = subject.expression.parse("/s")
      expect(match[:operator]).to be == '/'
      expect(match[:right][:left][:term][:atom][:atom_code]).to be == 's'
    end
  end


end