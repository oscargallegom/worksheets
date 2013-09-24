class CropRotationsController < ApplicationController

  include Ntt

  load_and_authorize_resource :farm
  load_and_authorize_resource :field, :through => :farm
  load_and_authorize_resource :strip, :through => :field
  load_and_authorize_resource :crop_rotation, :through => :strip

  add_breadcrumb 'Home', :farms_path
  add_breadcrumb 'Projects', :farms_path

  # GET /farms/1/fields/1/strips/1/crop_rotations/1
  def new
    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name, farm_field_path(@farm, @field)
    add_breadcrumb 'Baseline crop management', edit_farm_field_path(@farm, @field, :step => 3)
    add_breadcrumb 'Strip ' + (@field.strips.find_index(@strip) + 1).to_s
    add_breadcrumb 'Crop ' + @crop_rotation.id.to_s

    @step = params[:step] || '3'

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /farms/1/fields/1/strips/1/crop_rotations/1
  def show

    @step = params[:step] || '3'

    ################  TEST
    if session[:debug]
      success, content = buildXml(@field, false) # TODO: remove/change
      @input_xml = content # TODO: remove/change
      success, content = callNtt(@field, false) # TODO: remove/change
      if (success)
        @results = Hash.from_xml((content.xpath('//Results')).to_s)['Results']
        @output_xml = content
        if (@results['ErrorCode'] != '0')
          flash[:error] = 'Could not retrieve NTT info: ' << @results['ErrorDes'] # TODO: check for error!
        end
      else
        flash[:error] = 'Could not contact NTT: ' << content.to_s
      end
    end


    ################  END TEST

    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name, farm_field_path(@farm, @field)
    add_breadcrumb 'Baseline crop management', edit_farm_field_path(@farm, @field, :step => 3)
    add_breadcrumb 'Strip ' + (@field.strips.find_index(@strip) + 1).to_s
    add_breadcrumb 'Crop ' + @crop_rotation.id.to_s

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # POST /farms/1/fields/1/strips/1/crop_rotations/1
  def create
    @step = params[:step] || '3'
    respond_to do |format|
      # TODO: handle second button
      if @crop_rotation.save
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Crop was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /farms/1/fields/1/strips/1/crop_rotations/1
  def update
    # TODO: handle second button
    @step = params[:step] || '3'
    respond_to do |format|
      if @crop_rotation.update_attributes(params[:crop_rotation])
        if (params[:nextPage] == 'Save & Continue')
          format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step.to_i+1), notice: 'Crop was successfully updated.' }
        else
          format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Crop was successfully updated.' }
          # format.html { redirect_to new_farm_field_strip_crop_rotation_path(@farm, @field, @strip), notice: 'Crop was successfully updated.' }
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  # /farms/1/fields/1/strips/1/crop_rotations/1
  def destroy
    @crop_rotation.destroy

    step = @strip.is_future ? 6 : 3

    respond_to do |format|
      format.html { redirect_to edit_farm_field_path(@farm, @field, 'step' => step) }
    end
  end

  # /farms/1/fields/1/strips/1/crop_rotations/1
  def duplicate
    @crop_rotation_dup = @crop_rotation.amoeba_dup
    respond_to do |format|
      if @crop_rotation_dup.save(:validate => false)
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Crop was successfully duplicated.' }
      else
        format.html { redirect_to farms_url, notice: 'Could not duplicate crop rotation.' }
      end
    end

  end

end
