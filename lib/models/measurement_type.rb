require "active_record"

module Unitize
	class MeasurementType < ActiveRecord::Base
	  validates :name, presence: true, uniqueness: true
	end
end