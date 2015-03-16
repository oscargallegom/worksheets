require 'debugger'
include BmpCalculations
include ModelRun

module CalculateLoads

	def get_current_totals(farm)
		totals = Hash.new

		@arrWatersheds = Array.new
	    @arrMajorBasins = Array.new
	    @arrTMDLs = Array.new

	    # sort fields 'naturally'
	    @fields = Naturalsorter::Sorter.sort_by_method(farm.fields, :name, true)

	    @watersheds = (@fields.collect {|x| x.watershed_segment}).uniq
	    @p_factors = ((@watersheds.collect {|z| z.p_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
	    @n_factors = ((@watersheds.collect {|z| z.n_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
	    @s_factors = ((@watersheds.collect {|z| z.sediment_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")

	    @cb_segment = ((@watersheds.collect {|z| z.key}).uniq).map {|i| i.to_s }.join(", ")

		@baseline_n_load_fields = 0
	    @current_n_load_fields = 0
	    @future_n_load_fields = 0

	    @baseline_p_load_fields = 0
	    @current_p_load_fields = 0
	    @future_p_load_fields = 0

	    @baseline_sediment_load_fields = 0
	    @current_sediment_load_fields = 0
	    @future_sediment_load_fields = 0

	    @current_n_load_animals = 0
	    @current_p_load_animals = 0
	    @current_sediment_load_animals = 0

	    @future_n_load_animals = 0
	    @future_p_load_animals = 0
	    @future_sediment_load_animals = 0

	    @fields.each do |field|

	      @arrWatersheds << field.watershed_name unless @arrWatersheds.include?(field.watershed_name)
	      @arrMajorBasins << field.watershed_segment.major_basin unless field.watershed_segment.nil? || @arrMajorBasins.include?(field.watershed_segment.major_basin)
	      @arrTMDLs << field.tmdl.name if farm.site_state_id != 47 && !field.tmdl.nil? && !@arrTMDLs.include?(field.tmdl.name)
	      @arrTMDLs << field.tmdl_va if farm.site_state_id == 47 && !@arrTMDLs.include?(field.tmdl_va)

	      if (!field.field_type.nil?) && (field.field_type.id == 1 || field.field_type.id == 2 || field.field_type.id == 3)
	        #begin
	          if field.other_land_use_conversion_acres_future

	            @current_totals = computeBmpCalculations(field)
	            calculate_bmps_without_conversion(field)
	            calculate_bmps(field)
	            if @with_conversion[:sediment] > @without_conversion[:sediment]
	              @current_totals[:new_total_sediment_future] = @without_conversion[:sediment]
	            end
	            if @with_conversion[:nitrogen] > @without_conversion[:nitrogen]
	              @current_totals[:new_total_n_future] = @without_conversion[:nitrogen]
	            end
	            if @with_conversion[:phosphorus] > @without_conversion[:phosphorus]
	              @current_totals[:new_total_p_future] = @without_conversion[:phosphorus]
	            end
	          else
	            @current_totals = computeBmpCalculations(field)
	          end
	        #rescue Exception => e
	        #   flash.now[:error] = e.message
	        #   @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0}
	         #end

	        @current_n_load_fields += @current_totals[:new_total_n]
	        @current_p_load_fields += @current_totals[:new_total_p]
	        @current_sediment_load_fields += @current_totals[:new_total_sediment]

	        @future_n_load_fields += @current_totals[:new_total_n_future]


	        @future_p_load_fields += @current_totals[:new_total_p_future]

	        @future_sediment_load_fields += @current_totals[:new_total_sediment_future]

	        watershed_segment = WatershedSegment.where(:id => field.watershed_segment_id).first
	        if (!watershed_segment.nil?)
	          @baseline_sediment_load_fields += watershed_segment[:sediment_crop_baseline] * field.acres / 2000.0 if field.field_type_id == 1
	          @baseline_sediment_load_fields += watershed_segment[:sediment_pasture_baseline] * field.acres / 2000.0 if field.field_type_id == 2
	          @baseline_sediment_load_fields += watershed_segment[:sediment_hay_baseline] * field.acres / 2000.0 if field.field_type_id == 3

	          if field.tmdl.nil?
	            @baseline_n_load_fields += watershed_segment[:n_crop_baseline] * field.acres if field.field_type_id == 1
	            @baseline_n_load_fields += watershed_segment[:n_pasture_baseline] * field.acres if field.field_type_id == 2
	            @baseline_n_load_fields += watershed_segment[:n_hay_baseline] * field.acres if field.field_type_id == 3

	            @baseline_p_load_fields += watershed_segment[:p_crop_baseline] * field.acres if field.field_type_id == 1
	            @baseline_p_load_fields += watershed_segment[:p_pasture_baseline] * field.acres if field.field_type_id == 2
	            @baseline_p_load_fields += watershed_segment[:p_hay_baseline] * field.acres if field.field_type_id == 3

	          else # use Maryland TMDL
	            @baseline_n_load_fields += field.tmdl[:total_n] * field.acres
	            @baseline_p_load_fields += field.tmdl[:total_p] * field.acres
	          end
	        end
	      end

	      # animals
	      if (!field.field_type.nil?) && (field.field_type.id == 4)
	        @current_totals = computeLivestockBmpCalculations(field)
	        @current_n_load_animals += @current_totals[:current_load_nitrogen]
	        @current_p_load_animals += @current_totals[:current_load_phosphorus]
	        @current_sediment_load_animals += @current_totals[:current_load_sediment]
	        #future
	        @future_totals = computeLivestockBmpCalculationsFuture(field)
	        @future_n_load_animals += @future_totals[:current_load_nitrogen]
	        @future_p_load_animals += @future_totals[:current_load_phosphorus]
	        @future_sediment_load_animals += @future_totals[:current_load_sediment]
	      end

		end

		totals[:current_totals] = @current_totals
		totals[:current_n_load_fields] = @current_n_load_fields
		totals[:current_p_load_fields] = @current_p_load_fields
		totals[:current_sediment_load_fields] = @current_sediment_load_fields
		totals[:future_n_load_fields] = @future_n_load_fields
		totals[:future_p_load_fields] = @future_p_load_fields
		totals[:future_sediment_load_fields] = @future_sediment_load_fields
		totals[:baseline_n_load_fields] = @baseline_n_load_fields
		totals[:baseline_p_load_fields] = @baseline_p_load_fields
		totals[:baseline_sediment_load_fields] = @baseline_sediment_load_fields

		totals[:current_n_load_animals] = @current_n_load_animals
		totals[:current_p_load_animals] = @current_p_load_animals
		totals[:current_sediment_load_animals] = @current_sediment_load_animals
		totals[:future_n_load_animals] = @future_n_load_animals
		totals[:future_p_load_animals] = @future_p_load_animals
		totals[:future_sediment_load_animals] = @future_sediment_load_animals
		totals[:future_totals] = @future_totals

		return totals
	end



end