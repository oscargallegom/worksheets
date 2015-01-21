module Calculations

	def self.grass_buffer_calcs(field)
		Rails.logger.debug "@(#%*#(@$%*@#(%*#$(%*@$#%(@#*%(@#%*@#(%*@#(%*@(#%*@(#%*@(#%*@(#%*@#(%*@#*%@#%"

		grass_buffer_acres = field.grass_buffer_area.to_f

        buffer_hyo_n_conversion = field.watershed_segment.total_n_hyo * grass_buffer_acres
        buffer_hyo_p_conversion = field.watershed_segment.total_p_hyo * grass_buffer_acres
        buffer_hyo_sediment_conversion = field.watershed_segment.total_sediment_hyo * grass_buffer_acres

        if (field.grass_buffer_average_width >= 35 && field.grass_buffer_average_width <= 100)
          grass_buffer_functional_acres = field.grass_buffer_area.to_f
        elsif (field.grass_buffer_average_width > 100)
          grass_buffer_functional_acres = field.grass_buffer_length * 100.0 / 43560.0
        end

        return grass_buffer_acres, buffer_hyo_n_conversion, buffer_hyo_p_conversion, buffer_hyo_sediment_conversion, grass_buffer_functional_acres
	end

	def self.grass_buffer_calcs_future(field)
		grass_buffer_acres_future = field.grass_buffer_area_future.to_f

        buffer_hyo_n_conversion_future = field.watershed_segment.total_n_hyo * grass_buffer_acres_future
        buffer_hyo_p_conversion_future = field.watershed_segment.total_p_hyo * grass_buffer_acres_future
        buffer_hyo_sediment_conversion_future = field.watershed_segment.total_sediment_hyo * grass_buffer_acres_future

        if (field.grass_buffer_average_width_future >= 35 && field.grass_buffer_average_width_future <= 100)
          grass_buffer_functional_acres_future = field.grass_buffer_area_future.to_f
        elsif (field.grass_buffer_average_width_future > 100)
          grass_buffer_functional_acres_future = field.grass_buffer_length_future * 100.0 / 43560.0
        end

        return grass_buffer_acres_future, buffer_hyo_n_conversion_future, buffer_hyo_p_conversion_future, buffer_hyo_sediment_conversion_future, grass_buffer_functional_acres_future
	end

end