module SetupBmpCalculations


  def field_adjustment_factor(field, pollutant)

    @total_n_per_acre = 12.3
    @total_p_per_acre = 4.5
    @total_s_per_acre = 1.2

    @n_pollutants = { :total_per_acre => @total_n_per_acre, :crop_adjust => field.watershed_segment.n_crop_adjust, :pasture_adjust => field.watershed_segment.n_pasture_adjust, :hay_adjust => field.watershed_segment.n_hay_adjust }
    @p_pollutants = { :total_per_acre => @total_p_per_acre, :crop_adjust => field.watershed_segment.p_crop_adjust, :pasture_adjust => field.watershed_segment.p_pasture_adjust, :hay_adjust => field.watershed_segment.p_hay_adjust }
    @s_pollutants = { :total_per_acre => @total_s_per_acre, :crop_adjust => field.watershed_segment.sediment_crop_adjust, :pasture_adjust => field.watershed_segment.sediment_pasture_adjust, :hay_adjust => field.watershed_segment.sediment_hay_adjust }
    @pollutant_type = { "N" => @n_pollutants, "P" => @p_pollutants, "S" => @s_pollutants }

    def factor_for_field_type(field, pollutant)
      pollutants = @pollutant_type[pollutant]
      field_type_id = field.field_type_id
      factor = { 1 => pollutants[:crop_adjust], 2 => pollutants[:pasture_adjust], 3 => pollutants[:hay_adjust] }
      return factor[field_type_id]
    end

    def total_for_pollutant(field, pollutant)
      return @pollutant_type[pollutant][:total_per_acre]
    end

    def calculate_field_adjustment(field, pollutant)
      factor_for_field_type(field, pollutant) * total_for_pollutant(field, pollutant)
    end

    return calculate_field_adjustment(field, pollutant)

  end


end


 