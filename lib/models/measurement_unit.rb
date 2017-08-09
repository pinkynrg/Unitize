require "active_record"

module Unitize
	class MeasurementUnit < ActiveRecord::Base

		after_save :update_atom_unitize

		belongs_to :measurement_type

		validates :name, presence: true
		validates :code, presence: true, uniqueness: true
		validate :code_validation
		validate :scale_unit_code_validation
		validate :scale_unit_code_presence
		validate :scale_value_presence
		validate :scale_function_from_validation
		validate :scale_function_to_validation

		attr_readonly :code

		def code_validation
			if (self.code && self.scale_unit_code && !self.dim)
				if (self.scale_unit_code.include? self.code)
					errors.add(:code, "can't be contained inside scale_unit_code")
				end
			end
		end

		def scale_unit_code_presence
			if (self.dim.nil?)
	  		errors.add(:scale_unit_code, "is missing") unless self.scale_unit_code
			end
		end

		def scale_unit_code_validation
			if (self.scale_unit_code)
	  		errors.add(:scale_unit, "is not valid") unless Unitize.valid?(self.scale_unit_code)
	  	end
		end

		def scale_value_presence
			if (self.dim.nil?)
	  		errors.add(:scale_value, "is missing") unless self.scale_value
			end
		end

		def scale_value_validation
			if (self.scale_value)
	  		begin
					self.scale_value.to_f  			
	  		rescue Exception => e
		  		errors.add(:scale_value, "is not valid")
	  		end
			end
		end

		def update_atom_unitize
			new_measurement_unit = MeasurementUnit.find(self.id)
			atom = Unitize::Atom.new(new_measurement_unit.to_unitize)
	  	atom.validate! unless new_measurement_unit.dim
			result = Unitize::Atom.find(new_measurement_unit.code)
			if (result)
				Unitize::Atom.all.delete_if do |obj| 
					obj[:code] == new_measurement_unit.code
				end
			end
	    Unitize::Atom.all.push(atom)
	    Unitize::Expression::Decomposer.send(:reset)
	    atom
		end

		def destroy
			atoms = MeasurementUnit.where("scale_unit_code LIKE :code", {code: "%#{self.code}%"})
			raise "Cannot delete atoms with exisiting childs" unless atoms.count == 0
    	# ... ok, go ahead and destroy
    	super
		end

		def scale_function_from_validation
			if (self.scale_function_from)
				result = Dentaku(self.scale_function_from, x: 1)
				errors.add(:scale_function_from, "is not valid") unless !result.nil?
			end
		end

		def scale_function_to_validation
			if (self.scale_function_to)
				result = Dentaku(self.scale_function_to, x: 1)
				errors.add(:scale_function_to, "is not valid") unless !result.nil?
			end
		end

		def to_unitize
			element = {}
			element[:name] = self.name unless self.name.nil?
			element[:property] = self.measurement_type.name unless self.measurement_type.nil?
			element[:code] = self.code unless self.code.nil?
			element[:classification] = self.classification unless self.classification.nil?
			element[:metric] = self.metric unless self.metric.nil?
			element[:special] = self.special unless self.special.nil?
			element[:arbitrary] = self.arbitrary unless self.arbitrary.nil?
			element[:symbol] = self.symbol unless self.symbol.nil?
			element[:dim] = self.dim unless self.dim.nil?
			element[:scale] = {} unless self.scale_function_from.nil? && self.scale_function_to.nil? && self.scale_unit_code.nil? && self.scale_value.nil?
			element[:scale][:function_from] = self.scale_function_from unless self.scale_function_from.nil?
			element[:scale][:function_to] = self.scale_function_to unless self.scale_function_to.nil?
			element[:scale][:value] = self.scale_value unless self.scale_value.nil?
			element[:scale][:unit_code] = self.scale_unit_code unless self.scale_unit_code.nil?
			element
		end

	end
end