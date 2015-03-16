include CalculateLoads

module BaselineCheck


	#not functional....fix this nasty method
	def does_farm_meet_baseline(farm)
		meets = []
		farm_messages = Hash.new
		farm_messages[:errors] = []
		farm.fields.each do |field|
			meets << field.does_field_meet_baseline[:meets_baseline]
			field_name = field.name.to_sym
			farm_messages[field_name] = field.does_field_meet_baseline[:errors]
		end
		loads = check_loads(farm)
		if loads[:n_below_baseline] < 0
			farm_messages[:errors] << "Current N Load is greater than Baseline N Load."
			meets << false
		end
		if loads[:p_below_baseline] < 0
			farm_messages[:errors] << "Current P Load is greater than Baseline P Load."
			meets << false
		end
		if loads[:sediment_below_baseline] < 0
			farm_messages[:errors] << "Current sediment Load is greater than Baseline sediment Load."
			meets << false
		end
		farm_messages[:meets_baseline] = !meets.include?(false)
		return farm_messages
	end


	def check_loads(farm)
		loads = Hash.new
		totals = get_current_totals(farm)
		loads[:n_below_baseline] = totals[:baseline_n_load_fields] - totals[:current_n_load_fields]
		loads[:p_below_baseline] = totals[:baseline_p_load_fields] - totals[:current_p_load_fields]
		loads[:sediment_below_baseline] = totals[:baseline_sediment_load_fields] - totals[:current_sediment_load_fields]
		return loads
	end


	def does_field_meet_baseline
		@messages = Hash.new
		@messages[:meets_baseline] = true
		@messages[:errors] = []
		get_field_type
		return @messages
	end	

	def get_field_type
		if is_crop_or_hay_or_pasture?
			if is_field_pasture?
				virginia_or_maryland(:pasture)
			else
				virginia_or_maryland(:crop_or_hay)
			end
		else
			#@messages[:meets_baseline] = true
		end
	end

	def virginia_or_maryland(fn)
		virginia_or_maryland = lambda do |fn, a, b|
			a.send(fn, b)
		end
		if self.maryland?
			maryland = virginia_or_maryland.curry.(fn)
			maryland.(self, :maryland)
		elsif self.virginia?
			virginia = virginia_or_maryland.curry.(fn)
			virginia.(self, :virginia)
		end
	end

	def pasture(state)
		adj_to_stream(state, :pasture)
	end

	def crop_or_hay(state)
		if state == :maryland
			check_if_fert
		elsif state == :virginia
			adj_to_stream(state, :crop)
		end
	end

	def is_crop_or_hay_or_pasture?
		self.field_type_id < 4
	end

	def is_field_pasture?
		self.field_type_id == 2
	end

	def check_if_fert
		@incorp = true
		@checked_bmp = false
		@checked_setback = false
		self.strips.each do |strip|
            strip.crop_rotations.each do |crop_rotation|
            	crop_rotation.manure_fertilizer_applications.each do |manure_fertilizer_application|
            		if @incorp
            			@incorp, @checked_setback = check_if_manure_incorp(manure_fertilizer_application, @incorp, @checked_setback)
            		end
            	end
            	if !crop_rotation.commercial_fertilizer_applications.empty?
            		if !@checked_bmp
            			@checked_bmp, @checked_setback = is_fert_setback(@checked_bmp, @checked_setback)
            		end
            	end
            end
        end
	end

	def is_fert_setback(checked_bmp, checked_setback)
		if self.is_pasture_adjacent_to_stream?
			if self.is_fertilizer_application_setback
				if !checked_bmp
					soil_conservation_bmp
					checked_bmp = true
				end
			else
				if !checked_setback
					@messages[:meets_baseline] = false
					@messages[:errors] << "According to Maryland Nutrient Management regulations, baseline cannot be met unless there is either a 10 or 35-ft setback, depending on whether a 'directed' application method is used or not, between the field where the fertilizer is applied and adjacent surface waters and streams."
					checked_setback = true
				end
			end
		else
			if !checked_bmp
				soil_conservation_bmp
				checked_bmp = true
			end
		end
		return [checked_bmp, checked_setback]
	end

	def check_this_for_nil(*args)
		self[args]
	end

	def hel_soils?
		self.send :check_this_for_nil, :hel_soils
	end

	def check_if_manure_incorp(manure, incorp, setback)
		checked_bmp = false
		setback = false
		if manure.is_incorporated
			if !setback
				is_fert_setback(checked_bmp, setback)
				setback = true
			end
		else
			if self.hel_soils?
				if !setback
					is_fert_setback(checked_bmp, setback)
					setback = true
				end
			else
				if incorp
					@messages[:meets_baseline] = false
					@messages[:errors] << "According to Maryland Nutrient Management regulations, baseline cannot be met unless manure is incorporated within 48 hours; exceptions apply to permanent pasture, hay production fields, and highly erodible soils (HELs)."
					incorp = false
					puts "testing incorp: #{incorp}"
				end
			end
		end
		return incorp, setback
	end

	def adj_to_stream(state, field_type)
		if self.is_pasture_adjacent_to_stream?
			if state == :virginia
				if field_type == :pasture
					is_streambank_fencing(:virginia)
				else
					grass_or_forest_buffer
				end
			else
				is_streambank_fencing(state)
			end
		else
			if state == :virginia
				#@messages[:meets_baseline] = true
			else
				check_if_fert
			end
		end
	end

	def is_streambank_fencing(state)
		if self.is_streambank_fencing_in_place
			if state == :virginia
				#@messages[:meets_baseline] = true
			else
				soil_conservation_bmp
			end
		else
			@messages[:meets_baseline] = false
			if state == :virginia
				@messages[:errors] << "According to Virginia statute, baseline cannot be met unless there is either fencing or an alternative animal exclusion along a streambank."
			else
				@messages[:errors] << "Pasture is adjacent to stream and does not have streambank fencing"
			end
		end
	end

	def grass_or_forest_buffer
		if self.is_forest_buffer? || self.is_grass_buffer?
			#@messages[:meets_baseline] = true
		else
			@messages[:meets_baseline] = false
			@messages[:errors] << "According to Virginia statute, baseline cannot be met unless there is a streamside buffer in place."
		end
	end

	def soil_conservation_bmp
		check_field_bmps_for_soil_conservation
	end

	def check_field_bmps_for_soil_conservation
		has_bmp = false
		self.bmps.each do |bmp|
			if (bmp.bmp_type_id == 8)
              has_bmp = true
            end
        end
        if has_bmp
        	#@messages[:meets_baseline] = true
        else
        	@messages[:meets_baseline] = false
			@messages[:errors] << "Field cannot meet baseline unless both a current and valid Soil and Water Conservation Plan is in place and has been checked on the current BMP tab."
		end
	end

end


