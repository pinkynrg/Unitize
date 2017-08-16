namespace :unitize do
	
  desc "Import Default Units"
  task :import => :environment do
		
		###################################################################################################
  	# import prefixes #################################################################################
  	###################################################################################################
  	
  	final =  YAML.load(File.open Unitize::Prefix.data_file).flatten.map do |e|
			flatten_hash(e)			
		end

		final.each { |e| 
			el = Unitize::MeasurementPrefix.create({
				name: e['name'], 
				symbol: e['symbol'],
				code: e['code'],
				scalar: e['scalar'],
			}) 
			
			if (el.errors.count > 0)
				puts "[#{e['name']}] #{el.errors.details}"
			end
		}

  	###################################################################################################
  	# import atoms ####################################################################################
  	###################################################################################################

		final = YAML.load(File.open Unitize::Atom.data_file).flatten.map do |e|
			flatten_hash(e)			
		end

		final.each { |e| 

			mt = nil
			if (e['property'])
				mt = Unitize::MeasurementType.find_or_create_by(name: e['property'])
			end

			el = Unitize::MeasurementUnit.create({
			 	name: e['name'], 
				measurement_type_id: mt ? mt.id : nil,
				code: e['code'],
				scale_value: e[:'scale.value'],
				scale_unit_code: e[:'scale.unit_code'],
				classification: e['classification'],
				metric: !!e['metric'],
				base: !!e['dim'],
				symbol: e['symbol'],
				scale_function_from: e[:'scale.function_from'],
				scale_function_to: e[:'scale.function_to'],
			}) 
			
			if (el.errors.count > 0)
				puts "[#{e['name']}] #{el.errors.details}"
			end
		}

		###################################################################################################
  	###################################################################################################

  end

  def flatten_hash(hash)
		hash.each_with_object({}) do |(k, v), h|
	    if v.is_a? Hash
	      flatten_hash(v).map do |h_k, h_v|
	        h["#{k}.#{h_k}".to_sym] = h_v
	      end
	    else 
	      h[k] = v
	    end
		end
	end

end