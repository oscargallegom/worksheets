class FieldsController < ApplicationController

  include BmpCalculations
  include Ntt

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
    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name
    # @farm= Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    @step = params[:step] || '1'

    @soil_test_laboratories = SoilTestLaboratory.where(:state_id => @farm.site_state_id) if @step == '2'

    if (@step =='5' && (@field.field_type.id == 1 || @field.field_type.id == 2 || @field.field_type.id == 3)) # perform calculations
      begin
        @current_totals = computeBmpCalculations(@field)
        @ntt_results = @current_totals[:ntt_results]
      rescue Exception => e
        flash[:error] = e.message
        @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0}
      end
      @watershed_segment = WatershedSegment.where(:id => @field.watershed_segment_id).first
      if (@watershed_segment.nil?)
        flash[:error] = "Could not retrieve baseline data." if @watershed_segment.nil?
      end

      # does the field meet baseline - only for Maryland
      if (@farm.site_state_id == 21)
        flash.now[:meet_baseline] ||= []

        # if crop or hay
        if (@field.field_type_id == 1 || @field.field_type_id == 3)
        # check if at least one manure fertilizer incorporated
        is_manure_fertilizer_incorporated = false
        @field.strips.each do |strip|
          strip.crop_rotations.each do |crop_rotation|
            crop_rotation.manure_fertilizer_applications.each do |manure_fertilizer_application|
              if (manure_fertilizer_application.is_incorporated)
                is_manure_fertilizer_incorporated = true
              end
            end
          end
        end
        if (is_manure_fertilizer_incorporated && !is_manure_fertilizer_incorporated)
          flash.now[:meet_baseline] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless all manure applications are incorporated.'
        end
        end
        # if field is pasture
        if (@field.field_type_id == 2 && @field.is_pasture_adjacent_to_stream && !@field.is_streambank_fencing_in_place)
          flash.now[:meet_baseline] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless pastured animals are excluded from the stream.'
        end
        # if crop or pasture or hay
        if (@field.field_type_id == 1 || @field.field_type_id == 2 || @field.field_type_id == 3)
          is_commercial_or_manure_fertilizer = false
          @field.strips.each do |strip|
            strip.crop_rotations.each do |crop_rotation|
              if (!crop_rotation.manure_fertilizer_applications.empty? || !crop_rotation.commercial_fertilizer_applications.empty?)
                is_commercial_or_manure_fertilizer = true
              end
            end
          end
          if (is_commercial_or_manure_fertilizer && @field.is_field_adjacent_water && (!@field.is_forest_buffer && !@field.is_grass_buffer && !@field.is_fertilizer_application_setback))
            flash.now[:meet_baseline] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless you have a fertilizer setback or buffer in place where field is adjacent to water body.'
          end
          # also soil conservation BMP needs to be checked
          is_soil_conservation = false
          @field.bmps.each do |bmp|
              if (bmp.bmp_type_id == 8)       # Soil Conservation and Water Quality Plans
                is_soil_conservation = true
              end
            end
          if (!is_soil_conservation)
            flash.now[:meet_baseline] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless you have an updated soil and water conservation plan.'
          end
        end
      end
    end

    if (@step =='5' && (@field.field_type.id == 4)) # perform calculations for animal confinement
      begin
        @current_totals = computeLivestockBmpCalculations(@field)
      rescue Exception => e
        flash[:error] = e.message
        #@current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0}
      end
      #@baseline_lookup = BaselineLookup.where(:state_id => @farm.site_state_id, :field_type_id => @field.field_type_id, :major_basin => @field.watershed_segment.major_basin).first
      #if (@baseline_lookup.nil?)
      #  flash[:error] = "Could not retrieve baseline data." if @baseline_lookup.nil?
      #end

      # does the field meet baseline - only for Maryland
      if (@farm.site_state_id == 21)
        flash.now[:meet_baseline] ||= []
        if (!@field.field_livestocks.empty? && !@field.is_livestock_animal_waste_management_system) || (!@field.field_poultry.empty? && (!@field.is_poultry_animal_waste_management_system || !@field.is_poultry_mortality_composting))
          flash.now[:meet_baseline] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless the farm cannot meet baseline unless the animal headquarters has both a properly sized and maintained animal waste management system and mortality composting in addition to meeting any and all applicable requirements under Maryland''s Nutrient Management Regulations and CAFO rule.'
        end
        if (!@field.field_poultry.empty? && !@field.is_poultry_heavy_use_pads)
          flash.now[:meet_baseline] << 'Per Maryland Nutrient Management regulations, your farm cannot meet baseline unless heavy use pads are in place'
        end
      end
    end


    @other_fields = []
    @farm.fields.each do |field|
      @other_fields.push(field) if field.id != @field.id
    end


    if session[:debug]
      success, content = buildXml(@field) # TODO: remove/change
      @input_xml = content # TODO: remove/change
      success, content = callNtt(@field) # TODO: remove/change
      if (success)
        @results = Hash.from_xml((content.xpath('//Results')).to_s)['Results']
        @output_xml = content
        if (@results['ErrorCode'] != '0')
          flash[:notice] = 'Could not retrieve NTT info: ' << @results['ErrorDes'] # TODO: check for error!
        end
      else
        flash[:notice] = 'Could not contact NTT: ' << content.to_s
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
        # if step 2 and the user click 'add a crop to rotation'
        if !params[:addCropForStrip].blank?
          strip_index = params[:addCropForStrip].to_i
          format.html { redirect_to new_farm_field_strip_crop_rotation_url(@farm, @field, @field.strips[strip_index]), notice: 'Field was successfully updated.' }
        elsif (@step=='2' && @field.field_type.id == 5) # non-managed land and step 2: got back to farm summary
          format.html { redirect_to farm_url(@farm), notice: 'Field was successfully updated.' }
        else
          #format.html #{ redirect_to edit_farm_field_url(@farm, @field, :step => @step.to_i+1), notice: 'Field was successfully updated.' }
          @step = (@step.to_i+1).to_s

          format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Field was successfully updated.' }
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

    @to_field.strips.destroy_all

    # copy strips from A to B
    is_success = true
    @from_field.strips.each do |strip|
      @from_strip_dup = strip.amoeba_dup
      @from_strip_dup.field_id = @to_field.id
      if !@from_strip_dup.save!(:validate => false)
        is_success = false
      end

    end

    respond_to do |format|
      if is_success
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Copy successful.' }
      else
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Error: could not export.' }
      end
    end
  end


end
