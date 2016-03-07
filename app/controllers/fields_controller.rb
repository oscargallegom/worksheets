class FieldsController < ApplicationController

  include BmpCalculations
  include Ntt
  #include Baseline
  include ModelRun

  load_and_authorize_resource :farm
  load_and_authorize_resource :field, :through => :farm
  layout 'farm', :only => [:index]

  add_breadcrumb 'Home', :farms_path
  add_breadcrumb 'Projects', :farms_path


  # GET /farms/1/fields
  # GET /farms/1/fields.json
  def index

    #@farm = Project.find(params[:farm_id])
    #@fields = @farm.fields
    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields'

    # natural sort fields
    @fields = Naturalsorter::Sorter.sort_by_method(@fields, :name, true)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /farms/1/fields/1
  # GET /farms/1/fields/1.json
  def show

    # there is no screen to show a field, just edit
    redirect_to :action => 'edit'

    # @farm = Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    #add_breadcrumb @farm.name, farm_path(@farm)
    #add_breadcrumb 'Fields', farm_fields_path(@farm)
    #add_breadcrumb @field.name

    #respond_to do |format|
    #  format.html # show.html.erb
    #end
  end

  # GET /farms/1/fields/new
  # GET /farms/1/fields/new.json
  def new
    # @farm = Project.find(params[:farm_id])
    # @field =@farm.fields.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /farms/1/fields/1/edit
  def edit
    @field = Field.find(params[:id])
    @current_strips = @field.strips.where(:is_future => false)
    @future_strips = @field.strips.where(:is_future => true)

    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name
    # @farm= Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    @step = params[:step] || '1'

    @soil_test_laboratories = SoilTestLaboratory.where(:state_id => @farm.site_state_id) if @step == '2'

    if ((@step =='5' || @step == '8') && (@field.field_type_id == 1 || @field.field_type_id == 2 || @field.field_type_id == 3)) # perform calculations
      if @step == '5'
        model_run(@field)
        calculate_bmps(@field)
      end
      if @step == '8'
        model_run_future(@field)
        model_run(@field)
        calculate_bmps(@field)
      end
      #begin
### this is a hack to check whether land use conversion results in increased sediment than otherwise, and if so, disregard the land use conversion.
      if @field.other_land_use_conversion_acres_future
        @current_totals = computeBmpCalculations(@field)
        @ntt_results = @current_totals[:ntt_results]
        @ntt_results_future = @current_totals[:ntt_results_future]
        calculate_bmps_without_conversion(@field)
        calculate_bmps(@field)
        if @with_conversion_current[:sediment] > @without_conversion_current[:sediment]
          @current_totals[:new_total_sediment] = @without_conversion_current[:sediment]
          @field.totals[:new_total_sediment] = @without_conversion_current[:sediment]
          @field.save!
        end
        if @with_conversion_current[:nitrogen] > @without_conversion_current[:nitrogen]
              @current_totals[:new_total_n] = @without_conversion_current[:nitrogen]
              @field.totals[:new_total_n] = @without_conversion_current[:nitrogen]
              @field.save!
        end
        if @with_conversion_current[:phosphorus] > @without_conversion_current[:phosphorus]
              @current_totals[:new_total_p] = @without_conversion_current[:phosphorus]
              @field.totals[:new_total_p] = @without_conversion_current[:phosphorus]
              @field.save!
        end
        if @with_conversion[:sediment] > @without_conversion[:sediment]
          @current_totals[:new_total_sediment_future] = @without_conversion[:sediment]
          @field.totals[:new_total_sediment_future] = @without_conversion[:sediment]
          @field.save!
        end
        if @with_conversion[:nitrogen] > @without_conversion[:nitrogen]
              @current_totals[:new_total_n_future] = @without_conversion[:nitrogen]
              @field.totals[:new_total_n_future] = @without_conversion[:nitrogen]
              @field.save!
        end
        if @with_conversion[:phosphorus] > @without_conversion[:phosphorus]
              @current_totals[:new_total_p_future] = @without_conversion[:phosphorus]
              @field.totals[:new_total_p_future] = @without_conversion[:phosphorus]
              @field.save!
        end
      else
        @current_totals = computeBmpCalculations(@field)
        @ntt_results = @current_totals[:ntt_results]
      end

      @watershed_segment = WatershedSegment.where(:id => @field.watershed_segment_id).first
      if (@watershed_segment.nil?)
        flash.now[:error] = "Could not retrieve baseline data." if @watershed_segment.nil?
      end

      flash.now[:meet_baseline] = @field.does_field_meet_baseline[:errors]

    end


    if ((@step =='5' || @step == '7') && (@field.field_type_id == 4)) # perform calculations for animal confinement
      computeLivestockBmpCalculations(@field)
      computeLivestockBmpCalculationsFuture(@field)
      # begin
      #   @current_totals = computeLivestockBmpCalculations(@field)
      # rescue Exception => e
      #   flash.now[:error] = e.message
      #   @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0}
      # end
      # begin
      #   @future_totals = computeLivestockBmpCalculationsFuture(@field)
      # rescue Exception => e
      #   flash.now[:error] = e.message
      #   @future_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0}
      # end

      flash.now[:meet_baseline] = @field.does_field_meet_baseline[:errors]

    end

    @other_fields = []
    @farm.fields.each do |field|
      @other_fields.push(field) if field.id != @field.id
    end

    if session[:debug]
      # success, content = buildXml(@field, true) # TODO: remove/change
      # @input_xml = content # TODO: remove/change
      # success, content = callNtt(@field, (@step=='6' || @step=='7')) # TODO: remove/change
      # if (success)
      #   @results = Hash.from_xml((content.xpath('//Results')).to_s)['Results']
      #   @output_xml = content
      #   if (@results['ErrorCode'] != '0')
      #     flash[:notice] = 'Could not retrieve NTT info: ' << @results['ErrorDes'] # TODO: check for error!
      #   end
      # else
      #   flash[:notice] = 'Could not contact NTT: ' << content.to_s
      # end
    end








    # if @field.strips > 1
    #   logger.debug "Testing fields controller. Number of strips: #{@field.strips.count}"
    # end
    def is_strips_greater_than_one(field)
      number_of_strips = @field.strips.count
      if number_of_strips > 1
        return true
      else
        false
      end
    end
    logger.debug "Is strips greater than one: #{is_strips_greater_than_one(@field)}"
    if is_strips_greater_than_one(@field)
      @field.strips.each do |strip|
        if strip.length == nil
          strip.length = 1
          strip.save!
        end
      end
    end

  end

  # POST /farms/1/fields
  # POST /farms/1/fields.json
  def create
    #  @farm = Project.find(params[:farm_id])
    # @field =@farm.fields.build(params[:field])

    respond_to do |format|
      if @field.save
        format.html { redirect_to farm_field_url(@farm, @field), notice: 'Field was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /farms/1/fields/1
  # PUT /farms/1/fields/1.json
  def update

    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name

    # @farm =Project.find(params[:farm_id])
    # field = @farm.fields.find(params[:id])
    @step = params[:field][:step] || '1'


    respond_to do |format|

      if @field.update_attributes(params[:field])

        # if Baseline BMPs, validate converted acres
        if (@step=='4' && (@field.field_type_id == 1 || @field.field_type_id == 2 || @field.field_type_id == 3) && !is_converted_acres_valid(@field))
          format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 4),  notice: 'Total converted acre is greater than the field area. Please edit the buffer area.' }
        end

        # if step 2 and the user click 'add a crop to rotation'
        if !params[:addCropForStrip].blank?
          strip_index = params[:addCropForStrip].to_i
          format.html { redirect_to new_farm_field_strip_crop_rotation_url(@farm, @field, strip_index, :step => @step), notice: 'Field was successfully updated.' }
        elsif (@step=='2' && @field.field_type_id == 5) # non-managed land and step 2: got back to farm summary
          format.html { redirect_to farm_url(@farm), notice: 'Field was successfully updated.' }
        else
          #format.html #{ redirect_to edit_farm_field_url(@farm, @field, :step => @step.to_i+1), notice: 'Field was successfully updated.' }
          @step = (@step.to_i+1).to_s

          format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Field was successfully updated. ' +  @field.ntt_call_status.to_s}
        end

      else # error
        @soil_test_laboratories = SoilTestLaboratory.where(:state_id => @farm.site_state_id) if @step == '2'
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /farms/1/fields/1
  # DELETE /farms/1/fields/1.json
  def destroy
    @farm= Farm.find(params[:farm_id])
    @field = @farm.fields.find(params[:id])
    @field.destroy

    respond_to do |format|
      format.html { redirect_to farm_path(@farm) }
    end
  end

  # POST /farms/1/fields/1/export
  def export

    @step =params[:step]

    @to_field = nil
    @from_field= nil

    # copy all the strips from field A to field B
    if (params[:isExport] == 'true')

      @from_field = @field

      @to_field_id = params[:target_field_id].to_i
      @to_field = @farm.fields.find { |f| f["id"] == @to_field_id }

    else # import
      @from_field_id = params[:target_field_id].to_i
      @from_field = @farm.fields.find { |f| f["id"] == @from_field_id }

      @to_field = @field

    end

    # delete all the existing strips for field B
    @to_field.strips.each do |strip|
      if ((@step == '6' && strip.is_future?) || (@step == '3' && !strip.is_future?))
        @to_field.strips.delete(strip)
      end
    end

    # copy strips from A to B
    is_success = true
    @from_field.strips.each do |strip|
      if ((@step == '6' && strip.is_future?) || (@step == '3' && !strip.is_future?))
        @from_strip_dup = strip.amoeba_dup
        @from_strip_dup.field_id = @to_field.id
        if !@from_strip_dup.save!(:validate => false)
          is_success = false
        end
      end
    end

    respond_to do |format|
      if is_success
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Copy successful.' }
      else
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Error: could not export.' }
      end
    end
  end

  # POST /farms/1/fields/1/populateFutureCropManagement
  def populateFutureCropManagement
    # TODO: save delete fields first
    @step =params[:step]

    is_success = true
    @field.strips.each do |strip|
      if (!strip.is_future?)
        @future_strip_dup = strip.amoeba_dup
        @future_strip_dup.is_future = true
        if !@future_strip_dup.save!(:validate => false)
          is_success = false
        end
      else
        strip.destroy
      end
    end

    # reset NTT field
    # @field.reload
    # @field.ntt_xml_future = nil

    respond_to do |format|
      if is_success && @field.save
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Copy successful.' }
      else
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Error: could not import data.' }
      end
    end
  end

  # POST /farms/1/fields/1/populateFutureBMP
  def populateFutureBMPs
    @field.is_forest_buffer_future = @field.is_forest_buffer
    @field.forest_buffer_average_width_future = @field.forest_buffer_average_width
    @field.forest_buffer_length_future = @field.forest_buffer_length
    @field.is_forest_buffer_planned_future = @field.is_forest_buffer_planned
    @field.is_grass_buffer_future = @field.is_grass_buffer
    @field.grass_buffer_average_width_future = @field.grass_buffer_average_width
    @field.grass_buffer_length_future = @field.grass_buffer_length
    @field.is_grass_buffer_planned = @field.is_grass_buffer_planned
    @field.is_wetland_future = @field.is_wetland
    @field.wetland_area_future = @field.wetland_area
    @field.wetland_treated_area_future =@field.wetland_treated_area
    @field.is_wetland_planned_future = @field.is_wetland_planned
    @field.is_streambank_restoration_future = @field.is_streambank_restoration
    @field.streambank_restoration_length_future = @field.streambank_restoration_length
    @field.is_streambank_restoration_planned_future = @field.is_streambank_restoration_planned
    @field.is_streambank_fencing_in_place_future= @field.is_streambank_fencing_in_place
    @field.fence_length_future = @field.fence_length
    @field.distance_fence_stream_future=@field.distance_fence_stream
    @field.vegetation_type_fence_stream_id_future= @field.vegetation_type_fence_stream_id
    @field.planned_management_details_future=@field.planned_management_details
    @field.is_fertilizer_application_setback_future=@field.is_fertilizer_application_setback
    @field.fertilizer_application_setback_average_width_future=@field.fertilizer_application_setback_average_width
    @field.fertilizer_application_setback_length_future=@field.fertilizer_application_setback_length
    if @field.is_fertilizer_application_setback_planned == true
    @field.is_fertilizer_application_setback_planned_future =1
    end
    @field.exclusion_description_future=@field.exclusion_description
    @field.other_land_use_conversion_acres_future=@field.other_land_use_conversion_acres
    @field.other_land_use_conversion_vegetation_type_id_future= @field.other_land_use_conversion_vegetation_type_id
    @field.is_other_land_use_conversion_planned_future=@field.is_other_land_use_conversion_planned

    # future for animals
    @field.is_livestock_animal_waste_management_system_future = @field.is_livestock_animal_waste_management_system
    @field.is_livestock_mortality_composting_future =@field.is_livestock_mortality_composting
    @field.is_livestock_plastic_permeable_lagoon_cover_future = @field.is_livestock_plastic_permeable_lagoon_cover
    @field.is_livestock_phytase_future = @field.is_livestock_phytase
    @field.is_livestock_dairy_precision_feeding_future = @field.is_livestock_dairy_precision_feeding
    @field.is_livestock_barnyard_runoff_controls_future = @field.is_livestock_barnyard_runoff_controls
    @field.is_livestock_water_control_structure_future = @field.is_livestock_water_control_structure
    @field.is_livestock_treatment_wetland_future = @field.is_livestock_treatment_wetland
    @field.is_poultry_animal_waste_management_system_future = @field.is_poultry_animal_waste_management_system
    @field.is_poultry_mortality_composting_future = @field.is_poultry_mortality_composting
    @field.is_poultry_biofilters_future = @field.is_poultry_biofilters
    @field.is_poultry_vegetated_environmental_buffer_future = @field.is_poultry_vegetated_environmental_buffer
    @field.is_poultry_phytase_future = @field.is_poultry_phytase
    @field.is_poultry_heavy_use_pads_future = @field.is_poultry_heavy_use_pads
    @field.is_poultry_barnyard_runoff_controls_future = @field.is_poultry_barnyard_runoff_controls
    @field.is_poultry_water_control_structure_future =@field.is_poultry_water_control_structure
    @field.is_poultry_treatment_wetland_future = @field.is_poultry_treatment_wetland
    @field.is_poultry_litter_treatment_future = @field.is_poultry_litter_treatment

    # copy BMPs
    @field.future_bmps.destroy_all

    @field.bmps.each do |bmp|
      @field.future_bmps.build(:bmp_type_id => bmp.bmp_type_id, :is_planned => bmp.is_planned)
    end

    @step = params[:step]

    respond_to do |format|
      if @field.save
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Data imported successfully.' }
      else
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Error importing data.' }
      end
    end

  end

  def run_model

    model_run(@field)
    calculate_bmps(@field)

    redirect_to(:back)

  end

  def run_model_future
    model_run_future(@field)
    calculate_bmps(@field)
    model_run(@field)


    redirect_to(:back)
end

end