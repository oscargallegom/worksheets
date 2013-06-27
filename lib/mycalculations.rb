module Mycalculations
  def calculations(field)

    fencing_acres = 0
    fencing_functional_acres = 0
    # if permanent pasture and fencing in place
    if (field.field_type_id == 2 && field.is_streambank_fencing_in_place?)
      fencing_acres = field.distance_fence_stream.to_i * field.fence_length.to_i / 43560.0

      if (field.distance_fence_stream > 35 && field.distance_fence_stream <= 100)
        fencing_functional_acres = fencing_acres
      elsif (field.distance_fence_stream > 100)
        fencing_functional_acres = field.fence_length.to_i * 100.0 / 43560.0
      end

    end

    degraded_pasture_acres=0
    # if permanent pasture and no fencing in place
    if (field.field_type_id == 2 && !field.is_streambank_fencing_in_place?)
      degraded_pasture_acres = field.fence_length.to_i * 35.0 / 43560.0
      # do lookup with TRP (TRP = degraded pasture)
    end

    grass_buffer_acres = 0
    grass_buffer_functional_acres = 0

    forrest_buffer_acres = 0
    forrest_buffer_functional_acres = 0
    # if crop or hay
    if (field.field_type_id == 1 && field.field_type_id == 3)
      # if grass buffer
      if (field.is_grass_buffer?)

        grass_buffer_acres = field.grass_buffer_area.to_i
        if (field.grass_buffer_average_width > 35 && field.grass_buffer_average_width <= 100)
          grass_buffer_functional_acres = field.grass_buffer_area.to_i
        elsif (field.grass_buffer_average_width > 100)
          grass_buffer_functional_acres = grass_buffer_length * 100.0 / 43560.0
        end
      end
      # if forrest buffer
      if (field.is_forest_buffer?)
        forrest_buffer_acres = field.forest_buffer_area.to_i

        if (field.forrest_buffer_average_width > 35 && field.forrest_buffer_average_width <= 100)
          forrest_buffer_functional_acres = field.forrest_buffer_area.to_i
        elsif (field.forrest_buffer_average_width > 100)
          forrest_buffer_functional_acres = forrest_buffer_length * 100.0 / 43560.0
        end

      end
    end

    # for forrest, grass and fencing
    # get regular acres * EOSLoadPerAcre
    # for lookup use LandRiverSegment, Landuse
    # if fence use dropdown to find out if forrest or grass

    converted_acres =  fencing_acres + grass_buffer_acres + forrest_buffer_acres + field.wetland_area
    trp_acres = degraded_pasture_acres
    non_converted_acres = field.acres - converted_acres - trp_acres

    # TODO: retrieve values from efficiency_bmps
    # bmp_type (hard-coded for buffer and fencing and wetland), land use
    # fucntional acres * 4 * efficiency for nitrogen * non_converted_acre_load from NTT
    # fucntional acres * 2 * efficiency for sediment and phosphorus * non_converted_acre_load from NTT
    # for wetland use wetland_treated_area * non_converted_acre_load from NTT
    #
    #
    # something


    raise 'Oh no! An error......'

  end
end