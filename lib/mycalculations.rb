module Mycalculations

  def calculations(field)
  end

  def calculations2(field)

    # call NTT to get the latest values
    total_n = 0
    total_p = 0
    sediment = 0
    success, content =  callNtt(field)    # TODO: error handling
    if (success)
      @results = Hash.from_xml((content.xpath('//Results')).to_s)['Results']
      if (@results['ErrorCode'] != '0')
        # error
      else
        total_n = @results['OrganicN'].to_f + @results['NO3'].to_f + @results['TileDrainN'].to_f
        total_p = @results['OrganicP'].to_f + @results['SolubleP'].to_f + @results['TileDrainP'].to_f
        sediment = @results['Sediment'].to_f
      end
    end

    fencing_acres = 0
    fencing_functional_acres = 0
    # if permanent pasture and fencing in place
    if (field.field_type_id == 2 && field.is_streambank_fencing_in_place?)
      fencing_acres = field.distance_fence_stream.to_f * field.fence_length.to_f / 43560.0

      if (field.vegetation_type_fence_stream_id == 1)    # if forest
        stream_forest_n_conversion = field.watershedsegment.total_n_forest * fencing_acres
        stream_forest_p_conversion = field.watershedsegment.total_p_forest * fencing_acres
        stream_forest_sediment_conversion = field.watershedsegment.total_sediment_forest * fencing_acres
      else      # grass
        stream_hyo_n_conversion = field.watershedsegment.total_n_hyo * fencing_acres
        stream_hyo_p_conversion = field.watershedsegment.total_p_hyo * fencing_acres
        stream_hyo_sediment_conversion = field.watershedsegment.total_sediment_hyo * fencing_acres
      end

      if (field.distance_fence_stream > 35 && field.distance_fence_stream <= 100)
        fencing_functional_acres = fencing_acres
      elsif (field.distance_fence_stream > 100)
        fencing_functional_acres = field.fence_length.to_f * 100.0 / 43560.0
      end
    end

    degraded_pasture_acres = 0
    # if permanent pasture and no fencing in place
    if (field.field_type_id == 2 && !field.is_streambank_fencing_in_place?)
      degraded_pasture_acres = field.fence_length.to_i * 35.0 / 43560.0
      trp_n_conversion = field.watershedsegment.total_n_trp * degraded_pasture_acres
      trp_p_conversion = field.watershedsegment.total_p_trp * degraded_pasture_acres
      trp_sediment_conversion = field.watershedsegment.total_sediment_trp * degraded_pasture_acres
    end

    grass_buffer_acres = 0
    grass_buffer_functional_acres = 0

    forrest_buffer_acres = 0
    forrest_buffer_functional_acres = 0
    # if crop or hay
    if (field.field_type_id == 1 && field.field_type_id == 3)
      # if grass buffer
      if (field.is_grass_buffer?)

        grass_buffer_acres = field.grass_buffer_area.to_f

        buffer_hyo_n_conversion = field.watershedsegment.total_n_hyo * grass_buffer_acres
        buffer_hyo_p_conversion = field.watershedsegment.total_p_hyo * grass_buffer_acres
        buffer_hyo_sediment_conversion = field.watershedsegment.total_sediment_hyo * grass_buffer_acres

        if (field.grass_buffer_average_width > 35 && field.grass_buffer_average_width <= 100)
          grass_buffer_functional_acres = field.grass_buffer_area.to_i
        elsif (field.grass_buffer_average_width > 100)
          grass_buffer_functional_acres = grass_buffer_length * 100.0 / 43560.0
        end
      end
      # if forrest buffer
      if (field.is_forrest_buffer?)
        forest_buffer_acres = field.forest_buffer_area.to_f

        buffer_forest_n_conversion = field.watershedsegment.total_n_forest * forest_buffer_acres
        buffer_forest_p_conversion = field.watershedsegment.total_p_forest * forest_buffer_acres
        buffer_forest_sediment_conversion = field.watershedsegment.total_sediment_forest * forest_buffer_acres

        if (field.forest_buffer_average_width > 35 && field.forest_buffer_average_width <= 100)
          forest_buffer_functional_acres = field.forrest_buffer_area.to_i
        elsif (field.forest_buffer_average_width > 100)
          forest_buffer_functional_acres = forest_buffer_length * 100.0 / 43560.0
        end

      end
    end

    # for all if wetland
    if (field.is_wetland)
      wetland_forest_n_conversion = field.watershedsegment.total_n_forest * field.wetland_area.to_f
      wetland_forest_p_conversion = field.watershedsegment.total_p_forest * field.wetland_area.to_f
      wetland_forest_sediment_conversion = field.watershedsegment.total_sediment_forest * field.wetland_area.to_f
    end

    # total converted land
    total_converted_acres = [fencing_acres + degraded_pasture_acres + grass_buffer_acres + forest_buffer_acres, field.acres].min
    unconverted_acres =  field.acres.to_f - total_converted_acres

        # TODO: lookup to get values for grass streambank
    # BmpEfficiencyLookup
    n_reduction = 123
    p_reduction = 123
    sediment_reduction = 123

    upland_streambank_grass_n_reduction = 4 * total_n * fencing_functional_acres * n_reduction
    upland_streambank_grass_p_reduction = 4 * total_p * fencing_functional_acres * p_reduction
    upland_streambank_grass_sediment_reduction = 4 * total_sediment * fencing_functional_acres * sediment_reduction

    # TODO: lookup to get values for forest streambank
    n_reduction = 123
    p_reduction = 123
    sediment_reduction = 123

    upland_streambank_forest_n_reduction = 4 * total_n * fencing_functional_acres * n_reduction
    upland_streambank_forest_p_reduction = 4 * total_p * fencing_functional_acres * p_reduction
    upland_streambank_forest_sediment_reduction = 4 * total_sediment * fencing_functional_acres * sediment_reduction

    # TODO: lookup to get values for grass buffer same as for streambank
    BmpEfficiencyLookup
    n_reduction = 123
    p_reduction = 123
    sediment_reduction = 123

    upland_grass_buffer_n_reduction = 4 * total_n * grass_buffer_functional_acres * n_reduction
    upland_grass_buffer_p_reduction = 4 * total_p * grass_buffer_functional_acres * p_reduction
    upland_grass_buffer_sediment_reduction = 4 * total_sediment * grass_buffer_functional_acres * sediment_reduction

    # TODO: lookup to get values for forest as for streambank
    n_reduction = 123
    p_reduction = 123
    sediment_reduction = 123

    upland_forest_buffer_n_reduction = 4 * total_n * forest_buffer_functional_acres * n_reduction
    upland_forest_buffer_p_reduction = 4 * total_p * forest_buffer_functional_acres * p_reduction
    upland_forest_buffer_sediment_reduction = 4 * total_sediment * forest_buffer_functional_acres * sediment_reduction

    # wetland lookup
    wetland_ratio = field.wetland_area.to_f / (field.wetland_area.to_f + field.wetland_treated_area.to_f)
    # TODO: do lookup
    efficiency_n = 123
    efficiency_p = 123
    efficiency_sediment = 123

    upland_wetland_n_reduction= field.wetland_treated_area.to_f * efficiency_n
    upland_wetland_p_reduction= field.wetland_treated_area.to_f * efficiency_p
    upland_wetland_sediment_reduction= field.wetland_treated_area.to_f * efficiency_sediment


    new_total_n = ((unconverted_acres * total_n) - upland_streambank_grass_n_reduction - upland_streambank_forest_n_reduction - upland_grass_buffer_n_reduction - upland_forest_buffer_n_reduction - upland_wetland_n_reduction) / (unconverted_acres)
    new_total_p = ((unconverted_acres * total_p) - upland_streambank_grass_p_reduction - upland_streambank_forest_p_reduction - upland_grass_buffer_p_reduction - upland_forest_buffer_p_reduction - upland_wetland_p_reduction) / (unconverted_acres)
    new_total_sediment = ((unconverted_acres * total_sediment) - upland_streambank_grass_sediment_reduction - upland_streambank_forest_sediment_reduction - upland_grass_buffer_sediment_reduction - upland_forest_buffer_sediment_reduction - upland_wetland_sediment_reduction) / (unconverted_acres)

    # TODO: data check


    # for forrest, grass and fencing
    # get regular acres * EOSLoadPerAcre
    # for lookup use LandRiverSegment, Landuse
    # if fence use dropdown to find out if forrest or grass

    converted_acres = fencing_acres + grass_buffer_acres + forrest_buffer_acres + field.wetland_area
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