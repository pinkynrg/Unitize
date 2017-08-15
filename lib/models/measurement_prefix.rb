require "active_record"

module Unitize
	class MeasurementPrefix < ActiveRecord::Base

		after_create :create_prefix_unitize

	  validates :name, presence: true, uniqueness: true
	  validates :symbol, presence: true, uniqueness: true
	  validates :code, presence: true, uniqueness: true
	  validates :scalar, presence: true, uniqueness: true, numericality: { greater_than: 0 }

	  def to_unitize
			element = {}
			element[:name] = self.name unless self.name.nil?
			element[:symbol] = self.symbol unless self.symbol.nil?
			element[:code] = self.code unless self.code.nil?
			element[:scalar] = self.scalar.to_f unless self.scalar.nil?
			element
		end

		def create_prefix_unitize
			# update prefix in memory
			atom = Unitize::Prefix.new(self.to_unitize)
	    Unitize::Prefix.all.push(atom)
	    Unitize::Expression::Decomposer.send(:reset)
		end

	end
end

Unitize::DBPrefix = Unitize::MeasurementPrefix