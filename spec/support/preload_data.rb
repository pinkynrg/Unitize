require "spec_helper"

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
	
		###################################################################################################
  	# import prefixes #################################################################################
  	###################################################################################################
  	
  	final = YAML.load(File.open Unitize::Prefix.data_file).flatten.map do |e|
			flatten_hash(e)			
		end

		final.select { |e| 
			["c","k","m","d","n"].include? e["code"]
		}.each { |e| 
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

		final.select { |e| 
			[	"K","m","s","g","[g]","[in_i]","[lbf_av]","[lb_av]","[gr]","[psi]","[pi]",
				"rad","deg","10*", "%","s","min","h","Cel","J","N","V","C","[yd_i]","[ft_i]",
				"[PFU]","[c]","[degRe]","[degF]","[p'diop]","%[slope]","bit_s","Np","[hp'_X]",
				"[pH]","mol","l","B","W","B[W]","B[kW]","B[SPL]","Pa","B[V]","B[10.nV]",
				"[hp'_C]","[m/s2/Hz^(1/2)]","Hz","[mi_i]","circ","[degR]","[tsp_us]",
				"[tbs_us]","[foz_us]","[gil_us]","[pt_us]","[qt_us]","[gal_us]"].include? e["code"] 
		}.each { |e| 

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
				special: !!e['special'],
				arbitrary: !!e['arbitrary'],
				symbol: e['symbol'],
				scale_function_from: e[:'scale.function_from'],
				scale_function_to: e[:'scale.function_to'],
				dim: e['dim'],
			}) 
			
			if (el.errors.count > 0)
				puts "[#{e['name']}] #{el.errors.details}"
			end
		}
