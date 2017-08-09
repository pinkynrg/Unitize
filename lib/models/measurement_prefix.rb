require "active_record"

module Unitize
	class MeasurementPrefix < ActiveRecord::Base
	  validates :name, presence: true, uniqueness: true
	  validates :symbol, presence: true, uniqueness: true
	  validates :code, presence: true, uniqueness: true
	  validates :scalar, presence: true, uniqueness: true

	  def to_unitize
			element = {}
			element[:name] = self.name unless self.name.nil?
			element[:symbol] = self.symbol unless self.symbol.nil?
			element[:code] = self.code unless self.code.nil?
			element[:scalar] = self.scalar.to_f unless self.scalar.nil?
			element
		end

	end
end