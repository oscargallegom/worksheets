module BmpCalculations

  def computeBmpCalculations(field)

    # call NTT to get the latest values
    total_n_per_acre = 0
    total_p_per_acre = 0
    total_sediment_per_acre = 0

    success, content = callNtt(field) # TODO: error handling

    if (success)
      @ntt_results = Hash.from_xml(content.xpath('//Results').to_s)['Results']
      if (@ntt_results['ErrorCode'] != '0')
        # TODO: uncomment
        raise 'Error calling NTT.'
      else
        total_n_per_acre = @ntt_results['OrganicN'].to_f + @ntt_results['NO3'].to_f + @ntt_results['TileDrainN'].to_f
        total_p_per_acre = @ntt_results['OrganicP'].to_f + @ntt_results['SolubleP'].to_f + @ntt_results['TileDrainP'].to_f
        total_sediment_per_acre = @ntt_results['Sediment'].to_f

        # add the crops information
        crops = Array.new()
        content.xpath('//Crops').each do |crop|
          crops.push(Hash.from_xml(crop.to_s)['Crops'])
        end
        @ntt_results[:crops] = crops
      end
    else
      # TODO: uncomment
      raise 'Error calling NTT.'
    end

    # TODO: remove test values
    if (session[:debug])
      total_n_per_acre = 25
      total_p_per_acre = 25
      total_sediment_per_acre =25
    end

    # otherwise throw error
    # TODO: Mindy to find out about adjustment factor
    total_adjusted_n_per_acre = total_n_per_acre
    total_adjusted_p_per_acre = total_p_per_acre
    total_adjusted_sediment_per_acre = total_sediment_per_acre

    fencing_acres = 0
    fencing_functional_acres = 0

    stream_forest_n_conversion = 0
    stream_forest_p_conversion = 0
    stream_forest_sediment_conversion = 0

    stream_hyo_n_conversion = 0
    stream_hyo_p_conversion = 0
    stream_hyo_sediment_conversion = 0

    # if permanent pasture and fencing in place
    if (field.field_type_id == 2 && field.is_pasture_adjacent_to_stream && field.is_streambank_fencing_in_place?)
      fencing_acres = field.distance_fence_stream.to_f * field.fence_length.to_f / 43560.0

      if (field.vegetation_type_fence_stream_id == 1) # if forest
        stream_forest_n_conversion = field.watershed_segment.total_n_forest * fencing_acres
        stream_forest_p_conversion = field.watershed_segment.total_p_forest * fencing_acres
        stream_forest_sediment_conversion = field.watershed_segment.total_sediment_forest * fencing_acres
      else # grass
        stream_hyo_n_conversion = field.watershed_segment.total_n_hyo * fencing_acres
        stream_hyo_p_conversion = field.watershed_segment.total_p_hyo * fencing_acres
        stream_hyo_sediment_conversion = field.watershed_segment.total_sediment_hyo * fencing_acres
      end

      if (field.distance_fence_stream >= 35 && field.distance_fence_stream <= 100)
        fencing_functional_acres = fencing_acres
      elsif (field.distance_fence_stream > 100)
        fencing_functional_acres = field.fence_length.to_f * 100.0 / 43560.0
      end
    end

    degraded_pasture_acres = 0

    trp_n_conversion = 0
    trp_p_conversion = 0
    trp_sediment_conversion = 0


    # if permanent pasture and no fencing in place
    if (field.field_type_id == 2 && !field.is_streambank_fencing_in_place?)
      degraded_pasture_acres = field.fence_length.to_f * 35.0 / 43560.0

      trp_n_conversion = field.watershed_segment.total_n_trp * degraded_pasture_acres
      trp_p_conversion = field.watershed_segment.total_p_trp * degraded_pasture_acres
      trp_sediment_conversion = field.watershed_segment.total_sediment_trp * degraded_pasture_acres
    end

    # grass and forest buffer
    grass_buffer_acres = 0
    grass_buffer_functional_acres = 0

    buffer_hyo_n_conversion= 0
    buffer_hyo_p_conversion =0
    buffer_hyo_sediment_conversion = 0

    forest_buffer_acres = 0
    forest_buffer_functional_acres = 0

    buffer_forest_n_conversion=0
    buffer_forest_p_conversion = 0
    buffer_forest_sediment_conversion =0

    # if crop or hay
    if (field.field_type_id == 1 || field.field_type_id == 3)
      # if grass buffer
      if (field.is_grass_buffer?)

        grass_buffer_acres = field.grass_buffer_area.to_f

        buffer_hyo_n_conversion = field.watershed_segment.total_n_hyo * grass_buffer_acres
        buffer_hyo_p_conversion = field.watershed_segment.total_p_hyo * grass_buffer_acres
        buffer_hyo_sediment_conversion = field.watershed_segment.total_sediment_hyo * grass_buffer_acres

        if (field.grass_buffer_average_width >= 35 && field.grass_buffer_average_width <= 100)
          grass_buffer_functional_acres = field.grass_buffer_area.to_f
        elsif (field.grass_buffer_average_width > 100)
          grass_buffer_functional_acres = grass_buffer_length * 100.0 / 43560.0
        end
      end
      # if forest buffer
      if (field.is_forest_buffer?)
        forest_buffer_acres = field.forest_buffer_area.to_f

        buffer_forest_n_conversion = field.watershed_segment.total_n_forest * forest_buffer_acres
        buffer_forest_p_conversion = field.watershed_segment.total_p_forest * forest_buffer_acres
        buffer_forest_sediment_conversion = field.watershed_segment.total_sediment_forest * forest_buffer_acres

        if (field.forest_buffer_average_width >= 35 && field.forest_buffer_average_width <= 100)
          forest_buffer_functional_acres = field.forest_buffer_area.to_f
        elsif (field.forest_buffer_average_width > 100)
          forest_buffer_functional_acres = forest_buffer_length * 100.0 / 43560.0
        end

      end
    end

    wetland_forest_n_conversion= 0
    wetland_forest_p_conversion = 0
    wetland_forest_sediment_conversion = 0

    # for all if wetland
    if (field.is_wetland)
      wetland_forest_n_conversion = field.watershed_segment.total_n_forest * field.wetland_area.to_f
      wetland_forest_p_conversion = field.watershed_segment.total_p_forest * field.wetland_area.to_f
      wetland_forest_sediment_conversion = field.watershed_segment.total_sediment_forest * field.wetland_area.to_f
    end

    # total converted land
    total_converted_acres = [fencing_acres + degraded_pasture_acres + grass_buffer_acres + forest_buffer_acres, field.acres].min
    total_unconverted_acres = field.acres.to_f - total_converted_acres

    total_n_for_converted_acre = stream_forest_n_conversion + stream_hyo_n_conversion + trp_n_conversion + buffer_hyo_n_conversion + buffer_forest_n_conversion + wetland_forest_n_conversion
    total_p_for_converted_acre = stream_forest_p_conversion + stream_hyo_p_conversion + trp_p_conversion + buffer_hyo_p_conversion + buffer_forest_p_conversion + wetland_forest_p_conversion
    total_sediment_for_converted_acre = (stream_forest_sediment_conversion + stream_hyo_sediment_conversion + trp_sediment_conversion + buffer_hyo_sediment_conversion + buffer_forest_sediment_conversion + wetland_forest_sediment_conversion) / 2000.0


    ###################################################
    # Upland acres reduction
    ###################################################

    field_type_id = field.field_type_id
    if (field.field_type_id == 1) # if crop, check for high/low till
      field_type_id = field.crop_type_id + 10 # 11 = high till, 12 = low till
    end

    hgmr_code = field.watershed_segment.hgmr_code

    # 100 = forest buffer
    bmp_efficiency_for_forest = BmpEfficiencyLookup.where(:bmp_type_id => 100, :field_type_id => field_type_id, :hgmr_code => hgmr_code).first

    n_reduction_for_forest = bmp_efficiency_for_forest[:n_reduction].to_f
    p_reduction_for_forest = bmp_efficiency_for_forest[:p_reduction].to_f
    sediment_reduction_for_forest = bmp_efficiency_for_forest[:sediment_reduction].to_f

    # 101 = grass buffer
    bmp_efficiency_for_grass = BmpEfficiencyLookup.where(:bmp_type_id => 101, :field_type_id => field_type_id, :hgmr_code => field.watershed_segment.hgmr_code).first

    n_reduction_for_grass = bmp_efficiency_for_grass[:n_reduction].to_f
    p_reduction_for_grass = bmp_efficiency_for_grass[:p_reduction].to_f
    sediment_reduction_for_grass = bmp_efficiency_for_grass[:sediment_reduction].to_f

    # streambank grass
    upland_streambank_grass_n_reduction = 4 * total_adjusted_n_per_acre * fencing_functional_acres * n_reduction_for_grass
    upland_streambank_grass_p_reduction = 2 * total_adjusted_p_per_acre * fencing_functional_acres * p_reduction_for_grass
    upland_streambank_grass_sediment_reduction = 2 * total_adjusted_sediment_per_acre * fencing_functional_acres * sediment_reduction_for_grass

    # streambank forest
    upland_streambank_forest_n_reduction = 4 * total_adjusted_n_per_acre * fencing_functional_acres * n_reduction_for_forest
    upland_streambank_forest_p_reduction = 2 * total_adjusted_p_per_acre * fencing_functional_acres * p_reduction_for_forest
    upland_streambank_forest_sediment_reduction = 2 * total_adjusted_sediment_per_acre * fencing_functional_acres * sediment_reduction_for_forest

    # grass buffer
    upland_grass_buffer_n_reduction = 4 * total_adjusted_n_per_acre* grass_buffer_functional_acres * n_reduction_for_grass
    upland_grass_buffer_p_reduction = 2 * total_adjusted_p_per_acre * grass_buffer_functional_acres * p_reduction_for_grass
    upland_grass_buffer_sediment_reduction = 2 * total_adjusted_sediment_per_acre * grass_buffer_functional_acres * sediment_reduction_for_grass

    # forest buffer
    upland_forest_buffer_n_reduction = 4 * total_adjusted_n_per_acre * forest_buffer_functional_acres * n_reduction_for_forest
    upland_forest_buffer_p_reduction = 2 * total_adjusted_p_per_acre * forest_buffer_functional_acres * p_reduction_for_forest
    upland_forest_buffer_sediment_reduction = 2 * total_adjusted_sediment_per_acre * forest_buffer_functional_acres * sediment_reduction_for_forest

    # wetland lookup
    wetland_ratio = field.wetland_area.to_f / (field.wetland_area.to_f + field.wetland_treated_area.to_f)

    # 12 = wetland
    bmp_efficiency_for_wetland = BmpEfficiencyLookup.where(:bmp_type_id => 12, :hgmr_code => field.watershed_segment.hgmr_code).first

    n_reduction_for_wetland = bmp_efficiency_for_wetland[:n_reduction].to_f
    p_reduction_for_wetland = bmp_efficiency_for_wetland[:p_reduction].to_f
    sediment_reduction_for_wetland = bmp_efficiency_for_wetland[:sediment_reduction].to_f

    upland_wetland_n_reduction = field.is_wetland ? 0 : field.wetland_treated_area.to_f * n_reduction_for_wetland * total_adjusted_n_per_acre
    upland_wetland_p_reduction = field.is_wetland ? 0 : field.wetland_treated_area.to_f * p_reduction_for_wetland * total_adjusted_p_per_acre
    upland_wetland_sediment_reduction = field.is_wetland ? 0 : field.wetland_treated_area.to_f * sediment_reduction_for_wetland * total_adjusted_sediment_per_acre

    new_total_n_per_acre = total_unconverted_acres==0 ? 0 : ((total_unconverted_acres * total_adjusted_n_per_acre) - upland_streambank_grass_n_reduction - upland_streambank_forest_n_reduction - upland_grass_buffer_n_reduction - upland_forest_buffer_n_reduction - upland_wetland_n_reduction) / (total_unconverted_acres)
    new_total_p_per_acre = total_unconverted_acres==0 ? 0 : ((total_unconverted_acres * total_adjusted_p_per_acre) - upland_streambank_grass_p_reduction - upland_streambank_forest_p_reduction - upland_grass_buffer_p_reduction - upland_forest_buffer_p_reduction - upland_wetland_p_reduction) / (total_unconverted_acres)
    new_total_sediment_per_acre = total_unconverted_acres==0 ? 0 : ((total_unconverted_acres * total_adjusted_sediment_per_acre) - upland_streambank_grass_sediment_reduction - upland_streambank_forest_sediment_reduction - upland_grass_buffer_sediment_reduction - upland_forest_buffer_sediment_reduction - upland_wetland_sediment_reduction) / (total_unconverted_acres)

    # TODO: data check

    # for each BMP
    if (!field.bmps.empty?)
      field.bmps.each do |bmp|
        bmp_type_id = bmp.bmp_type_id

        bmp_efficiency = BmpEfficiencyLookup.where(:bmp_type_id => bmp_type_id, :field_type_id => field_type_id, :hgmr_code => hgmr_code).first

        n_reduction = bmp_efficiency[:n_reduction].to_f
        p_reduction = bmp_efficiency[:p_reduction].to_f
        sediment_reduction = bmp_efficiency[:sediment_reduction].to_f

        new_total_n_per_acre = ((new_total_n_per_acre * total_unconverted_acres) - (bmp.acres * new_total_n_per_acre * n_reduction)) / total_unconverted_acres
        new_total_p_per_acre = ((new_total_p_per_acre * total_unconverted_acres) - (bmp.acres * new_total_p_per_acre * p_reduction)) / total_unconverted_acres
        new_total_sediment_per_acre = ((new_total_sediment_per_acre * total_unconverted_acres) - (bmp.acres * new_total_sediment_per_acre * sediment_reduction)) / total_unconverted_acres

      end
    end

    total_n_for_unconverted_acre = new_total_n_per_acre * total_unconverted_acres
    total_p_for_unconverted_acre = new_total_p_per_acre * total_unconverted_acres
    total_sediment_for_unconverted_acre = new_total_sediment_per_acre * total_unconverted_acres

    # if streambank restoration in place
    if (field.is_streambank_restoration)
      total_n_for_unconverted_acre = total_n_for_unconverted_acre - (field.streambank_restoration_length * 0.2)
      total_p_for_unconverted_acre = total_p_for_unconverted_acre - (field.streambank_restoration_length * 0.068)
      total_sediment_for_unconverted_acre = total_sediment_for_unconverted_acre - (field.streambank_restoration_length * 0.027125)
    end


    new_total_n = total_n_for_converted_acre + total_n_for_unconverted_acre
    new_total_p = total_p_for_converted_acre + total_p_for_unconverted_acre
    new_total_sediment = total_sediment_for_converted_acre + total_sediment_for_unconverted_acre

    {:ntt_results => @ntt_results, :new_total_n => new_total_n, :new_total_p => new_total_p, :new_total_sediment => new_total_sediment, :error_message => 'No error'}


    # raise 'Oh no! An error......'

  end


  def computeLivestockBmpCalculations(field)

    ####################
    # Animal
    ####################

    total_n_livestock = 0
    total_nh3_livestock = 0
    total_org_n_livestock = 0
    total_p_livestock = 0
    total_org_p_livestock = 0
    total_po4p_livestock = 0

    animal_v_ammonia = 0
    animal_eof_confined_nh3 = 0
    animal_eof_confined_org_n = 0
    animal_eof_confined_org_p = 0
    animal_eof_confined_po4p = 0


    field.field_livestocks.each do |animal|

      animal_lookup = Animal.where(:id => animal.animal_id).first

      animal_manure = (field.livestock_input_method_id == 1) ? animal.total_manure : animal.quantity * animal.average_weight / 1000.0 * animal_lookup[:daily_manure_production_lbs_per_au] * (animal.days_per_year_confined * animal.hours_per_day_confined) / 24.0 / 2000.0

      total_n_livestock = total_n_livestock + (animal_manure * animal.n_excreted)


      total_org_n_livestock = total_org_n_livestock + (animal_manure * animal.n_excreted) * animal_lookup[:fraction_org_n]
      tmp_nh3_livestock = animal.n_excreted * animal_lookup[:fraction_nh3] * animal_manure
      total_nh3_livestock = total_nh3_livestock + tmp_nh3_livestock

      total_p_livestock = total_p_livestock + (animal_manure * animal.p205_excreted / animal_lookup[:fraction_p2o5])
      total_org_p_livestock = total_org_p_livestock + (animal.p205_excreted / animal_lookup[:fraction_p2o5]) * animal_lookup[:fraction_org_p] * animal_manure

      total_po4p_livestock = total_po4p_livestock + (animal.p205_excreted / animal_lookup[:fraction_p2o5]) * animal_lookup[:fraction_po4p] * animal_manure

      tmp_confined_ammonia = field.is_livestock_plastic_permeable_lagoon_cover ? (tmp_nh3_livestock * (1 - animal_lookup[:fraction_nh3] * 0.85)) : tmp_nh3_livestock * (1 - animal_lookup[:volatilization_fraction])
      animal_v_ammonia = animal_v_ammonia + tmp_nh3_livestock - tmp_confined_ammonia

      tmp_eof_confined_nh3 = tmp_confined_ammonia * animal_lookup[:storage_loss_fraction]
      tmp_eof_confined_nh3 = tmp_eof_confined_nh3 * 0.25 if field.is_livestock_animal_waste_management_system
      tmp_eof_confined_nh3 = tmp_eof_confined_nh3 * (1 - animal_lookup[:mortality_rate]) if field.is_livestock_mortality_composting
      animal_eof_confined_nh3 = animal_eof_confined_nh3 + tmp_eof_confined_nh3

      tmp_eof_confined_org_n = (animal_manure * animal.n_excreted) * animal_lookup[:fraction_org_n] * animal_lookup[:storage_loss_fraction]
      tmp_eof_confined_org_n = tmp_eof_confined_org_n * 0.25 if field.is_livestock_animal_waste_management_system
      tmp_eof_confined_org_n = tmp_eof_confined_org_n * (1 - animal_lookup[:mortality_rate]) if field.is_livestock_mortality_composting
      animal_eof_confined_org_n = animal_eof_confined_org_n + tmp_eof_confined_org_n

      tmp_eof_confined_org_p = animal_manure * animal.p205_excreted / animal_lookup[:fraction_p2o5] * animal_lookup[:fraction_org_p] * animal_lookup[:storage_loss_fraction]
      tmp_eof_confined_org_p = tmp_eof_confined_org_p * 0.25 if field.is_livestock_animal_waste_management_system
      tmp_eof_confined_org_p = tmp_eof_confined_org_p * (1 - animal_lookup[:mortality_rate]) if field.is_livestock_mortality_composting
      animal_eof_confined_org_p = animal_eof_confined_org_p + tmp_eof_confined_org_p

      tmp_eof_confined_po4p = animal_manure * animal.p205_excreted / animal_lookup[:fraction_p2o5] * animal_lookup[:fraction_po4p] * animal_lookup[:storage_loss_fraction]
      tmp_eof_confined_po4p = tmp_eof_confined_po4p * 0.25 if field.is_livestock_animal_waste_management_system
      tmp_eof_confined_po4p = tmp_eof_confined_po4p * (1 - animal_lookup[:mortality_rate]) if field.is_livestock_mortality_composting
      animal_eof_confined_po4p = animal_eof_confined_po4p + tmp_eof_confined_po4p
    end

    animal_eos_nh3 = (animal_eof_confined_org_n < (animal_eof_confined_org_p / 0.01384)) ? animal_eof_confined_nh3 : (animal_eof_confined_nh3 + animal_eof_confined_org_n - animal_eof_confined_org_p / 0.01384)
    animal_eos_nh3 = animal_eos_nh3 * field.watershed_segment.cafo_n_rf

    animal_eos_po4p = 0
    if (animal_eof_confined_org_n < (animal_eof_confined_org_p / 0.01384))
      if (animal_eof_confined_po4p + animal_eof_confined_org_p - animal_eof_confined_org_n * 0.01384 > 0)
        animal_eos_po4p = animal_eof_confined_po4p + animal_eof_confined_org_p - animal_eof_confined_org_n * 0.01384
      else
        animal_eos_po4p = 0
      end
    else
      animal_eos_po4p = animal_eof_confined_po4p
    end
    animal_eos_po4p = animal_eos_po4p * field.watershed_segment.cafo_p_rf

    animal_eos_org_n = (animal_eof_confined_org_n < animal_eof_confined_po4p / 0.01384) ? animal_eof_confined_org_n * 22.95 * 0.0436 : animal_eof_confined_org_p / 0.01384 * 22.95 * 0.0436
    animal_eos_org_n = animal_eos_org_n * (field.watershed_segment.cafo_n_rf + field.watershed_segment.cafo_p_rf) / 2

    animal_eos_org_p = (animal_eof_confined_org_n < animal_eof_confined_po4p / 0.01384) ? animal_eof_confined_org_n * 22.95 * 0.00603 : animal_eof_confined_org_p / 0.01384 * 22.95 * 0.00603
    animal_eos_org_p = animal_eos_org_p * (field.watershed_segment.cafo_n_rf + field.watershed_segment.cafo_p_rf) / 2

    animal_eos_dry_ammonia = (animal_v_ammonia * 0.4) * field.watershed_segment.cafo_n_rf

    animal_eos_nitrogen = animal_eos_org_n + animal_eos_nh3 + animal_eos_dry_ammonia
    animal_eos_nitrogen = animal_eos_nitrogen * 0.8 if field.is_livestock_barnyard_runoff_controls
    animal_eos_nitrogen = animal_eos_nitrogen * 0.67 if field.is_livestock_water_control_structure
    animal_eos_nitrogen = animal_eos_nitrogen * 0.8 if field.is_livestock_treatment_wetland

    animal_eos_phosphorus = (animal_eos_org_p + animal_eos_po4p)
    animal_eos_phosphorus = animal_eos_phosphorus * 0.8 if field.is_livestock_barnyard_runoff_controls
    animal_eos_phosphorus = animal_eos_phosphorus * 0.55 if field.is_livestock_treatment_wetland

    eos_sediment = field.acres * field.watershed_segment.cafo_eos_sediment
    eos_sediment = eos_sediment * 0.6 if !field.field_livestocks.empty? && field.is_livestock_barnyard_runoff_controls
    eos_sediment = eos_sediment * 0.4 if !field.field_livestocks.empty? && field.is_livestock_treatment_wetland

    ####################
    # Poultry
    ####################

    total_n_poultry = 0
    total_nh3_poultry = 0
    total_org_n_poultry = 0
    total_p_poultry = 0
    total_org_p_poultry = 0
    total_po4p_poultry = 0

    poultry_v_ammonia = 0
    poultry_eof_confined_nh3 = 0
    poultry_eof_confined_org_n = 0
    poultry_eof_confined_org_p = 0
    poultry_eof_confined_po4p = 0

    field.field_poultry.each do |poultry|

      poultry_lookup = Animal.where(:id => poultry.animal_id).first

      poultry_manure = poultry.quantity / poultry_lookup[:animals_per_au] * poultry.days_in_growing_cycle * poultry.flocks_per_year * (poultry_lookup[:daily_manure_production_lbs_per_au] / 2000.0)

      total_n_poultry = total_n_poultry + (poultry_manure * poultry.n_excreted)


      total_org_n_poultry = total_org_n_poultry + (poultry_manure * poultry.n_excreted) * poultry_lookup[:fraction_org_n]
      total_nh3_poultry = total_nh3_poultry + (poultry.n_excreted * poultry_lookup[:fraction_nh3])

      total_p_poultry = total_p_poultry + (poultry_manure * poultry.p205_excreted / poultry_lookup[:fraction_p2o5])
      total_org_p_poultry = total_org_p_poultry + (poultry.p205_excreted / poultry_lookup[:fraction_p2o5]) * poultry_lookup[:fraction_org_p]

      total_po4p_poultry = total_po4p_poultry + (poultry.p205_excreted / poultry_lookup[:fraction_p2o5]) / poultry_lookup[:fraction_po4p]


      tmp_confined_ammonia = field.is_poultry_litter_treatment ? (poultry.n_excreted * poultry_lookup[:fraction_nh3]) * (1 - (poultry_lookup[:volatilization_fraction] * (1 - 0.6))) : (poultry.n_excreted * poultry_lookup[:fraction_nh3]) * (1 - poultry_lookup[:volatilization_fraction])
      tmp_v_ammonia = (poultry.n_excreted * poultry_lookup[:fraction_nh3]) - tmp_confined_ammonia
      tmp_v_ammonia = tmp_v_ammonia * 0.5 if (field.is_poultry_biofilters)
      tmp_v_ammonia = tmp_v_ammonia * 0.5 if (field.is_poultry_vegetated_environmental_buffer)
      poultry_v_ammonia = poultry_v_ammonia + tmp_v_ammonia

      tmp_eof_confined_nh3 = tmp_confined_ammonia * poultry_lookup[:storage_loss_fraction]
      tmp_eof_confined_nh3 = tmp_eof_confined_nh3 * 0.25 if field.is_poultry_animal_waste_management_system
      tmp_eof_confined_nh3 = tmp_eof_confined_nh3 * (1 - poultry_lookup[:mortality_rate]) if field.is_poultry_mortality_composting
      poultry_eof_confined_nh3 = poultry_eof_confined_nh3 + tmp_eof_confined_nh3

      tmp_eof_confined_org_n = (poultry_manure * poultry.n_excreted) * poultry_lookup[:fraction_org_n] * poultry_lookup[:storage_loss_fraction]
      tmp_eof_confined_org_n = tmp_eof_confined_org_n * 0.25 if field.is_poultry_animal_waste_management_system
      tmp_eof_confined_org_n = tmp_eof_confined_org_n * (1 - poultry_lookup[:mortality_rate]) if field.is_poultry_mortality_composting
      poultry_eof_confined_org_n = poultry_eof_confined_org_n + tmp_eof_confined_org_n

      tmp_eof_confined_org_p = (poultry.p205_excreted / poultry_lookup[:fraction_p2o5]) * poultry_lookup[:fraction_org_p] * poultry_lookup[:storage_loss_fraction]
      tmp_eof_confined_org_p = tmp_eof_confined_org_p * 0.25 if field.is_poultry_animal_waste_management_system
      tmp_eof_confined_org_p = tmp_eof_confined_org_p * (1 - poultry_lookup[:mortality_rate]) if field.is_poultry_mortality_composting
      poultry_eof_confined_org_p = poultry_eof_confined_org_p + tmp_eof_confined_org_p

      tmp_eof_confined_po4p = (poultry.p205_excreted / poultry_lookup[:fraction_p2o5]) / poultry_lookup[:fraction_po4p] * poultry_lookup[:fraction_org_p] * poultry_lookup[:storage_loss_fraction]
      tmp_eof_confined_po4p = tmp_eof_confined_po4p * 0.25 if field.is_poultry_animal_waste_management_system
      tmp_eof_confined_po4p = tmp_eof_confined_po4p * (1 - poultry_lookup[:mortality_rate]) if field.is_poultry_mortality_composting
      poultry_eof_confined_po4p = poultry_eof_confined_po4p + tmp_eof_confined_po4p


    end


    poultry_eos_nh3 = (poultry_eof_confined_org_n < (poultry_eof_confined_org_p / 0.01384)) ? poultry_eof_confined_nh3 : (poultry_eof_confined_nh3 + poultry_eof_confined_org_n - poultry_eof_confined_org_p / 0.01384)
    poultry_eos_nh3 =poultry_eos_nh3 * field.watershed_segment.cafo_n_rf

    poultry_eos_po4p = 0
    if (poultry_eof_confined_org_n < (poultry_eof_confined_org_p / 0.01384))
      if (poultry_eof_confined_po4p + poultry_eof_confined_org_p - poultry_eof_confined_org_n * 0.01384 > 0)
        poultry_eos_po4p = poultry_eof_confined_po4p + poultry_eof_confined_po4p - poultry_eof_confined_org_n * 0.01384
      else
        poultry_eos_po4p = 0
      end
    else
      poultry_eos_po4p = poultry_eof_confined_po4p
    end

    poultry_eos_po4p = poultry_eos_po4p * field.watershed_segment.cafo_p_rf

    poultry_eos_org_n = (poultry_eof_confined_org_n < poultry_eof_confined_po4p / 0.01384) ? poultry_eof_confined_org_n * 22.95 * 0.0436 : poultry_eof_confined_org_p / 0.01384 * 22.95 * 0.0436
    poultry_eos_org_n = poultry_eos_org_n * (field.watershed_segment.cafo_n_rf + field.watershed_segment.cafo_p_rf) / 2

    poultry_eos_org_p = (poultry_eof_confined_org_n < poultry_eof_confined_po4p / 0.01384) ? poultry_eof_confined_org_n * 22.95 * 0.00603 : poultry_eof_confined_org_p / 0.01384 * 22.95 * 0.00603
    poultry_eos_org_p = poultry_eos_org_p * (field.watershed_segment.cafo_n_rf + field.watershed_segment.cafo_p_rf) / 2

    poultry_eos_dry_ammonia = (poultry_v_ammonia * 0.4) * field.watershed_segment.cafo_n_rf

    poultry_eos_nitrogen = poultry_eos_org_n + poultry_eos_nh3 + poultry_eos_dry_ammonia
    poultry_eos_nitrogen = poultry_eos_nitrogen * 0.8 if field.is_poultry_barnyard_runoff_controls
    poultry_eos_nitrogen = poultry_eos_nitrogen * 0.67 if field.is_poultry_water_control_structure
    poultry_eos_nitrogen = poultry_eos_nitrogen * 0.8 if field.is_poultry_treatment_wetland
    poultry_eos_nitrogen = poultry_eos_nitrogen * 0.9 if field.is_poultry_heavy_use_pads

    poultry_eos_phosphorus = (poultry_eos_org_p + poultry_eos_po4p)
    poultry_eos_phosphorus = poultry_eos_phosphorus * 0.8 if field.is_poultry_barnyard_runoff_controls
    poultry_eos_phosphorus = poultry_eos_phosphorus * 0.55 if field.is_poultry_treatment_wetland
    poultry_eos_phosphorus = poultry_eos_phosphorus * 0.9 if field.is_poultry_heavy_use_pads

    eos_sediment = eos_sediment * 0.6 if !field.field_poultry.empty? && field.is_poultry_barnyard_runoff_controls
    eos_sediment = eos_sediment * 0.4 if !field.field_poultry.empty? && field.is_poultry_treatment_wetland
    eos_sediment = eos_sediment * 0.9 if !field.field_poultry.empty? && field.is_poultry_heavy_use_pads


    current_load_nitrogen = animal_eos_nitrogen + poultry_eos_nitrogen
    current_load_phosphorus = animal_eos_phosphorus + poultry_eos_phosphorus
    current_load_sediment = eos_sediment / 2000.0

    {
        :current_load_nitrogen => current_load_nitrogen,
        :current_load_phosphorus => current_load_phosphorus,
        :current_load_sediment => current_load_sediment,


        :total_n_livestock => total_n_livestock,
        :total_nh3_livestock => total_nh3_livestock,
        :total_org_n_livestock => total_org_n_livestock,
        :total_p_livestock => total_p_livestock,
        :total_org_p_livestock => total_org_p_livestock,
        :total_po4p_livestock => total_po4p_livestock,

        :animal_v_ammonia => animal_v_ammonia,
        :animal_eof_confined_nh3 => animal_eof_confined_nh3,
        :animal_eof_confined_org_n => animal_eof_confined_org_n,
        :animal_eof_confined_org_p => animal_eof_confined_org_p,
        :animal_eof_confined_po4p => animal_eof_confined_po4p,

        :total_n_poultry => total_n_poultry,
        :total_nh3_poultry => total_nh3_poultry,
        :total_org_n_poultry => total_org_n_poultry,
        :total_p_poultry => total_p_poultry,
        :total_org_p_poultry => total_org_p_poultry,
        :total_po4p_poultry => total_po4p_poultry,

        :poultry_v_ammonia => poultry_v_ammonia,
        :poultry_eof_confined_nh3 => poultry_eof_confined_nh3,
        :poultry_eof_confined_org_n => poultry_eof_confined_org_n,
        :poultry_eof_confined_org_p => poultry_eof_confined_org_p,
        :poultry_eof_confined_po4p => poultry_eof_confined_po4p,

        :error_message => 'No error'}


  end

end

