

class FieldsController < ApplicationController

  include testolivier

  load_and_authorize_resource :farm
  load_and_authorize_resource :through => :farm
  layout 'farm', :only => [:index]

  add_breadcrumb 'Home', '/'
  add_breadcrumb 'Farms', :farms_path


  # GET /farms/1/fields
  # GET /farms/1/fields.json
  def index

    # @farm = Project.find(params[:farm_id])
    # @fields = @farm.fields
    add_breadcrumb @farm.code, farm_path(@farm)
    add_breadcrumb 'Fields'

    # natural sort fields
    @fields = Naturalsorter::Sorter.sort_by_method(@fields, :name, true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fields }
    end
  end

  # GET /farms/1/fields/1
  # GET /farms/1/fields/1.json
  def show
    # @farm = Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @field }
    end
  end

  # GET /farms/1/fields/new
  # GET /farms/1/fields/new.json
  def new
    # @farm = Project.find(params[:farm_id])
    # @field =@farm.fields.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @field }
    end
  end

  # GET /farms/1/fields/1/edit
  def edit

    add_breadcrumb @farm.code, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name
    # @farm= Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    @step = params[:step] || '1'

  end

  # POST /farms/1/fields
  # POST /farms/1/fields.json
  def create
    #  @farm = Project.find(params[:farm_id])
    # @field =@farm.fields.build(params[:field])

    respond_to do |format|
      if @field.save
        format.html { redirect_to farm_field_url(@farm, @field), notice: 'Field was successfully created.' }
        format.json { render json: @field, status: :created, location: @field }
      else
        format.html { render action: "new" }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /farms/1/fields/1
  # PUT /farms/1/fields/1.json
  def update

    # TODO: exception handling
    ################################################################
    ################################################################
    isOk = true
    begin
    calculations(@field)    # TEST@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    rescue
      isOk = false
    end
    ################################################################
    ################################################################

    # @farm =Project.find(params[:farm_id])
    # field = @farm.fields.find(params[:id])
    @step = params[:step] || '1'

    respond_to do |format|
      if @field.update_attributes(params[:field]) and isOk
        format.html { redirect_to edit_farm_field_url(@farm, @field, :step => @step.to_i+1), notice: 'Field was successfully updated.' }
      else
        format.html { render action: 'edit'}
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
      format.json { head :no_content }
    end
  end

end
