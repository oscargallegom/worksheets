class StripsController < ApplicationController
  load_and_authorize_resource :farm
  load_and_authorize_resource :field, :through => :farm
  load_and_authorize_resource :strip, :through => :field

  # GET /crop_categories/1/crops/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /farms/1/fields/2/strips/new
  def new
    @step = params[:step] || '3'
    @strip.length = 1.0
      @strip.is_future = (@step == '6')
    respond_to do |format|
      if (@strip.save(:validate => false))
      format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Strip was successfully created.' }
      else
        format.html { redirect_to edit_farm_field_path(@farm, @field, :step => @step), notice: 'Error: could not create new strip.' }
        end
    end
  end

end
