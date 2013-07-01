class CropRotationsController < ApplicationController
  load_and_authorize_resource :farm
  load_and_authorize_resource :field, :through => :farm
  load_and_authorize_resource :strip, :through => :field
  load_and_authorize_resource :crop_rotation, :through => :strip

  add_breadcrumb 'Home', '/'
  add_breadcrumb 'Farms', :farms_path

  # GET /farms/1/fields/1/strips/1/crop_rotations/1
  def new
    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name, farm_field_path(@farm, @field)
    add_breadcrumb 'Baseline crop management', edit_farm_field_path(@farm, @field, :step => 3)
    add_breadcrumb 'Strip ' + (@field.strips.find_index(@strip) + 1).to_s
    add_breadcrumb 'Crop ' + @crop_rotation.id.to_s
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /farms/1/fields/1/strips/1/crop_rotations/1
  def show

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
    respond_to do |format|
      if @crop_rotation.save
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Crop was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /farms/1/fields/1/strips/1/crop_rotations/1
  def update
    respond_to do |format|
      if @crop_rotation.update_attributes(params[:crop_rotation])
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Crop was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # /farms/1/fields/1/strips/1/crop_rotations/1
  def destroy
    @crop_rotation.destroy

    respond_to do |format|
      format.html { redirect_to edit_farm_field_path(@farm, @field, 'step' => 3) }
    end
  end

  # /farms/1/fields/1/strips/1/crop_rotations/1
  def duplicate
    @crop_rotation_dup = @crop_rotation.dup #:include => [:fields, :animals]
    respond_to do |format|
      if @crop_rotation_dup.save
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Crop was successfully duplicated.' }
      else
        format.html { redirect_to farms_url, error: 'Could not duplicate crop.' }
      end
    end

  end

end
