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

		def code_validation
			if (!self.dim)
				# if code can resolve it shound't be used to create a basic code for another unit
				if (self.code_changed? && Unitize.valid?(self.code))
					errors.add(:code, "not available. Pick another one")
				end
			end
		end

		def scale_unit_code_presence
			if (self.dim.nil?)
	  		errors.add(:scale_unit_code, "is mandatory if dim is nil") unless self.scale_unit_code
			end
		end

		def scale_unit_code_validation
			# TODO: on update check if the atom scale_unit_code is referencing itself to avoid recursion
			if (self.scale_unit_code)
	  		errors.add(:scale_unit_code, "is not valid") unless Unitize.valid?(self.scale_unit_code)
	  	end
		end

		def scale_value_presence
			if (self.dim.nil?)
	  		errors.add(:scale_value, "is mandatory if dim is nil") unless self.scale_value
			end
		end

		def scale_value_validation
			if (self.scale_value)
	  		begin
					self.scale_value.to_f  			
	  		rescue Exception => e
		  		errors.add(:scale_value, "it has to be a number (Integer, Float, Rational, ...)")
	  		end
			end
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

		def update_atom_unitize
			# update children scale code
			if (self.id && self.code_changed?)
				self.update_children(self.code_was, self.code)
			end

			# update atom in memory
			atom = Unitize::Atom.new(self.to_unitize)
			if (Unitize::Atom.find(self.code_was))
				Unitize::Atom.all.delete_if do |obj| 
					obj[:code] == self.code_was
				end
			end
	    Unitize::Atom.all.push(atom)
	    Unitize::Expression::Decomposer.send(:reset)
		end

		def update_children(old_code, new_code)
			Unitize::Atom.children(old_code).each do |e|
				
				# process regex
				prefixes = Unitize::Prefix.all.map { |e| e.code }.join("|")
				old_code_escaped = old_code.gsub("[","\\[").gsub("]","\\]").gsub("*","\\*")
				scale_unit_code = e.scale.unit.to_s.gsub(/(?:^|(?<=\.|\/|[0-9]|#{prefixes}))(#{old_code_escaped})(?:(?=-|\.|\/|[0-9])|$)/, new_code)

				# update on db
				mu = MeasurementUnit.find_by(code: e.code)
				mu.scale_unit_code = scale_unit_code
				mu.save(validate: false)

			end
		end

		def destroy
			raise "Cannot delete atoms with exisiting childs" unless Unitize::Atom.children(self.code).count == 0
    	Unitize::Atom.all.delete_if do |obj| 
				obj[:code] == self.code
			end
    	super
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

Unitize::DBAtom = Unitize::MeasurementUnit