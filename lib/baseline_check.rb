module BaselineCheck


	#not functional....fix this nasty method
	def does_farm_meet_baseline(farm)
		meets = []
		farm_messages = Hash.new
		farm_messages[:field_errors] = Hash[farm.fields.map{|f| [f.name, f.does_field_meet_baseline[:errors]]}]
		farm.fields.each do |field|
			if farm_messages[:field_errors][field.name].empty?
				meets << true
			else
				meets << false
			end
		end
		loads = check_loads(farm)
		if loads[:n_below_baseline] < 0
			farm_messages[:n_errors] = 'Current N Load is greater than Baseline N Load.'
			farm_messages[:meets_n_baseline] = false
		else
			farm_messages[:meets_n_baseline] = true
		end
		if loads[:p_below_baseline] < 0
			farm_messages[:p_errors] = 'Current P Load is greater than Baseline P Load.'
			farm_messages[:meets_p_baseline] = false
		else
			farm_messages[:meets_p_baseline] = true
		end
		if loads[:sediment_below_baseline] < 0
			farm_messages[:s_errors] = 'Current sediment Load is greater than Baseline sediment Load.'
			farm_messages[:meets_sediment_baseline] = false
		else
			farm_messages[:meets_sediment_baseline] = true
		end
		farm_messages[:meets_baseline] = !meets.include?(false)
		return farm_messages
	end

	def does_farm_meet_n_baseline(farm)
		baseline = does_farm_meet_baseline(farm)
		if baseline[:meets_baseline] && baseline[:meets_n_baseline]
			return true
		else
			return false
		end
	end

	def does_farm_meet_p_baseline(farm)
		baseline = does_farm_meet_baseline(farm)
		if baseline[:meets_baseline] && baseline[:meets_p_baseline]
			return true
		else
			return false
		end
	end

	def does_farm_meet_sediment_baseline(farm)
		baseline = does_farm_meet_baseline(farm)
		if baseline[:meets_baseline] && baseline[:meets_sediment_baseline]
			return true
		else
			return false
		end
	end

	# def disp_field_errors(farm)
	# 	err = []
	# 	farm_messages = does_farm_meet_baseline(farm)
	# 	err << farm_messages[:errors]
	# 	farm.fields.each do |field|
	# 		field.does_field_meet_baseline[:errors].each do |error|
	# 			err << "Field #{field.name}: #{error}"
	# 		end
	# 	end

	# 	return err.flatten
	# end


	def check_loads(farm)
		loads = Hash.new
		loads[:n_below_baseline] = farm.baseline_n_load - farm.current_n_load
		loads[:p_below_baseline] = farm.baseline_p_load - farm.current_p_load
		loads[:sediment_below_baseline] = farm.baseline_s_load - farm.current_s_load
		return loads
	end

	# this got moved to the Field model as a Field class method......because reasons......
	# def does_field_meet_baseline
	# 	@messages = Hash.new
	# 	@messages[:meets_baseline] = true
	# 	@messages[:errors] = Array.new
	# 	@checked_bmp = false
	# 	@checked_setback = false
	# 	@checked_hel = false
	# 	if self.field_type_id
	# 		get_field_type
	# 	end
	# 	return @messages
	# end	

	def get_field_type
		if self.field_type_id
			if is_crop_or_hay_or_pasture?
				if is_field_pasture?
					virginia_or_maryland(:pasture)
				else
					virginia_or_maryland(:crop_or_hay)
				end
			elsif is_animal?
				virginia_or_maryland(:animal)
			else
				#@messages[:meets_baseline] = true
			end
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
		adj_to_stream(state, :crop)
	end

	def animal(state)
		check_livestocks(state)
		if state == :maryland
			check_poultry
		end
	end

	def check_livestocks(state)
		if state == :maryland

			if (!self.field_livestocks.empty? && !self.is_livestock_animal_waste_management_system) || (!self.field_poultry.empty? && (!self.is_poultry_animal_waste_management_system || !self.is_poultry_mortality_composting))
				@messages[:meets_baseline] = false
				@messages[:errors] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless the animal headquarters has both a properly sized and maintained animal waste management system and mortality composting in addition to meeting any and all applicable requirements under Maryland' 's Nutrient Management Regulations and CAFO rule.'
			end
		else
			if (!self.field_livestocks.empty? && !self.is_livestock_animal_waste_management_system) || (!self.field_poultry.empty? && (!self.is_poultry_animal_waste_management_system))
				@messages[:meets_baseline] = false
				@messages[:errors] << 'Per Virginia Nutrient Management regulations, your farm cannot meet baseline unless the farm cannot meet baseline unless the animal headquarters has both a properly sized and maintained animal waste management system and mortality composting in addition to meeting any and all applicable requirements under Maryland' 's Nutrient Management Regulations and CAFO rule.'
			end
		end

	end

	def check_poultry
		if (!self.field_poultry.empty? && !self.is_poultry_heavy_use_pads)
				@messages[:meets_baseline] = false
				@messages[:errors] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless heavy use pads are in place'
		end
	end

	def is_crop_or_hay_or_pasture?
		self.field_type_id < 4
	end

	def is_animal?
		self.field_type_id == 4
	end

	def is_field_pasture?
		self.field_type_id == 2
	end

	def check_if_fert
		current_strips = self.strips.where(:is_future => false)
		current_strips.each do |strip|
            strip.crop_rotations.each do |crop_rotation|
            	crop_rotation.manure_fertilizer_applications.each do |manure_fertilizer_application|
            		check_if_manure_incorp(manure_fertilizer_application)
            	end
            	if !crop_rotation.commercial_fertilizer_applications.empty?
            		if !@checked_bmp
            			is_fert_setback
            		end
            	else
            		if !@checked_bmp
            			soil_conservation_bmp
						@checked_bmp = true
					end
				end
            end
        end
	end

	def is_fert_setback
		if self.is_pasture_adjacent_to_stream?
			if self.is_fertilizer_application_setback
				if !@checked_bmp
					soil_conservation_bmp
					@checked_bmp = true
				end
			else
				if !@checked_setback
					@messages[:meets_baseline] = false
					@messages[:errors] << 'According to Maryland Nutrient Management regulations, baseline cannot be met unless there is either a 10 or 35-ft setback, depending on whether a \'directed\' application method is used or not, between the field where the fertilizer is applied and adjacent surface waters and streams.'
					@checked_setback = true
					if !@checked_bmp
						soil_conservation_bmp
						@checked_bmp = true
					end
				end
			end
		else
			if !@checked_bmp
				soil_conservation_bmp
				@checked_bmp = true
			end
		end
	end

	def check_this_for_nil(*args)
		self[args]
	end

	def hel_soils?
		self.send :check_this_for_nil, :hel_soils
	end

	def check_if_manure_incorp(manure)
		if manure.is_incorporated
			if !@checked_setback
				is_fert_setback
				@checked_setback = true
			end
		else
			if self.hel_soils
				if !@checked_setback
					is_fert_setback
					@checked_setback = true
				end
			else
				if !@checked_hel
					unless self.field_type_id == 3
						if !self.is_field_pasture?
							@messages[:meets_baseline] = false
							@messages[:errors] << 'According to Maryland Nutrient Management regulations, baseline cannot be met unless manure is incorporated within 48 hours; exceptions apply to permanent pasture, hay production fields, and highly erodible soils (HELs).'
						end
					end
					@checked_hel = true
				end
				if !@checked_bmp
					soil_conservation_bmp
					@checked_bmp = true
				end
			end
			if !@checked_setback
					is_fert_setback
					@checked_setback = true
			end
		end
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
				if field_type == :pasture
					if !self.is_streambank_fencing_in_place
						@messages[:errors] << 'According to Maryland Nutrient Management regulations, baseline cannot be met unless there is either fencing or an alternative animal exclusion along a streambank.'
						@messages[:meets_baseline] = false
					end
				else 
					is_streambank_fencing(state)
				end
			end
		else
			if state == :virginia
				#@messages[:meets_baseline] = true
			else
				@checked_bmp = false
				@checked_setback = false
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
			if state == :virginia
				@messages[:errors] << 'According to Virginia statute, baseline cannot be met unless there is either fencing or an alternative animal exclusion along a streambank.'
				@messages[:meets_baseline] = false
			else
				check_if_fert
			end
		end
	end

	def grass_or_forest_buffer
		if self.is_forest_buffer? || self.is_grass_buffer?
			#@messages[:meets_baseline] = true
		else
			@messages[:meets_baseline] = false
			@messages[:errors] << 'According to Virginia statute, baseline cannot be met unless there is a streamside buffer in place.'
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
			@messages[:errors] << 'Field cannot meet baseline unless both a current and valid Soil and Water Conservation Plan is in place and has been checked on the current BMP tab.'
		end
	end

end


