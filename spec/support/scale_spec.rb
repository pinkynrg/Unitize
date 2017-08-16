# Shared examples for Unitize::Scale and Unitize::Measurement
module ScaleTests
  def self.included(base)
    base.class_eval do
      subject { described_class.new(4, "J") }

      let(:mph)  { described_class.new(60, '[mi_i]/h') }
      let(:kmh)  { described_class.new(100, 'km/h') }
      let(:mile) { described_class.new(3, '[mi_i]') }
      let(:hpm)  { described_class.new(6, 'h/[mi_i]') }
      let(:cui)  { described_class.new(12, "[in_i]3") }
      let(:cel)  { described_class.new(22, 'Cel') }
      let(:k)    { described_class.new(373.15, 'K') }
      let(:f)    { described_class.new(98.6, '[degF]')}
      let(:r)    { described_class.new(491.67, '[degR]') }

      describe "#new" do
        it "must set attributes" do
          expect(subject.value).to be_equal(4)
          expect(subject.unit.to_s).to be == 'J'
        end
      end

      describe "#unit" do
        it "must be a unit" do
          expect(subject).to respond_to(:unit)
          expect(subject.unit).to be_instance_of(Unitize::Unit)
        end
      end

      describe "#root_terms" do
        it "must be a collection of terms" do
          expect(subject).to respond_to(:root_terms)
          expect(subject.root_terms).to be_kind_of Enumerable
          expect(subject.root_terms.first).to be_instance_of(Unitize::Term)
        end
      end

      describe "#terms" do
        it "must return an array of terms" do
          expect(subject.terms).to be_kind_of(Enumerable)
          expect(subject.terms.first).to be_kind_of(Unitize::Term)
        end
      end

      describe "#atoms" do
        it "must return an array of atoms" do
          expect(subject.atoms).to be_kind_of(Enumerable)
          expect(subject.atoms.first).to be_kind_of(Unitize::Atom)
        end
      end

      describe "#scalar" do
        pending "must return value relative to terminal atoms" do
          expect(subject.scalar).to be_equal 4000
          expect(mph.scalar).to be_within(0.0001).of(26.8224)
          expect(cel.scalar).to be_equal 295.15
        end
      end

      describe "#magnitude" do
        pending "must return the magnitude" do
          expect(mph.magnitude).to be_equal(60)
          expect(cel.magnitude).to be_equal(22)
        end
      end

      describe "#special?" do
        it "must return true when unit is special, false otherwise" do
          expect(subject.special?).to be_equal false
          expect(cel.special?).to be_equal true
        end
      end

      describe "#depth" do
        it "must return a number indicating how far down the rabbit hole goes" do
          expect(subject.depth).to be_equal 11
          expect(k.depth).to be_equal 3
        end
      end

      describe "#frozen?" do
        it "must be frozen" do
          expect(subject.frozen?).to be_equal true
        end
      end

      describe "#simplified_value" do
        it "must simplify to an Integer" do
          result = described_class.new(4.0, '[ft_i]').simplified_value
          expect(result).to be_equal 4
          expect(result).to be_kind_of(Integer)
        end

        it "must simplify to a Float" do
          result = described_class.new(BigDecimal("1.5"), '[ft_i]').simplified_value
          expect(result).to be_equal 1.5
          expect(result).to be_kind_of(Float)
        end
      end

      describe "#inspect" do
        it "must show the unit and value" do
          result = described_class.new(12,'m').inspect
          expect(result).to include("value=12")
          expect(result).to include("unit=m")
        end
      end
    end
  end
end
